import 'package:big/Providers/mall/MallPovider.dart';
import 'package:big/Screens/Mall/item.dart';
import 'package:big/Screens/stores/storeDetails.dart';
import 'package:big/Widgets/dataManager.dart';
import 'package:big/componets/Error.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/model/Mall/Mall.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class MainStores extends StatefulWidget {
  _MainStoresState createState() => _MainStoresState();
}

class _MainStoresState extends State<MainStores> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Mybar("MainStores", true),
      body: SingleStore(),
    );
  }
}

class SingleStore extends StatefulWidget {
  @override
  _SingleStoreState createState() => _SingleStoreState();
}

class _SingleStoreState extends State<SingleStore> {
  List<MallData> mallDetails = [];
  Future<List<MallData>> _mallDetials() async {
    await MallProvider().getAllMalls().then((res) {
      var data = json.decode(res);
      var body = data["data"] as List;
      mallDetails =
          body.map<MallData>((json) => MallData.fromJson(json)).toList();
    });
    return mallDetails;
  }

  Future<bool> _isFavorate(int id) async {
    var db = DatabaseManager();
    return (await db.getItem(db.mallTable, id)).length > 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _mallDetials(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return CustomErrorWidget();
          }
          if (snapshot.data != null) {
            return Scaffold(
              body: OrientationBuilder(builder: (context, orentaion) {
                return GridView.builder(
                    padding: EdgeInsets.all(10.0),
                    itemCount: snapshot.data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width>600?3:2,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5,
                                    childAspectRatio: 0.8),
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
                                    snapshot.data[index].image,
                                    snapshot.data[index].city,
                                    isFavorate.data,snapshot.data[index].rating,
                                    context, () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            StoreDetails()),
                                  );
                                }, () async {
                                  var db = DatabaseManager();
                                  if (isFavorate.data) {
                                    await db.deleteItem(
                                        db.mallTable, snapshot.data[index].id);
                                  } else {
                                    await db.insertData(db.mallTable,
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
        });
  }
}
