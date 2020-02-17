import 'dart:async';
import 'dart:convert';
import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/Mazad/mazadProvider.dart';
import 'package:big/Screens/login.dart';
import 'package:big/Screens/mazad/ActionProduct.dart';
import 'package:big/Screens/mazad/Auctions.dart';
import 'package:big/Screens/mazad/Notifications.dart';
import 'package:big/Screens/mazad/sellItems.dart';
import 'package:big/componets/Error.dart';
import 'package:big/componets/ErrorScreen.dart';
import 'package:big/componets/MainDrawer.dart';
import 'package:big/componets/filter.dart';
import 'package:big/componets/shopping_icons.dart';
import 'package:big/localization/all_translations.dart';
import 'package:big/model/mazad/auctionProduct.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:async/async.dart';

class MazadHome extends StatefulWidget {
  @override
  _MazadHomeState createState() => _MazadHomeState();
}

class _MazadHomeState extends State<MazadHome> {
  List<AuctionProduct> products = [];
  AsyncMemoizer _memorizer = AsyncMemoizer();
  bool isLoading = false;
  @override
  void dispose() {
    super.dispose();
  }

  getInitData() async {
    await MazadProvider().getproducts().then((res) {
      products = [];
      json.decode(res)["data"].forEach((item) {
        products.add(AuctionProduct.fromJson(item));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final double itemHeight = MediaQuery.of(context).size.height * 0.36;
    final double itemWidth = MediaQuery.of(context).size.width * 0.40;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: mainDrawer(context, "mazadHome"),
      appBar: AppBar(
        backgroundColor: Colors.white,title: Text(allTranslations.text("Auction")),
        elevation: 0,
        actions: <Widget>[
          FutureBuilder<int>(
              future: MazadProvider().notificationLength(),
              builder: (context, snapshot) {
                if (snapshot.hasError || !snapshot.hasData) {
                  return SizedBox();
                }

                return InkWell(
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    if (prefs.containsKey("userName")) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MazadNotifications()));
                    } else {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    }
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.notifications,
                        color: DataProvider().primary,
                      ),
                      Positioned(
                        top: 15,
                        left: 7,
                        child: CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 7,
                            child: Text(
                              snapshot.data.toString(),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            )),
                      )
                    ],
                  ),
                );
              }),
          PopupMenuButton(
            padding: EdgeInsets.all(0),
            onSelected: (value) async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              if (!prefs.containsKey("userToken")) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              } else if (value == "auction") {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Auctions()));
              } else {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SellItems()));
              }
            },
            icon: Icon(
              Icons.more_vert,
              color: DataProvider().primary,
            ),
            itemBuilder: (contex) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  value: "auction",
                  child: Row(
                    children: <Widget>[
                      Text(allTranslations.text("Auction")),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Shopping.auction,
                        color: DataProvider().primary,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: "sells",
                  child: Row(
                    children: <Widget>[
                      Text(allTranslations.text("Sells")),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Shopping.earn,
                        color: DataProvider().primary,
                      ),
                    ],
                  ),
                )
              ];
            },
          ),
        ],
        leading: Builder(builder: (
          context,
        ) {
          return IconButton(
            padding: EdgeInsets.all(0),
            color: DataProvider().primary,
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
      ),
      body: ChangeNotifierProvider(
          create: (BuildContext context) => MazadProvider(),
          child: FutureBuilder(
            future: _memorizer.runOnce(() async {
              return await getInitData();
            })
              ..catchError((onError) {
                print(onError);
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => ErrorScreen()));
              }),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(key: Key("key"),
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      margin: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width * 8.6 / 100,
                          vertical: 10),
                      decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          shadows: [
                            BoxShadow(
                                color: Color(0xff80c6c6c6),
                                offset: Offset(3, 3),
                                blurRadius: 6)
                          ]),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.search,
                            color: DataProvider().primary,
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: TextField(
                                maxLines: 1,
                                decoration: InputDecoration(
                                    hintText: allTranslations
                                        .text("Search for Auction"),
                                    counterText: "",
                                    hintStyle: TextStyle(
                                        color: DataProvider().primary,
                                        fontSize: 14),
                                    border: InputBorder.none),
                                style: TextStyle(
                                    color: DataProvider().primary,
                                    fontSize: 14),
                                onChanged: (String value) async {
                                  myTimer(value);
                                },
                                maxLength: 30,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 32,
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width * 6.7 / 100),
                      color: Color(0XFFf4f4f4),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(),
                          Row(
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  _bottomSearchSheet(
                                    context,
                                    'Sort By',
                                  );
                                },
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      allTranslations.text("sort by"),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff707070)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Shopping.swap_vertical,
                                        size: 20, color: Color(0xff707070))
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () async {
                                  var result = await _bottomSheetFilter();
                                  if (result != null) {
                                    products = [];
                                    isLoading = true;

                                    setState(() {});

                                    List<int> ids = [];
                                    result[1].forEach((item) {
                                      ids.addAll(item.selectedValues);
                                    });
                                    var res = await MazadProvider()
                                        .filterProducts(
                                            minPrice: result[0][0]
                                                .rangeValues
                                                .start
                                                .toInt(),
                                            maxPrice: result[0][0]
                                                .rangeValues
                                                .end
                                                .toInt(),
                                            category: ids.join(","));
                                    products = [];
                                    json.decode(res)["data"].forEach((item) {
                                      products
                                          .add(AuctionProduct.fromJson(item));
                                    });
                                    isLoading = false;

                                    setState(() {});
                                  }
                                },
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      allTranslations.text("Filter"),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff707070)),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Shopping.path_263,
                                        size: 12, color: Color(0xff707070))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Builder(builder: (
                        context,
                      ) {
                        if (isLoading) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        //   return Wrap(
                        //   runAlignment: WrapAlignment.start,
                        //   alignment: WrapAlignment.start,
                        //   crossAxisAlignment: WrapCrossAlignment.center,
                        //   children: List.generate(products.length + 1, (index) {
                        //     if (index == products.length) {
                        //       return SizedBox(
                        //         width: double.infinity,
                        //       );
                        //     }
                        //     return ProductAuctionWidget(
                        //       product: products[index],
                        //     );
                        //   }),
                        // );
                        return GridView.builder(
                            itemCount: products.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        MediaQuery.of(context).size.width > 600
                                            ? 3
                                            : 2,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5,
                                    childAspectRatio: 0.8),
                            itemBuilder: (BuildContext context, int index) {
                              return ProductAuctionWidget(
                                product: products[index],
                              );
                            });
                      int numberPerRow =
                            (MediaQuery.of(context).size.width / 150).floor();
                        int numberofRows =
                            (products.length / numberPerRow).ceil();
                        return SingleChildScrollView(
                          child: Column(
                            children: List.generate(numberofRows, (rowIndex) {
                              return Row(
                                  children: List.generate(numberPerRow,
                                      (productIndex) {
                                if (numberPerRow * rowIndex + productIndex <
                                    products.length)
                                  return ProductAuctionWidget(
                                    product: products[
                                        numberPerRow * rowIndex + productIndex],
                                  );
                                else
                                  return Expanded(
                                    child: SizedBox(),
                                  );
                              }));
                            }),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: DataProvider().primary,
                        child: Icon(
                          Icons.add_alert,
                          size: 70,
                        ),
                        radius: 70,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(allTranslations
                          .text("you didn't bind in any acution")),
                    ],
                  ),
                );
              }
            },
          )),
    );
  }

  void _bottomSearchSheet(
    BuildContext context,
    String name,
  ) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: Color(0XFF737373),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Material(
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.only(
                        topLeft: new Radius.circular(15.0),
                        topRight: new Radius.circular(15.0))),
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 3.0, left: 3.0, bottom: 1.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    //mainAxisSize: MainAxisSize.max,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      header(name),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                            top: BorderSide(
                                width: 1.0,
                                color: Color(0xFF5d5e62).withOpacity(0.3)),
                            bottom: BorderSide(
                                width: 1.0,
                                color: Color(0xFF5d5e62).withOpacity(0.3)),
                          )),
                          child: ListView(
                            children: <Widget>[
                              _createTile(
                                  context, allTranslations.text('Low price'),
                                  () async {
                                products = [];
                                isLoading = true;

                                setState(() {});
                                var res = await MazadProvider().sortProducts(
                                    sortBy: "price", orderBy: "asc");
                                products = [];
                                json.decode(res)["data"].forEach((item) {
                                  products.add(AuctionProduct.fromJson(item));
                                });
                                isLoading = false;

                                setState(() {});
                              }),
                              _createTile(context, 'Top Price', () async {
                                products = [];
                                isLoading = true;

                                setState(() {});
                                var res = await MazadProvider().sortProducts(
                                    sortBy: "price", orderBy: "desc");
                                products = [];
                                json.decode(res)["data"].forEach((item) {
                                  products.add(AuctionProduct.fromJson(item));
                                });
                                isLoading = false;

                                setState(() {});
                              }),
                              _createTile(context,
                                  allTranslations.text('Start Date desc'),
                                  () async {
                                products = [];
                                isLoading = true;

                                setState(() {});
                                var res = await MazadProvider().sortProducts(
                                    sortBy: "start_date", orderBy: "desc");
                                products = [];
                                json.decode(res)["data"].forEach((item) {
                                  products.add(AuctionProduct.fromJson(item));
                                });
                                isLoading = false;

                                setState(() {});
                              }),
                              _createTile(context,
                                  allTranslations.text('Start Date asc'),
                                  () async {
                                products = [];
                                isLoading = true;

                                setState(() {});
                                var res = await MazadProvider().sortProducts(
                                    sortBy: "start_data", orderBy: "asc");
                                products = [];
                                json.decode(res)["data"].forEach((item) {
                                  products.add(AuctionProduct.fromJson(item));
                                });
                                isLoading = false;

                                setState(() {});
                              }),
                              _createTile(context,
                                  allTranslations.text('End Date desc'),
                                  () async {
                                products = [];
                                isLoading = true;

                                setState(() {});
                                var res = await MazadProvider().sortProducts(
                                    sortBy: "end_date", orderBy: "desc");
                                products = [];
                                json.decode(res)["data"].forEach((item) {
                                  products.add(AuctionProduct.fromJson(item));
                                });
                                isLoading = false;

                                setState(() {});
                              }),
                              _createTile(
                                  context, allTranslations.text('End Date asc'),
                                  () async {
                                products = [];
                                isLoading = true;

                                setState(() {});
                                var res = await MazadProvider().sortProducts(
                                    sortBy: "end_data", orderBy: "asc");
                                products = [];
                                json.decode(res)["data"].forEach((item) {
                                  products.add(AuctionProduct.fromJson(item));
                                });
                                isLoading = false;

                                setState(() {});
                              }),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  ListTile _createTile(BuildContext context, String name, Function action) {
    return ListTile(
      title: Text(name),
      onTap: () {
        Navigator.pop(context);
        action();
      },
    );
  }

  Widget header(modalTitle) => Ink(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                modalTitle,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: DataProvider().primary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      );

  _bottomSheetFilter() {
    AsyncMemoizer _memorizerFilter = AsyncMemoizer();

    List<Item> items = [];
    double minPrice = 0;
    double maxPrice = 100;

    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: double.infinity,
            color: Color(0XFF737373),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Material(
                clipBehavior: Clip.antiAlias,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.only(
                        topLeft: new Radius.circular(15.0),
                        topRight: new Radius.circular(15.0))),
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 3.0, left: 3.0, bottom: 1.0),
                  child: Column(
                    children: <Widget>[
                      header("Filter"),
                      Expanded(
                        child: FutureBuilder(
                            future: _memorizerFilter.runOnce(() async {
                          await MazadProvider().filterValues().then((res) {
                            var data = json.decode(res)["data"]["checkbox"];

                            items = [];
                            data.forEach((item) {
                              items.add(Item.fromJson(item));
                            });

                            minPrice = json
                                .decode(res)["data"]["min_price"]
                                .toDouble();
                            maxPrice = json
                                .decode(res)["data"]["max_price"]
                                .toDouble();
                          });
                        }), builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Filter(
                              items: items,
                              rangeItems: [
                                RangeItem.fromMinAndMax(minPrice, maxPrice)
                              ],
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void myTimer(String value) {
    if (value.isNotEmpty) {
      isLoading = true;
      const oneSec = const Duration(seconds: 3);
      new Timer.periodic(oneSec, (Timer t) async {
        products = [];

        setState(() {});
        var res = json.decode(await MazadProvider().seachProduct(value));
        products = [];
        res["data"].forEach((item) {
          products.add(AuctionProduct.fromJson(item));
        });

        setState(() {
          print("my requst Done");
          isLoading = false;
          t.cancel();
        });
      });
    } else
      null;
  }
}
