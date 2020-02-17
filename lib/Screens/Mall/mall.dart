import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/mall/MallPovider.dart';
import 'package:big/Screens/Mall/mallDetails.dart';
import 'package:big/Widgets/dataManager.dart';
import 'package:big/componets/Error.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/localization/all_translations.dart';
import 'package:big/model/Mall/Mall.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:big/componets/searchWidget.dart';
import 'item.dart';
import 'package:async/async.dart';

class Malls extends StatefulWidget {
  _MallsState createState() => _MallsState();
}

class _MallsState extends State<Malls> {
  String appBarTitle = "${allTranslations.text('malls')}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Mybar(appBarTitle, true),
      body: Mall(),
    );
  }
}

class Mall extends StatefulWidget {
  @override
  _MallState createState() => _MallState();
}

class _MallState extends State<Mall> {
  AsyncMemoizer _memoizer = AsyncMemoizer();
  List<MallData> mallDetails = [];
  Future<List<MallData>> _mallDetials() async {
    await MallProvider().getAllMalls().then((res) {
      try{
    var data = json.decode(res);
      print(res);
      var body = data["data"] as List;
      mallDetails =
          body.map<MallData>((json) => MallData.fromJson(json)).toList();
      }catch(e){
        print(e);
      }
  
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
        future:_memoizer.runOnce((){
return _mallDetials();
        }) ,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget();
          }
          if (snapshot.data != null && snapshot.data.length == 0) {
            return Center(
              child: Text(allTranslations.text("no data")),
            );
          }
          if (snapshot.data != null) {
            print(snapshot.data[0].toJson());
            return Scaffold(
              body: OrientationBuilder(builder: (context, orentaion) {
                return ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 2),
                      child: Material(
                        elevation: 5.0,
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        child: InkWell(
                          onTap: () {
                            showSearch(
                                context: context, delegate: SearchWidget());
                          },
                          child: Container(

                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.search,
                                    color: DataProvider().primary,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "search",
                                    style: TextStyle(
                                        color: DataProvider().primary),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                    GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
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
                                        snapshot.data[index].image,
                                        snapshot.data[index].city,
                                        isFavorate.data,snapshot.data[index].rating,
                                        context, () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                MallDetails(
                                                  id: snapshot.data[index].id,
                                                )),
                                      );
                                    }, () async {

                                      var db = DatabaseManager();
                                      if (isFavorate.data) {
                                        await db.deleteItem(db.mallTable,
                                            snapshot.data[index].id);
                                      } else {
                                        await db.insertData(db.mallTable,
                                            snapshot.data[index].toJson());
                                      }
                                  print(await    db.getItem(db.mallTable, snapshot.data[index].id));
                                      setState(() {});
                                    });
                                  } else {
                                    return SizedBox();
                                  }
                                });
                          });
                        }),
                  ],
                );
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
