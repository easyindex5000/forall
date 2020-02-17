import 'package:big/Providers/DataProvider.dart';
import 'package:big/Screens/details.dart';
import 'package:big/Screens/login.dart';
import 'package:big/Screens/whishlist.dart';
import 'package:big/Widgets/dataManager.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/localization/all_translations.dart';
import 'package:big/model/Productsmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:async/async.dart';

class SeeMore extends StatefulWidget {
  final List<Data> items;
  SeeMore(this.items);

  @override
  _SeeMoreState createState() => _SeeMoreState();
}

class _SeeMoreState extends State<SeeMore> {
  var db = new DatabaseManager();

  AsyncMemoizer _memorizer = AsyncMemoizer();

  @override
  Widget build(BuildContext context, [bool isFavorite]) {

    final double itemHeight = MediaQuery.of(context).size.height * 0.36;
    final double itemWidth = MediaQuery.of(context).size.width * 0.40;

    return Scaffold(
      appBar: Mybar(allTranslations.text("See More"), true),
      body: GridView.builder(
        itemCount: widget.items.length,
        gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width>600?3:2,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5,
                                    childAspectRatio: 0.8),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: InkWell(onTap:(){
                 Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetails(widget.items[index].id)));
            } ,
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
                                NetworkImage(widget.items[index].cover), context,
                                onError: (_, __) {
                              hasError = true;
                            }),
                            builder: (context, snapshot) {
                              if (!hasError &&
                                  snapshot.connectionState ==
                                      ConnectionState.done) {
                                if (snapshot.connectionState !=
                                    ConnectionState.done) {
                                  return new Container(
                                    height: double.infinity,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        if (widget.items[index].isNew)
                                          Stack(
                                            children: <Widget>[
                                              Transform.translate(
                                                offset: Offset(-10.0, -10.0),
                                                child: Container(
                                                  width: 45.0,
                                                  height: 20.0,
                                                  color: Color(0XFFff2b2b),
                                                  child: Text(
                                                    allTranslations.text("New"),
                                                    textAlign: TextAlign.center,
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
                                return new Container(
                                  height: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      if (widget.items[index].isNew)
                                        Stack(
                                          children: <Widget>[
                                            Transform.translate(
                                              offset: Offset(-10.0, -10.0),
                                              child: Container(
                                                width: 45.0,
                                                height: 20.0,
                                                color: Color(0XFFff2b2b),
                                                child: Text(
                                                  allTranslations.text("New"),
                                                  textAlign: TextAlign.center,
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
                                            widget.items[index].cover)),
                                  ),
                                );
                              } else {
                                return new Container(
                                  height: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      if (widget.items[index].isNew)
                                        Stack(
                                          children: <Widget>[
                                            Transform.translate(
                                              offset: Offset(-10.0, -10.0),
                                              child: Container(
                                                width: 45.0,
                                                height: 20.0,
                                                color: Color(0XFFff2b2b),
                                                child: Text(
                                                  allTranslations.text("New"),
                                                  textAlign: TextAlign.center,
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
                                builder: (context) =>
                                    ProductDetails(widget.items[index].id)));
                      }),
                    ),
                    new Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    new Text(
                                      " ${widget.items[index].price} \EGY ",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize:14,
                                          color: Color(0XFF161a28)),
                                    ),
                                  ],
                                ),
                              ),
                              StatefulBuilder(builder: (context, setState) {
                                return FutureBuilder<bool>(
                                    future: _isFavorate(widget.items[index].id),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return SizedBox();
                                      }
                                      return Container(

                                        padding: EdgeInsets.all(0.0),
                                        child: new IconButton(
                                            iconSize: 20.0,
                                            padding: const EdgeInsets.all(0.0),
                                            alignment: Alignment.center,
                                            icon: Icon(
                                              Icons.favorite,
                                              color: snapshot.data
                                                  ? Colors.red
                                                  : Colors.grey,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                if (snapshot.data) {
                                                  deleteFav(
                                                      widget.items[index].id);
                                                } else {
                                                  addFav(
                                                      widget.items[index].name,
                                                      widget.items[index]
                                                          .description,
                                                      widget.items[index].cover,
                                                      widget.items[index].price,
                                                      widget.items[index].offer,
                                                      1,
                                                      widget.items[index].id);
                                                }
                                              });
                                            }),
                                      );
                                    });
                              }),
                            ],
                          ),
                          new Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "${widget.items[index].price}\EGY",
                                  style: TextStyle(
                                      color: Color(0XFF7f7f7f),
                                      fontWeight: FontWeight.w100,
                                      fontSize:13,
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ]),
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  color: Colors.white,

                                  child: Text(
                                    "${widget.items[index].name}",
                                    overflow: TextOverflow.ellipsis,
                                    style: new TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize:12,
                                        color: Color(0XFF5d5e62)),
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Consumer<DataProvider>(
                            builder: (context, dataProvider, _) => (Container(
                              width: double.infinity,
                              child: RaisedButton(
                                color: DataProvider().primary,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProductDetails(
                                              widget.items[index].id)));
                                },
                                child: Text(allTranslations.text("ADD TO BAG"),
                                    style: TextStyle(color: Colors.white)),
                              ),
                            )),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
            ),
          );
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

  Future getDataBase(int id) async {
    Product mohamed = await db.getCustomProduct(id);
  }

  Future<bool> _isFavorate(int id) async {
    return (await db.getCustomProduct(id)) != null;
  }
}
