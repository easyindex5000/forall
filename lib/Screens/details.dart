import 'dart:convert';
import 'dart:core';
import 'package:big/Providers/AuthProvider.dart';
import 'package:big/Providers/ColorsProvider.dart';
import 'package:big/Providers/MainProvider.dart';
import 'package:big/Screens/login.dart';
import 'package:big/Widgets/dataManager.dart';
import 'package:big/componets/ErrorScreen.dart';
import 'package:big/Screens/register.dart';
import 'package:big/componets/Loading.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/componets/shopping_icons.dart';
import 'package:big/componets/slider.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../componets/appBar.dart';
import '../Providers/DataProvider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:provider/provider.dart';
import 'package:big/review/allReviews.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:big/model/Productsmodel.dart';
import 'package:big/Screens/companyProducts.dart';
import 'package:async/async.dart';
import 'dart:convert';

class ProductDetails extends StatefulWidget {
  final int productID;
  ProductDetails(this.productID);
  @override
  _ProductDetailsState createState() =>
      _ProductDetailsState(productid: productID);
}

class _ProductDetailsState extends State<ProductDetails> {
  Future<bool> _isFavorate(int id) async {
    return (await db.getCustomProduct(id)) != null;
  }

  final String newitem = allTranslations.text('new');
  final String addBag = allTranslations.text('add_bag');
  final String details = allTranslations.text('details');
  AsyncMemoizer _memorizer = AsyncMemoizer();

  int productid;

  _ProductDetailsState({this.productid});
  List<Data> myProduct;
  List<Images> listImages = new List();

  List mydata;
  TextDecoration offerdecoration = TextDecoration.lineThrough;
  int checkNew;

  Map<String, int> selectedCombination = Map();
  String currency = "USD";
  bool isOffer = true;
  Color favoriteColor = Colors.grey;
  Color cartColor = Colors.white;
  bool colorsDetails = false;
  IconData cartIcon = Shopping.group_4601;
  var db = new DatabaseManager();
  var key;
  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> fetchPro() async {
    final headers = {
      'Content-Type': 'application/json',
    };
    final res = await http.get(MainProvider().baseUrl + "/product/$productid",
        headers: headers);

    var data = json.decode(res.body);
    listImages.add(Images(src: data["data"][0]["cover"]));

    List<dynamic> images = data['data'][0]['images'];

    for (dynamic item in images) {
      listImages.add(Images.fromJson(item));
    }

    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      mydata = data["data"];
      myProduct = mydata.map<Data>((json) => Data.fromJson(json)).toList();

      getDataBase(myProduct[0].id);
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Mybar('$details', true),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Center(
              child: FutureBuilder(future: _memorizer.runOnce(() {
                return fetchPro().catchError((onError) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => ErrorScreen()));
                });
              }), builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState != ConnectionState.done) {
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
                    ),
                  );
                }
                return ListView(
                  children: <Widget>[
                    Stack(children: <Widget>[
                      Container(
                        height: 240,
                        margin: EdgeInsets.symmetric(vertical: 20),
                        width: double.infinity,
                        child: silder(context, listImages),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          myProduct[0].offerPercent != null
                              ? Stack(
                                  children: <Widget>[
                                    Container(
                                      width: 65,

                                      color: Colors.red,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: _Offerprecent(myProduct: myProduct),
                                      ),
                                    ),
                                  ],
                                )
                              : Spacer(flex: 2),
                          Stack(
                            children: <Widget>[
                              Container(
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(3, 3),
                                          blurRadius: 6,
                                          color: Color(0xff29000000))
                                    ]),
                                width: 40,
                                height: 40,
                                child: StatefulBuilder(
                                    builder: (context, setState) {
                                  return FutureBuilder<bool>(
                                      future: _isFavorate(widget.productID),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return SizedBox();
                                        }
                                        return new IconButton(
                                          icon: Icon(favoriteColor ==
                                                  DataProvider().primary
                                              ? Icons.favorite_border
                                              : Icons.favorite),
                                          iconSize: 20.0,
                                          color: favoriteColor,
                                          onPressed: () async {
                                            if (favoriteColor == Colors.red) {
                                              await deleteFav(myProduct[0].id);

                                              setState(() {
                                                favoriteColor =
                                                    DataProvider().primary;
                                              });
                                            } else if (favoriteColor ==
                                                DataProvider().primary) {
                                              await addToFav();

                                              setState(() {
                                                favoriteColor = Colors.red;
                                              });
                                            }
                                          },
                                        );
                                      });
                                }),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        bottom: 0,
                        width: MediaQuery.of(context).size.width - 20,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            myProduct[0].isNew
                                ? Stack(
                                    children: <Widget>[
                                      Container(
                                        width: 40,

                                        color: Colors.red,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Builder(
                                            
                                            builder: (context,) {
                                              if(newitem==null){
                                                return SizedBox();
                                              }
                                              return new Text(
                                                "$newitem",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10.0,
                                                ),
                                              );
                                            }
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Spacer(flex: 2),
                            Stack(
                              children: <Widget>[
                                Container(
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    border: new Border.all(color: Colors.grey),
                                    color: Colors.white,
                                  ),
                                  width: 40,
                                  height: 40,
                                  child: Consumer<DataProvider>(
                                      builder: (context, dataProvider, _) {
                                    return new IconButton(
                                        icon: Icon(cartIcon),
                                        iconSize: 20.0,
                                        color: DataProvider().primary,
                                        onPressed: () async {
                                          if (selectedCombination.length !=
                                              myProduct[0]
                                                  .categoryAttributes
                                                  .length) {
                                            Toast.show(
                                                allTranslations.text(
                                                    "Please Select Details"),
                                                context);
                                          } else {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            if (prefs
                                                .containsKey("userToken")) {
                                              await loadWidget(
                                                  context,
                                                  AddToCard(myProduct[0].id, 1,
                                                      dataProvider));
                                            } else {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginPage()));
                                            }
                                          }
                                        });
                                  }),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CompnayProduct(
                                  subtitle: myProduct[0].company.name,
                                  compId: myProduct[0].company.id,
                                ),
                              ),
                            );
                          },
                          child: Builder(
                           
                            builder: (context, ) {
                                  if(myProduct[0].company.name==null){
                                                return SizedBox();
                                              }
                              return Text(
                                myProduct[0].company.name,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2),
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      children: <Widget>[
                        new Expanded(
                          child: Builder(
                            builder: (context, ) {
                                if(myProduct[0].name==null){
                                                return SizedBox();
                                              }
                              return Text(
                                myProduct[0].name,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: ColorProvider().secondColor,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            if (myProduct[0].offer != null)
                              Builder(
                                builder: (context, ) {
                                   if(currency==null){
                                                return SizedBox();
                                              }
                                  return new Text(
                                    '${myProduct[0].offer + " $currency"}   ',
                                    style: TextStyle(
                                      color: DataProvider().primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  );
                                }
                              )
                          ],
                        ),
                        if (myProduct[0].offer != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                             Builder(
                           
                                builder: (context, ) {
                                        if(currency==null){
                                                return SizedBox();
                                              }
                                  return Text(
                                    myProduct[0].price + " $currency",
                                    style: TextStyle(
                                        color: ColorProvider().secondColor,
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  );
                                }
                              ),
                            ],
                          ),
                        if (myProduct[0].offer == null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Builder(
                                builder: (context, ) {
                                        if(currency==null){
                                                return SizedBox();
                                              }
                                  return Text(
                                    myProduct[0].price + "$currency",
                                    style: TextStyle(
                                        color: DataProvider().primary,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  );
                                }
                              ),
                            ],
                          ),
                      ],
                    ),
                    InkWell(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SmoothStarRating(
                                allowHalfRating: false,
                                onRatingChanged: (v) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AllReviews(myProduct[0].id)));
                                },
                                // onRatingChanged: (v) {
                                //   setState(() {
                                //     rating = v;
                                //   });
                                // },
                                starCount: 5,
                                rating: myProduct[0].rating,
                                size: 18.0,
                                color: Color(0xFFefce4a),
                                borderColor: Colors.grey,
                                spacing: 0.0),
                            Builder(
                              
                              builder: (context, ) {
                                      if(myProduct[0].rateCount==null){
                                                return SizedBox();
                                              }
                                return Text("(${myProduct[0].rateCount})",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey));
                              }
                            ),
                          ]),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    AllReviews(myProduct[0].id)));
                      },
                    ),
                    StatefulBuilder(
                        //,
                        builder: (context, setState) {
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: myProduct[0].categoryAttributes.length,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  myProduct[0].categoryAttributes[index].name,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: selectedCombination.length < index
                                      ? 0
                                      : 70,
                                  child: selectedCombination.length < index
                                      ? SizedBox()
                                      : myProduct[0]
                                                  .categoryAttributes[index]
                                                  .values ==
                                              null
                                          ? Center(
                                              child:
                                                  CircularProgressIndicator())
                                          : ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              shrinkWrap: true,
                                              itemCount: myProduct[0]
                                                  .categoryAttributes[index]
                                                  .values
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context, i) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Consumer<DataProvider>(
                                                      builder: (context,
                                                          dataProvider, _) {
                                                    return InkWell(
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  10.0),
                                                          border: Border.all(
                                                              color: selectedCombination[
                                                                          "${index}"] !=
                                                                      myProduct[0]
                                                                          .categoryAttributes[
                                                                              index]
                                                                          .values[
                                                                              i]
                                                                          .id
                                                                  ? Colors.grey
                                                                  : DataProvider()
                                                                      .primary,
                                                              width: 2.0),
                                                        ),
                                                        width: 90,
                                                        height: 50,
                                                        child: Center(
                                                            child: Text(
                                                          myProduct[0]
                                                              .categoryAttributes[
                                                                  index]
                                                              .values[i]
                                                              .value,
                                                          style: TextStyle(
                                                              color: selectedCombination[
                                                                          "${index}"] !=
                                                                      myProduct[0]
                                                                          .categoryAttributes[
                                                                              index]
                                                                          .values[
                                                                              i]
                                                                          .id
                                                                  ? Colors.grey
                                                                  : DataProvider()
                                                                      .primary),
                                                        )),
                                                      ),
                                                      onTap: () {
                                                        try {
                                                          selectedCombination[
                                                                  "${index}"] =
                                                              myProduct[0]
                                                                  .categoryAttributes[
                                                                      index]
                                                                  .values[i]
                                                                  .id;
                                                          try {
                                                            myProduct[0]
                                                                .categoryAttributes[
                                                                    index + 1]
                                                                .values = null;
                                                          } catch (e) {}

                                                          setState(() {});
                                                          dataProvider
                                                              .combinationProduct(
                                                                  myProduct[0]
                                                                      .id,
                                                                  myProduct[0]
                                                                      .categoryAttributes[
                                                                          index +
                                                                              1]
                                                                      .id,
                                                                  selectedCombination)
                                                              .then((res) {
                                                            var combinations =
                                                                json.decode(
                                                                        res)[
                                                                    "data"];
                                                            myProduct[0]
                                                                    .categoryAttributes[
                                                                        index + 1]
                                                                    .values =
                                                                combinations
                                                                    .map<Values>(
                                                                        (v) {
                                                              return Values
                                                                  .fromJson(v);
                                                            }).toList();
                                                            setState(() {});
                                                          });
                                                          for (int i =
                                                                  index + 1;
                                                              i <
                                                                  myProduct[0]
                                                                      .categoryAttributes
                                                                      .length;
                                                              i++) {
                                                            try {
                                                              selectedCombination
                                                                  .remove(
                                                                      "${i}");
                                                            } catch (e) {}
                                                          }
                                                          setState(() {});
                                                        } catch (e) {}
                                                      },
                                                    );
                                                  }),
                                                );
                                              },
                                            ),
                                ),
                              ],
                            );
                          });
                    }),
                    Row(
                      children: <Widget>[
                        Text(
                          allTranslations.text("Description"),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 17.0),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      children: <Widget>[
                        Expanded(child: Builder(
                          
                          builder: (context, ) {
                            return Text(myProduct[0].description);
                          }
                        )),
                      ],
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Future getDataBase(int id) async {
    Product mohamed = await db.getCustomProduct(id);

    if (mohamed == null) {
      favoriteColor = DataProvider().primary;
    } else {
      favoriteColor = Colors.red;
    }
  }

  Future AddToCard(int productId, int qty, dataProvider) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> body = {'data': selectedCombination};
    String jsonBody = json.encode(body);
    final headers = {'Content-Type': 'application/json'};
    Response response2 = await http.post(
        MainProvider().baseUrl +
            "/product/${productId.toString()}/get/combination",
        body: jsonBody,
        headers: headers);
    var responseBody = response2.body;

    if (prefs.containsKey('userToken')) {
      await DataProvider()
          .CartPost(productId, qty, json.decode(responseBody)["data"])
          .then((res) async {
            print(res);
        var data = json.decode(res);
        if (data['success'] == true) {
          print(data);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          //    if(cartColor==Colors.white){
          dataProvider.setCatCounter = dataProvider.cartCounter + 1;

          //  cartIcon = Shopping.shopping_bag1;
          Toast.show(allTranslations.text("success"), context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        } else {

                  var data = json.decode(res);
                      Toast.show(allTranslations.text("something went wrong"), context,
              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              
          // Toast.show(data["data"]["message"], context,
          //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        }
      });
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  Future addToFav() async {
    if (myProduct[0].isNew == true) {
      checkNew = 1;
    } else {
      checkNew = 0;
    }
    int ProductSaved = await db.saveProduct(new Product(
        myProduct[0].name,
        myProduct[0].description,
        myProduct[0].cover,
        myProduct[0].price,
        myProduct[0].offer,
        checkNew,
        myProduct[0].id));
  }

  Future deleteFav(int Isfav) async {
    int deleteCustmProduct = await db.deleteProduct(Isfav);
  }
}

class _Offerprecent extends StatelessWidget {
  const _Offerprecent({
    Key key,
    @required this.myProduct,
  }) : super(key: key);

  final List<Data> myProduct;

  @override
  Widget build(BuildContext context) {
    return new Text(
      "${myProduct[0].offerPercent} " +
          allTranslations.text("OFF"),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 9.3,
      ),
    );
  }
}

ExpansionTile buildExpansionTile(String header, String body) {
  return ExpansionTile(
    title: new Text(header),
    children: <Widget>[
      new Column(
        children: <Widget>[
          ListTile(
            title: Text(
              body,
              style: TextStyle(color: ColorProvider().secondColor),
            ),
          ),
        ],
      ),
    ],
  );
}
