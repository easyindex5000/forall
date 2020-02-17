import 'dart:convert';

import 'package:big/Providers/mall/MallPovider.dart';
import 'package:big/Screens/Mall/Products.dart';
import 'package:big/Screens/Mall/Store.dart';
import 'package:big/Widgets/dataManager.dart';
import 'package:big/componets/Error.dart';
import 'package:big/componets/ErrorScreen.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/localization/all_translations.dart';
import 'package:big/model/Mall/Stores.dart';
import 'package:big/model/Productsmodel.dart';
import 'package:flutter/material.dart';

import 'item.dart';

class Stores extends StatefulWidget {
  final int mallID;

  const Stores({Key key, this.mallID}) : super(key: key);
  @override
  _StoresState createState() => _StoresState();
}

class _StoresState extends State<Stores> {
  List<Store> mallDetails = [];
  Future<List<Store>> _getStores() async {
    await MallProvider().getMallStores(widget.mallID).then((res) {
      var data = json.decode(res);
      var body = data["data"] as List;
      mallDetails = body
          .map<Store>((json) => Store.fromJson(json)..mallID = widget.mallID)
          .toList();
    });
    return mallDetails;
  }

  Future<bool> _isFavorate(int id) async {
    var db = DatabaseManager();
    return (await db.getItem(db.storeTable, id)).length > 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Mybar(allTranslations.text('Store'), false),
      body: FutureBuilder(
          future: _getStores()..catchError((onError){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>ErrorScreen()));
                }),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return CustomErrorWidget();
            }
            if(snapshot.data!=null&&snapshot.data.length==0){
              return Center(child: Text(allTranslations.text("no data")),);
            }
            if (snapshot.data != null) {
              return Scaffold(
                body: OrientationBuilder(builder: (context, orentaion) {
                  return GridView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemCount: snapshot.data.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 144 / 165,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 17),
                      itemBuilder: (BuildContext context, int index) {
                        return StatefulBuilder(builder: (context, setState) {
                          return FutureBuilder(
                              future: _isFavorate(snapshot.data[index].id),
                              builder: (context, isFavorate) {
                                if (snapshot.hasError) {
                                  return CustomErrorWidget();
                                }
                                if (isFavorate.hasData) {
                                  return item(
                                      snapshot.data[index].id,
                                      snapshot.data[index].name,
                                      snapshot.data[index].cover,
                                      snapshot.data[index].location,
                                      isFavorate.data,snapshot.data[index].rating,
                                      context, () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                StoreScreen(
                                                    // mallID: widget.mallID,
                                                    // storeID:
                                                    //     snapshot.data[index].id,
                                                    )));
                                  }, () async {
                                    var db = DatabaseManager();
                                    if (isFavorate.data) {
                                      await db.deleteItem(db.storeTable,
                                          snapshot.data[index].id);
                                    } else {
                                      await db.insertData(db.storeTable,
                                          snapshot.data[index].toJson());
                                    }
                                    setState(() {});
                                  });
                                } else {
                                  return SizedBox();
                                }
                              });
                        });
                      });
                }),
              );
            } else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }
}
