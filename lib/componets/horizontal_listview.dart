import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/MainProvider.dart';
import 'package:big/Screens/SubCategory.dart';
import 'package:big/componets/Error.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:big/model/Category.dart';
import 'package:big/componets/products.dart';
import 'package:big/Screens/SubSubCategory.dart';

class HorizontalList extends StatelessWidget {
  final int catId;
  HorizontalList(this.catId);

  Future<List<Category>> fetchdata() async {
    final res = await http.get(MainProvider().baseUrl + "/categories/$catId");
    List<Category> list;

    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var rest = data["data"]["children"] as List;
      list = rest.map<Category>((json) => Category.fromJson(json)).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          height: MediaQuery.of(context).size.height * 0.17,
          child: FutureBuilder<List<Category>>(
              future: fetchdata(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return CustomErrorWidget();
                }

                if (!snapshot.hasData) {
                  return Center(child: Text(allTranslations.text("no data")));
                }

                List<Category> mylist = snapshot.data;
                return mylist != null
                    ? ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: mylist.length,
                        itemBuilder: ((BuildContext context, int index) {
                             return AspectRatio(
                aspectRatio: 1.3,
                child: Container(
                    decoration: BoxDecoration(
                      //    border: Border.all(color: Colors.black),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2.0,
                        )
                      ],
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFffffff), Color(0xFFffffff)]),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: InkWell(
                      onTap: () {
                         Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                SubSubCategory(
                                                  catID: mylist[index].id,
                                                  subtitle: mylist[index].name,attribudes: [],
                                                )));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 6,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 7.0),
                              width: MediaQuery.of(context).size.width * 0.13,
                              child: FittedBox(
                                child: Icon(
                                  IconData(int.parse(mylist[index].iconCode),
                                      fontFamily: mylist[index].iconFont),
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            mylist[index].name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer()
                        ],
                      ),
                    )),
              );
           
                        }),
                      )
                    : Container(
                        child: Center(
                        child: Column(
                          children: <Widget>[
                            Text(allTranslations.text("Loading....")),
                            SizedBox(
                              height: 20,
                            ),
                            CircularProgressIndicator()
                          ],
                        ),
                      ));
              })),
    );
  }
}
