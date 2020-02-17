import 'dart:convert';

import 'package:big/Providers/DataProvider.dart';
import 'package:big/Screens/details.dart';

import 'package:big/Widgets/dataManager.dart';
import 'package:big/componets/Error.dart';
import 'package:big/localization/all_translations.dart';
import 'package:big/model/Productsmodel.dart';
import 'package:flutter/material.dart';

class SearchWidget extends SearchDelegate<String> {
  var db = new DatabaseManager();

  Color favoriteColor = Colors.grey;
  //String text;

  Future<List<Data>> fetchProducts() async {
    List<Data> list = <Data>[];
    await DataProvider().getSreach(query).then((res) {
      var data = json.decode(res);

      var restdata = data["data"];

      list = restdata.map<Data>((json) => Data.fromJson(json)).toList();
    });

    return list;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            if (query == "") {
              close(context, null);
            }
                        query = "";

          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
    //return null;
  }

  build(context) {
    // final productList = query.isEmpty ? suggest : real;

    /*24 is for notification bar on Android*/
    final double itemHeight = MediaQuery.of(context).size.height * 0.36;
    final double itemWidth = MediaQuery.of(context).size.width * 0.40;
    return query.isNotEmpty
        ? FutureBuilder<List<Data>>(
            future: fetchProducts(),
            builder: (context, snapshot) {
              List<Data> productList = snapshot.data;
              if (snapshot.hasError) {
                return CustomErrorWidget();
              }
              if (productList != null && productList.length == 0) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        allTranslations
                            .text("Sorry we couldn't find any matches for you"),
                        style: TextStyle(
                            color: DataProvider().primary,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              }
              return productList != null
                  ? GridView.builder(
                      itemCount: productList.length,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width>600?3:2,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5,
                                    childAspectRatio: 0.8),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Container(
                              child: Card(
                                child: Column(
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      productList[index].isNew
                                                          ? Stack(
                                                              children: <
                                                                  Widget>[
                                                                Transform
                                                                    .translate(
                                                                  offset: Offset(
                                                                      -10.0,
                                                                      -10.0),
                                                                  child:
                                                                      Container(
                                                                    width: 45.0,
                                                                    height:
                                                                        20.0,
                                                                    color: Color(
                                                                        0XFFff2b2b),
                                                                    child: Text(
                                                                      allTranslations
                                                                          .text(
                                                                              "New"),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : SizedBox()
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
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      productList[index].isNew
                                                          ? Stack(
                                                              children: <
                                                                  Widget>[
                                                                Transform
                                                                    .translate(
                                                                  offset: Offset(
                                                                      -10.0,
                                                                      -10.0),
                                                                  child:
                                                                      Container(
                                                                    width: 45.0,
                                                                    height:
                                                                        20.0,
                                                                    color: Color(
                                                                        0XFFff2b2b),
                                                                    child: Text(
                                                                      allTranslations
                                                                          .text(
                                                                              "New"),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : SizedBox()
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
                                                return Container(
                                                  height: double.infinity,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      productList[index].isNew
                                                          ? Stack(
                                                              children: <
                                                                  Widget>[
                                                                Transform
                                                                    .translate(
                                                                  offset: Offset(
                                                                      -10.0,
                                                                      -10.0),
                                                                  child:
                                                                      Container(
                                                                    width: 45.0,
                                                                    height:
                                                                        20.0,
                                                                    color: Color(
                                                                        0XFFff2b2b),
                                                                    child: Text(
                                                                      allTranslations
                                                                          .text(
                                                                              "New"),
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            )
                                                          : SizedBox()
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
                                                builder: (context) =>
                                                    ProductDetails(
                                                        productList[index]
                                                            .id)));
                                      }),
                                    ),
                                    new Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          new Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                child: Row(
                                                  children: <Widget>[
                                                    new Text(
                                                      " ${productList[index].price} \EGY ",
                                                      style: new TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 14,
                                                          color: Color(
                                                              0XFF161a28)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              StatefulBuilder(
                                                  builder: (context, setState) {
                                                return FutureBuilder<bool>(
                                                    future: _isFavorate(
                                                        productList[index].id),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return SizedBox();
                                                      }
                                                      return Container(

                                                        padding:
                                                            EdgeInsets.all(0.0),
                                                        child: new IconButton(
                                                            iconSize: 20.0,
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(0.0),
                                                            alignment: Alignment
                                                                .center,
                                                            icon: Icon(
                                                              Icons.favorite,
                                                              color: snapshot
                                                                      .data
                                                                  ? Colors.red
                                                                  : Colors.grey,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                if (snapshot
                                                                    .data) {
                                                                  deleteFav(
                                                                      productList[
                                                                              index]
                                                                          .id);
                                                                } else {
                                                                  addFav(
                                                                      productList[
                                                                              index]
                                                                          .name,
                                                                      productList[
                                                                              index]
                                                                          .description,
                                                                      productList[
                                                                              index]
                                                                          .cover,
                                                                      productList[
                                                                              index]
                                                                          .price,
                                                                      productList[
                                                                              index]
                                                                          .offer,
                                                                      1,
                                                                      productList[
                                                                              index]
                                                                          .id);
                                                                }
                                                              });
                                                            }),
                                                      );
                                                    });
                                              }),
                                            ],
                                          ),
                                          new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  "${productList[index].price}\EGY",
                                                  style: TextStyle(
                                                      color: Color(0XFF7f7f7f),
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      fontSize: 13,
                                                      decoration: TextDecoration
                                                          .lineThrough),
                                                ),
                                              ]),
                                          new Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                  color: Colors.white,

                                                  child: Text(
                                                    "${productList[index].name}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: new TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize:12,
                                                        color:
                                                            Color(0XFF5d5e62)),
                                                    maxLines: 2,
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
                      },
                    )
                  : Container(
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Text(allTranslations.text('Loading....')),
                            SizedBox(
                              height: 50,
                            ),
                            CircularProgressIndicator()
                          ],
                        ),
                      ),
                    );
            },
          )
        : SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

  return build(context);

  }

  @override
  Widget buildResults(BuildContext context) {
    return build(context);
  }

  Future addFav(String name, String dec, String Image, String price,
      String offer, int isNew, int id) async {
    int ProductSaved = await db
        .saveProduct(new Product(name, dec, Image, price, offer, isNew, id));
  }

  Future deleteFav(int Isfav) async {
    int deleteCustmProduct = await db.deleteProduct(Isfav);
  }

  Future getDataBase(int id) async {
    Product mohamed = await db.getCustomProduct(id);
  }

  Future<bool> _isFavorate(int id) async {
    return (await db.getCustomProduct(id)) != null;
  }
}
