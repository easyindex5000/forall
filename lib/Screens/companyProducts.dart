import 'package:big/Providers/MainProvider.dart';
import 'package:big/componets/Error.dart';
import 'package:big/componets/ErrorScreen.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import '../componets/appBar.dart';
import 'package:big/model/Productsmodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:big/Screens/details.dart';

class CompnayProduct extends StatefulWidget {
  int compId;
  String subtitle;
  CompnayProduct({Key key, this.subtitle, this.compId}) : super(key: key);

  _CompnayProductState createState() => _CompnayProductState();
}

class _CompnayProductState extends State<CompnayProduct> {
  int compId;
  String subtitle;
  _CompnayProductState({this.subtitle, this.compId});

  Future<List<Data>> fetchPro() async {
    final res = await http.get(MainProvider().baseUrl + "/company/1");
    List<Data> list = <Data>[];

    if (res.statusCode == 200) {
      var data = json.decode(res.body);

      var restdata = data["data"];

      list = restdata.map<Data>((json) => Data.fromJson(json)).toList();
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Mybar(widget.subtitle, true),
      body: new Column(
        children: <Widget>[
          //padding widget
          //grid view
          Flexible(child: ProductsCompany(a: fetchPro())),
        ],
      ),
    );
  }
}

class ProductsCompany extends StatefulWidget {
  Future<List<Data>> a;
  ProductsCompany({this.a});
  @override
  _ProductsCompanyState createState() => _ProductsCompanyState(a: a);
}

class _ProductsCompanyState extends State<ProductsCompany> {
  Future<List<Data>> a;

  _ProductsCompanyState({this.a});

  @override
  Widget build(
    BuildContext context, [
    bool isFavorite,
  ]) {

    final double itemHeight = MediaQuery.of(context).size.height * 0.36;
    final double itemWidth = MediaQuery.of(context).size.width * 0.40;

    return FutureBuilder<List<Data>>(
      future: a
        ..catchError((onError) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => ErrorScreen()));
        }),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CustomErrorWidget();
        }
        List<Data> productList = snapshot.data;
        List<int> favId = [];
        return productList != null
            ? GridView.builder(
                itemCount: productList.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width>600?3:2,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5,
                                    childAspectRatio: 0.8),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Container(
                        child: Card(
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: InkWell(child: Builder(builder: (
                                  context,
                                ) {
                                  bool hasError = false;
                                  return FutureBuilder(
                                      future: precacheImage(
                                          NetworkImage(
                                              productList[index].cover),
                                          context, onError: (_, __) {
                                        hasError = true;
                                      }),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState !=
                                            ConnectionState.done) {
                                          return new Container(
                                            height: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Stack(
                                                  children: <Widget>[
                                                    Transform.translate(
                                                      offset:
                                                          Offset(-10.0, -10.0),
                                                      child: Container(
                                                        width: 45.0,
                                                        height: 20.0,
                                                        color:
                                                            Color(0XFFff2b2b),
                                                        child: Text(
                                                          allTranslations
                                                              .text("New"),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            decoration: new BoxDecoration(
                                              color: Colors.grey,
                                            ),
                                          );
                                        }
                                        if (!hasError &&
                                            snapshot.connectionState ==
                                                ConnectionState.done) {
                                          return new Container(
                                            height: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Stack(
                                                  children: <Widget>[
                                                    Transform.translate(
                                                      offset:
                                                          Offset(-10.0, -10.0),
                                                      child: Container(
                                                        width: 45.0,
                                                        height: 20.0,
                                                        color:
                                                            Color(0XFFff2b2b),
                                                        child: Text(
                                                          allTranslations
                                                              .text("New"),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            decoration: new BoxDecoration(
                                              image: new DecorationImage(
                                                  fit: BoxFit.contain,
                                                  image: NetworkImage(
                                                      productList[index]
                                                          .cover)),
                                            ),
                                          );
                                        } else {
                                          return new Container(
                                            height: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Stack(
                                                  children: <Widget>[
                                                    Transform.translate(
                                                      offset:
                                                          Offset(-10.0, -10.0),
                                                      child: Container(
                                                        width: 45.0,
                                                        height: 20.0,
                                                        color:
                                                            Color(0XFFff2b2b),
                                                        child: Text(
                                                          allTranslations
                                                              .text("New"),
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            decoration: new BoxDecoration(
                                              image: new DecorationImage(
                                                  fit: BoxFit.contain,
                                                  image: AssetImage(
                                                      "lib/assets/images/errorImage.png")),
                                            ),
                                          );
                                        }
                                      });
                                }), onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductDetails(
                                              productList[index].id)));
                                }),
                              ),
                              new Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            color: Colors.white,

                                            child: Text(
                                              "${productList[index].name}",
                                              overflow: TextOverflow.ellipsis,
                                              style: new TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                  color: Colors.black),
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    new Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                                                                  child: Container(
                                            child: Row(
                                              children: <Widget>[
                                                Expanded(
                                                                                                  child: new Text(
                                                    " ${productList[index].price} \EGY ",
                                                    style: new TextStyle(
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 14,
                                                        color: Color(0XFF161a28)),
                                                  ),
                                                ),
                                                Expanded(
                                                                                                  child: Text(
                                                    "${productList[index].offer}\EGY",
                                                    style: TextStyle(
                                                        color: Color(0XFF7f7f7f),
                                                        fontWeight: FontWeight.w100,
                                                        fontSize: 12,
                                                        decoration: TextDecoration
                                                            .lineThrough),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ));
                })
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
      },
    );
  }
}
