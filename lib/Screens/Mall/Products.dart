import 'dart:convert';

import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/mall/MallPovider.dart';
import 'package:big/Screens/details.dart';
import 'package:big/Widgets/dataManager.dart';
import 'package:big/componets/Error.dart';
import 'package:big/componets/ErrorScreen.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/localization/all_translations.dart';
import 'package:big/model/Productsmodel.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../login.dart';

class Products extends StatefulWidget {
  final int mallID, storeID;

  const Products({Key key, this.mallID, this.storeID}) : super(key: key);
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  AsyncMemoizer _memorizer = AsyncMemoizer();
  var db = new DatabaseManager();
  List<int> favorateIds = [];

  List<Data> productList;
  @override
  Widget build(BuildContext context, [bool isFavorite]) {

    final double itemHeight = MediaQuery.of(context).size.height * 0.36;
    final double itemWidth = MediaQuery.of(context).size.width * 0.40;

    return Scaffold(
      appBar: Mybar(allTranslations.text('products'), true),
      body: FutureBuilder(
        future: _memorizer.runOnce(() async {
          await MallProvider()
              .getStoreProducts(widget.mallID, widget.storeID)
              .then((res) {
            var data = json.decode(res);
            var restdata = data["data"];
            productList =
                restdata.map<Data>((json) => Data.fromJson(json)).toList();
            setState(() {});
          });
        })
          ..catchError((onError) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => ErrorScreen()));
          }),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget();
          }
          if (snapshot.connectionState == ConnectionState.done &&
              productList != null &&
              productList.length > 0) {
            return GridView.builder(
                itemCount: productList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width>600?3:2,
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
                            child: Expanded(
                              child: InkWell(child: Builder(builder: (
                                context,
                              ) {
                                bool hasError = false;
                                return FutureBuilder(
                                    future: precacheImage(
                                        NetworkImage(productList[index].cover),
                                        context, onError: (_, __) {
                                      hasError = true;
                                    }),
                                    builder: (context, snapshot) {
                                      if (ConnectionState.done !=
                                          snapshot.connectionState) {
                                        return new Container(
                                          height: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              if (productList[index].isNew)
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
                                              if (productList[index].isNew)
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
                                                    productList[index].cover)),
                                          ),
                                        );
                                      } else {
                                        return Container(
                                          height: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              if (productList[index].isNew)
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
                          ),
                          new Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                new Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          new Text(
                                            " ${productList[index].price} \EGY ",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                color: Color(0XFF161a28)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    StatefulBuilder(
                                        builder: (context, setState) {
                                      return Container(
                                        padding: EdgeInsets.all(0.0),
                                        child: new IconButton(
                                            iconSize: 20.0,
                                            padding: const EdgeInsets.all(0.0),
                                            alignment: Alignment.center,
                                            icon: Icon(
                                              Icons.favorite,
                                              color: favorateIds.contains(
                                                      productList[index].id)
                                                  ? Colors.red
                                                  : Colors.grey,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (favorateIds.contains(
                                                    productList[index].id)) {
                                                  favorateIds.remove(
                                                      productList[index].id);
                                                  deleteFav(
                                                      productList[index].id);
                                                } else {
                                                  favorateIds.add(
                                                      productList[index].id);
                                                  addFav(
                                                      productList[index].name,
                                                      productList[index]
                                                          .description,
                                                      productList[index].cover,
                                                      productList[index].price,
                                                      productList[index].offer,
                                                      1,
                                                      productList[index].id);
                                                }
                                              });
                                            }),
                                      );
                                    }),
                                  ],
                                ),
                                new Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        "${productList[index].price}\EGY",
                                        style: TextStyle(
                                            color: Color(0XFF7f7f7f),
                                            fontWeight: FontWeight.w100,
                                            fontSize:
                                                13,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                    ]),
                                new Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        color: Colors.white,

                                        child: Text(
                                          "${productList[index].name}",
                                          overflow: TextOverflow.ellipsis,
                                          style: new TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize:
                                                 12,
                                              color: Color(0XFF5d5e62)),
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Consumer<DataProvider>(
                                  builder: (context, dataProvider, _) =>
                                      (Container(
                                    width: double.infinity,
                                    child: RaisedButton(
                                      color: DataProvider().primary,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetails(
                                                        productList[index]
                                                            .id)));
                                      },
                                      child: Text(
                                          allTranslations.text("ADD TO BAG"),
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  )),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )),
                  );
                });
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                child: Center(
              child: Column(
                children: <Widget>[
                  Text(allTranslations.text('Loading....')),
                  SizedBox(
                    height: 20,
                  ),
                  CircularProgressIndicator()
                ],
              ),
            ));
          } else {
            return Center(
              child: Text(allTranslations.text("no data")),
            );
          }
        },
      ),
    );
  }

  Future addFav(String name, String dec, String Image, String price,
      String offer, int isNew, int id) async {
    int ProductSaved = await db
        .saveProduct(new Product(name, dec, Image, price, offer, isNew, id));
  }

  Future deleteFav(int Isfav) async {
    int deleteCustmProduct = await db.deleteProduct(Isfav);
  }
}
