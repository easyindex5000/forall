import 'dart:convert';

import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/Mazad/mazadProvider.dart';
import 'package:big/Screens/login.dart';
import 'package:big/Screens/mazad/Addacution.dart';
import 'package:big/Screens/mazad/nationalIDDialog.dart';
import 'package:big/Screens/shipping.dart';
import 'package:big/Widgets/custom_alert_dialog.dart';
import 'package:big/componets/Error.dart';
import 'package:big/componets/ErrorScreen.dart';
import 'package:big/componets/Loading.dart';
import 'package:big/componets/slider.dart';
import 'package:big/localization/all_translations.dart';
import 'package:big/model/Productsmodel.dart';
import 'package:big/model/mazad/auctionProduct.dart';
import 'package:big/review/allReviews.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'Notifications.dart';
import 'package:big/componets/shopping_icons.dart';

class CustomItem extends StatefulWidget {
  final int id;
  CustomItem({@required this.id});
  @override
  _CustomItemState createState() => _CustomItemState();
}

class _CustomItemState extends State<CustomItem> {
  TextEditingController contentController = TextEditingController();

  AuctionProduct product;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: MazadProvider().productDetails(widget.id).then((res) {
        product = AuctionProduct.fromJson(json.decode(res)["data"]);
      })
        ..catchError((onError) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => ErrorScreen()));
        }),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(body: CustomErrorWidget());
        }
        if (product != null) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                iconTheme: IconThemeData(color: DataProvider().primary),
                backgroundColor: Colors.white,
                elevation: 0,
                title: Text(
                  product.name,
                  style: TextStyle(color: DataProvider().secondry),
                ),
                actions: <Widget>[
                  if (product.owner && product.bids.length == 0)
                    IconButton(
                      color: DataProvider().primary,
                      icon: Icon(
                        Shopping.edit,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => AddAcution(
                                      product: product,
                                    )));
                      },
                    )
                ],
              ),
              bottomNavigationBar: buildBottomAppBar(context),
              body: ListView(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: double.infinity,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height / 3,
                              child: Carousel(
                                boxFit: BoxFit.contain,
                                autoplay: false,
                                animationCurve: Curves.fastOutSlowIn,
                                animationDuration: Duration(milliseconds: 1000),
                                dotSize: 4.0,
                                dotIncreasedColor: DataProvider().primary,
                                dotBgColor: Colors.transparent,
                                dotPosition: DotPosition.bottomCenter,
                                dotVerticalPadding: 10.0,
                                showIndicator: true,
                                indicatorBgPadding: 7.0,
                                images: List.generate(product.images.length,
                                    (index) {
                                  return NetworkImage(
                                      product.images[index].src);
                                })
                                  ..insert(
                                      0,
                                      NetworkImage(
                                        product.cover,
                                      )),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                          color: Color(0xff29000000),
                          blurRadius: 6,
                          offset: Offset(0, 3))
                    ]),
                    child: header(context),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 6.7 / 100,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Shopping.auction,
                              size: 16,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(allTranslations.text("Number of Biddings : ")),
                            SizedBox(
                              width: 5,
                            ),
                            Builder(builder: (
                              context,
                            ) {
                              if (product.bids == null) {
                                return SizedBox();
                              }
                              return Text(
                                product.bids.length.toString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              );
                            })
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(
                                  Shopping.hourglass,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(allTranslations.text("Remaining Time : ")),
                                SizedBox(
                                  width: 5,
                                ),
                                Builder(builder: (
                                  context,
                                ) {
                                  if (product.remaining_time == null) {
                                    return SizedBox();
                                  }
                                  return Text(
                                    product.remaining_time,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  );
                                })
                              ],
                            ),
                            Spacer(),
                            if (product.owner)
                              InkWell(
                                child: Icon(
                                  Icons.add,
                                  color: Color(0xff707070),
                                ),
                                onTap: () async {
                                  var res = await MazadProvider()
                                      .renewProduct(widget.id.toString());
                                  var result = json.decode(res);
                                  if (result["success"] == true) {
                                    Toast.show(allTranslations.text("renewed"),
                                        context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.BOTTOM);
                                  } else if (result["success"] == "false") {
                                    Toast.show(
                                        result["data"]["message"], context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.BOTTOM);
                                  } else {
                                    Toast.show(
                                        allTranslations
                                            .text("SomeThing went wrong"),
                                        context,
                                        duration: Toast.LENGTH_SHORT,
                                        gravity: Toast.BOTTOM);
                                  }
                                  setState(() {});
                                },
                              )
                          ],
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Shopping.placeholder,
                              size: 16,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("${allTranslations.text("Location")} : "),
                            SizedBox(
                              width: 5,
                            ),
                            Builder(builder: (
                              context,
                            ) {
                              if (product.location == null) {
                                return SizedBox();
                              }
                              return Text(
                                product.location,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              );
                            })
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          allTranslations.text("Description"),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Builder(builder: (
                          context,
                        ) {
                          if (product.description == null) {
                            return SizedBox();
                          }
                          return Text(
                            product.description,
                            style: TextStyle(fontSize: 14),
                          );
                        })
                      ],
                    ),
                  ),
                  if (product.owner)
                    ExpansionTile(
                        title: Text(allTranslations.text("Biddings")),
                        children: List.generate(product.bids.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Builder(builder: (
                                  context,
                                ) {
                                  bool hasError = false;
                                  return FutureBuilder(
                                      future: precacheImage(
                                          NetworkImage(
                                              product.bids[index].avatar),
                                          context, onError: (_, __) {
                                        hasError = true;
                                      }),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState !=
                                            ConnectionState.done) {
                                          return Container(
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundColor: Colors.grey,
                                            ),
                                          );
                                        }
                                        if (!hasError &&
                                            snapshot.connectionState ==
                                                ConnectionState.done) {
                                          return Container(
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundImage: NetworkImage(
                                                  product.bids[index].avatar),
                                            ),
                                          );
                                        } else {
                                          return Container(
                                            child: CircleAvatar(
                                              radius: 25.0,
                                              backgroundImage: AssetImage(
                                                  "lib/assets/images/errorImage.png"),
                                            ),
                                          );
                                        }
                                      });
                                }),
                              ),
                              if (product.bids[index].name == null)
                                Text(product.bids[index].name),
                              Spacer(),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.arrow_upward,
                                      color: DataProvider().primary,
                                    ),
                                    if (product.bids[index].amount == null)
                                      Text(
                                        product.bids[index].amount.toString(),
                                        style: TextStyle(
                                            color: DataProvider().primary,
                                            fontWeight: FontWeight.bold),
                                      ),
                                  ],
                                ),
                              ),
                            ]),
                          );
                        }).toList())
                ],
              ));
        } else {
          return Material(child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget header(BuildContext context) {
    if (product.winner) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: 70,
        decoration: BoxDecoration(color: Color(0xff008000)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              allTranslations.text("Congratulation You Win Auction "),
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            Text(
              "${product.currentPrice} USD",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }
    return Row(
      children: <Widget>[
        new Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 70,
          color: DataProvider().primary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                allTranslations.text("Current Price"),
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "${product.currentPrice} USD",
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
        new Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 70,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                allTranslations.text("Minimum increment"),
                style: TextStyle(color: DataProvider().primary),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                " ${product.minIncrement} USD",
                style: TextStyle(color: DataProvider().primary),
              )
            ],
          ),
        ),
      ],
    );
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    print(product.toJson());

    if (product.winner) {
      return BottomAppBar(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonTheme(
                minWidth: 250,
                child: RaisedButton(
                  child: Text(
                    allTranslations.text("Start Shipping"),
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Shipping();
                    }));
                  },
                  color: DataProvider().primary,
                ),
              )
            ],
          ),
        ),
      );
    }
    if (product.owner) {
      return BottomAppBar(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ButtonTheme(
                minWidth: 250,
                child: RaisedButton(
                  child: Text(
                    allTranslations.text("Delete"),
                    style: TextStyle(color: DataProvider().primary),
                  ),
                  onPressed: () async {
                    var res = await deleteProductDialog();
                    var result = json.decode(res);

                    if (result["success"] == true) {
                      Toast.show(allTranslations.text("Deleted"), context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                      Navigator.pop(context);
                    } else if (result["success"] == 'false') {
                      Toast.show(result["data"]["message"], context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                    } else {
                      Toast.show(allTranslations.text("Failed"), context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
                    }
                  },
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      );
    }
    return BottomAppBar(
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ButtonTheme(
              minWidth: 250,
              child: RaisedButton(
                child: Text(
                  product.started
                      ? allTranslations.text("BID NOW")
                      : product.subscribe
                          ? allTranslations.text("Unsubscribe")
                          : allTranslations.text("Subscribe"),
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  if (!prefs.containsKey('userToken')) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  } else if (product.started) {
                    await addBidDialog(context);
                    setState(() {});
                  } else if (product.subscribe) {
                    var res = await loadWidget(context,
                        MazadProvider().unsubscribeAuctions(product.id));
                    if (res["success"] == "false" &&
                        res["data"]["message"] ==
                            "Sorry You have to create an auction account") {
                      await nationalIdDialog(context);
                      await MazadProvider().unsubscribeAuctions(product.id);
                    }
                    setState(() {});
                  } else {
                    var res = await loadWidget(
                        context, MazadProvider().subscribeAuctions(product.id));
                    if (res["success"] == "false" &&
                        res["data"]["message"] ==
                            "Sorry You have to create an auction account") {
                      await nationalIdDialog(context);
                      await MazadProvider().subscribeAuctions(product.id);
                    }
                    setState(() {});
                  }
                },
                color: DataProvider().primary,
              ),
            )
          ],
        ),
      ),
    );
  }

  addBidDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.only(top: 16.0),
            content: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width * 3 / 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Center(
                      child: Text(
                        allTranslations.text("add your Bidding"),
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: DataProvider().primary),
                      ),
                    ),
                    SizedBox(height: 24.0),
                    Container(
                      padding: EdgeInsets.only(left: 30.0, right: 30.0),
                      margin: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width * 13.5 / 100),
                      decoration: BoxDecoration(
                          border: Border.all(color: DataProvider().primary)),
                      child: Form(
                        child: TextFormField(
                          validator: (value) {
                            return RegExp("[0-9]*").hasMatch(value)
                                ? null
                                : allTranslations.text("put valid input");
                          },
                          controller: contentController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText:
                                "Example: ${product.minIncrement + product.currentPrice}",
                            border: InputBorder.none,
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              MediaQuery.of(context).size.width * 13.5 / 100,
                          vertical: 10),
                      child: Text(
                        "${allTranslations.text('minimum Increment is')}  ${product.minIncrement} USD",
                        style: TextStyle(
                            color: DataProvider().primary, fontSize: 14.0),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                              decoration: BoxDecoration(
                                color: DataProvider().primary,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0)),
                              ),
                              child: Text(
                                allTranslations.text("Bid Now"),
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () {
                              check(contentController.text, context);
                            },
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0)),
                              ),
                              child: Text(
                                allTranslations.text("Close"),
                                style: TextStyle(color: DataProvider().primary),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  deleteProductDialog() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: SingleChildScrollView(
              child: Container(
                width: 300.0,
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Spacer(),
                    Center(
                      child: Text(
                        allTranslations.text("Are You Want To Delete"),
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: DataProvider().primary),
                      ),
                    ),
                    Spacer(flex: 2),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                              decoration: BoxDecoration(
                                color: Color(0xffff0000),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0)),
                              ),
                              child: Text(
                                allTranslations.text("Delete"),
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () async {
                              Navigator.pop(
                                  context,
                                  await loadWidget(
                                      context,
                                      MazadProvider().deleteProduct(
                                          product.id.toString())));
                            },
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            child: Container(
                              padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0)),
                              ),
                              child: Text(
                                allTranslations.text("Close"),
                                style: TextStyle(color: DataProvider().primary),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future check(String bid, context) async {
    if (int.parse(bid) >= product.currentPrice + product.minIncrement) {
      var res =
          await loadWidget(context, MazadProvider().createBid(widget.id, bid));
      if (res["success"] == true) {
        Toast.show(allTranslations.text("your bid is success "), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else if (res["success"] == "false" &&
          res["data"]["message"] ==
              "Sorry You have to create an auction account") {
        Toast.show(res["data"]["message"], context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        Navigator.pop(context);
        await nationalIdDialog(context);
        check(bid, context);
      }
      Navigator.pop(context);
    } else {
      Toast.show(
          allTranslations.text("bid") +
              " ${product.currentPrice + product.minIncrement}  " +
              allTranslations.text("or more"),
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM);
    }
  }
}
