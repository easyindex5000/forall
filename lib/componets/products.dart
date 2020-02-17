import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/MainProvider.dart';
import 'package:big/Screens/details.dart';

import 'package:big/Widgets/dataManager.dart';
import 'package:big/componets/Error.dart';

import 'package:big/localization/all_translations.dart';
import 'package:big/model/Productsmodel.dart';
import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:async/async.dart';


class ProductsWidget extends StatefulWidget {
  final int catId;
  String sorttype = "";
  String ordertype = "";
  List attribudes;
  List brandIDs;
  int minPrice, maxPrice;
  Key key;

  ProductsWidget(
      {this.catId,
      this.sorttype,
      this.ordertype,
      this.brandIDs,
      this.attribudes,
      this.minPrice,
      this.maxPrice});

  @override
  _ProductsWidgetState createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  var db = new DatabaseManager();
  List<Data> productList;
  Future fetcProductfilter() async {
    var res = await DataProvider().filterProduct(widget.catId,
        minPrice: widget.minPrice,
        maxPrice: widget.maxPrice,
        attribudes: widget.attribudes.join(","),
        brand: widget.brandIDs.join(","),
       );

    var data = json.decode(res);
    var restdata = data["data"];

    productList = restdata.map<Data>((json) => Data.fromJson(json)).toList();

    setState(() {});
  }

  Future fetchProductSort() async {
    final res = await http.get(MainProvider().baseUrl +
        "/categories/${widget.catId}/products?sort=${widget.sorttype}&order=${widget.ordertype}");
    if (res.statusCode == 200) {
      var data = json.decode(res.body);

      var restdata = data["data"];

      productList = restdata.map<Data>((json) => Data.fromJson(json)).toList();
    }
    setState(() {});
  }

  Future fetchPro() async {
 
    if (widget.sorttype != "" && widget.ordertype != "") {
      widget.brandIDs = null;
      widget.attribudes = null;

      await fetchProductSort();

      return;
    } else if (widget.attribudes != null ||
        widget.brandIDs != null ) {
      widget.sorttype = null;
      widget.ordertype = null;

      await fetcProductfilter();

      return;
    } else {
      final res = await http
          .get(MainProvider().baseUrl + "/categories/${widget.catId}");
      if (res.statusCode == 200) {
        var data = json.decode(res.body);
        var restdata = data["data"]["products"];
        productList =
            restdata.map<Data>((json) => Data.fromJson(json)).toList();
        setState(() {});
      }
    }
  }

  AsyncMemoizer _memorizer = AsyncMemoizer();

  Color favoriteColor = Colors.grey;
  @override
  Widget build(BuildContext context, [bool isFavorite]) {
    return FutureBuilder(
      key: UniqueKey(),
      future: _memorizer.runOnce(() async {
        await fetchPro();
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
                                    childAspectRatio: 0.6),
              itemBuilder: (BuildContext context, int index) {

                return Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetails(productList[index].id)));
                      },
                      child: Container(
                          child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
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
                                      if (snapshot.connectionState !=
                                          ConnectionState.done) {
                                        return new Container(
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
                            new Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                                            if(productList[index].offer!=null)
                                            new Text(
                                              " ${productList[index].offer} \USD ",
                                              style: new TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize:14,
                                                  color: Color(0XFF161a28)),
                                            ),
                                            if(productList[index].offer==null)
                                                new Text(
                                              " ${productList[index].price} \USD ",
                                              style: new TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize:14,
                                                  color: Color(0XFF161a28)),
                                            ),
                                          ],
                                        ),
                                      ),
                                      StatefulBuilder(
                                          builder: (context, setState) {
                                        return FutureBuilder<bool>(
                                            future: _isFavorate(
                                                productList[index].id),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return SizedBox();
                                              }
                                              return Container(

                                                padding: EdgeInsets.all(0.0),
                                                child: new InkWell(
                                                    
                                                    child: Icon(
                                                      Icons.favorite,
                                                      color: snapshot.data
                                                          ? Colors.red
                                                          : Colors.grey,size: 20,
                                                    ),
                                                    onTap: () {
                                                      int isNew;
                                                      setState(() {
                                                        if (snapshot.data) {
                                                          deleteFav(
                                                              productList[index]
                                                                  .id);
                                                        } else {
                                                          (productList[index]
                                                                      .isNew ==
                                                                  true)
                                                              ? isNew = 1
                                                              : isNew = 0;
                                                          addFav(
                                                              productList[index]
                                                                  .name,
                                                              productList[index]
                                                                  .description,
                                                              productList[index]
                                                                  .cover,
                                                              productList[index]
                                                                  .price,
                                                              productList[index]
                                                                  .offer,
                                                              isNew,
                                                              productList[index]
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
                                          if(productList[index].offer!=null)
                                        Text(
                                          "${productList[index].price}\ USD",
                                          style: TextStyle(
                                              color: Color(0XFF7f7f7f),
                                              fontWeight: FontWeight.w100,
                                              fontSize: 13,
                                              decoration:
                                                  TextDecoration.lineThrough),
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
                                            overflow: TextOverflow.ellipsis,
                                            style: new TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12,
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
                    ));
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
    );
  }

  Future addFav(String name, String dec, String Image, String price,
      String offer, int isNew, int id) async {
     await db
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
