import 'dart:convert';
import 'package:big/Providers/DataProvider.dart';
import 'package:big/Screens/UnderConstraction.dart';
import 'package:big/Screens/shipping.dart';
import 'package:big/Widgets/dataManager.dart';
import 'package:big/componets/Error.dart';
import 'package:big/componets/ErrorScreen.dart';
import 'package:big/componets/Loading.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/componets/shopping_icons.dart';
import 'package:big/localization/all_translations.dart';
import 'package:big/model/Productsmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'OnlineStoreHomeScreen.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int counter = 1;
  int itemPrice;
  int totalPrice = 0;
  Color iconColor = Colors.grey;
  bool isBagFull = true;
  String dropdownValue = '${allTranslations.text('deleteItems')}';
  String appBarText = '${allTranslations.text('yourBag')}';
  String totalAmount = '${allTranslations.text('totalAmount')}';
  String checkout = '${allTranslations.text('checkout')}';
  String emptyCart = '${allTranslations.text('emptyCart')}';
  List ProductDb;
  int productCounter;
  var db = DatabaseManager();
  var key;
  var data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Mybar("$appBarText", false, false),
      body: FutureBuilder(
        future:  DataProvider().CartDetails().then((res) {
          try {
            data = json.decode(res);
          } catch (e) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => ErrorScreen()));
          }

          if (data["success"] == false) {
            throw Exception();
          }

          return true;
        })
          ..catchError((onError) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => ErrorScreen()));
          }),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget();
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (data['data']['cartItems'].length == 0) {
            return Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 5),
                      Column(
                        children: <Widget>[
                          Image.asset("lib/assets/images/mazad/Cart-Empty.png"),
                          Text(
                            "$emptyCart",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF707070)),
                          ),
                        ],
                      ),
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width / 1.3,
                        height: 45,
                        child: RaisedButton(
                          child: Text(
                            allTranslations.text("Go To Shopping"),
                            style: TextStyle(color: Colors.white),
                          ),
                          color: DataProvider().primary,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OnlineShoppingHome()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: data['data']['cartItems'].keys.length,
                    itemBuilder: (context, index) {
                      String key =
                          data['data']['cartItems'].keys.elementAt(index);
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              child: new FittedBox(
                                child: Material(
                                  color: Colors.white,
                                  elevation: 10.0,
                                  borderRadius: BorderRadius.circular(10.0),
                                  shadowColor: Colors.grey,
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.05,
                                        height: 170,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                children: <Widget>[
                                                  Container(
                                                      width: 100,
                                                      height: 80,
                                                      child: FadeInImage(
                                                        placeholder: AssetImage(
                                                            "lib/assets/images/errorImage.png"),
                                                        image: NetworkImage(data[
                                                                    'data']
                                                                ['cartItems']
                                                            ['$key']['cover']),
                                                      )),
                                                  Expanded(
                                                                                                      child: Container(
                                                      child: Column(
                                                        children: <Widget>[
                                                          Text(
                                                            data['data']
                                                                    ['cartItems']
                                                                ['$key']['name'],
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.black),
                                                          ),
                                                          Text(
                                                              data['data'][
                                                                          'cartItems']
                                                                      ['$key'][
                                                                  'category_name'],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey)),
                                                          Text(
                                                              "${data['data']['cartItems']['$key']['price']} USD",
                                                              style: TextStyle(
                                                                  color: DataProvider()
                                                                      .primary)),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Divider(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  StatefulBuilder(builder:
                                                      (context, setState) {
                                                    return FutureBuilder<bool>(
                                                        future: getDataBase(
                                                            data['data'][
                                                                    'cartItems']
                                                                ['$key']['id']),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (!snapshot
                                                              .hasData) {
                                                            return SizedBox();
                                                          }
                                                          return IconButton(
                                                            icon: Icon(
                                                              Icons.favorite,
                                                              color: snapshot
                                                                      .data
                                                                  ? DataProvider()
                                                                      .primary
                                                                  : Colors.grey,
                                                              size: 30.0,
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                if (snapshot
                                                                    .data) {
                                                                  deleteFav(data[
                                                                              'data']
                                                                          [
                                                                          'cartItems']
                                                                      [
                                                                      '$key']['id']);
                                                                } else {
                                                                  addFav(
                                                                    data['data']['cartItems']
                                                                            [
                                                                            '$key']
                                                                        [
                                                                        'name'],
                                                                    data['data']['cartItems']
                                                                            [
                                                                            '$key']
                                                                        [
                                                                        'description'],
                                                                    data['data']['cartItems']
                                                                            [
                                                                            '$key']
                                                                        [
                                                                        'cover'],
                                                                    data['data']['cartItems']['$key']
                                                                            [
                                                                            'price']
                                                                        .toString(),
                                                                    data['data']['cartItems']['$key']
                                                                            [
                                                                            'price']
                                                                        .toString(),
                                                                    1,
                                                                    data['data']
                                                                            [
                                                                            'cartItems']
                                                                        [
                                                                        '$key']['id'],
                                                                  );
                                                                }
                                                              });
                                                            },
                                                          );
                                                        });
                                                  }),
                                                  Container(
                                                    child: Row(
                                                      children: <Widget>[
                                                        Consumer<DataProvider>(
                                                            builder: (context,
                                                                dataProvider,
                                                                _) {
                                                          return IconButton(
                                                            icon: Icon(
                                                              Icons.add_circle,
                                                              color:
                                                                  DataProvider()
                                                                      .primary,
                                                              size: 30.0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                            
                                                              var res = await loadWidget(
                                                                  context,
                                                                  DataProvider()
                                                                      .CartEdite(
                                                                          key,
                                                                          data['data']['cartItems']['$key']['qty'] +
                                                                              1));
                                                              var data2 = json
                                                                  .decode(res);
                                                              if (data2[
                                                                      "success"] ==
                                                                  true) {
                                                                dataProvider
                                                                        .setCatCounter =
                                                                    dataProvider
                                                                            .cartCounter +
                                                                        1;
                                                             
                                                              }
                                                              setState(() {});
                                                            },
                                                          );
                                                        }),
                                                        Text(
                                                            "${data['data']['cartItems']['$key']['qty']}"),
                                                        Consumer<DataProvider>(
                                                            builder: (context,
                                                                dataProvider,
                                                                _) {
                                                          return IconButton(
                                                            icon: Icon(
                                                              Icons
                                                                  .remove_circle,
                                                              color:
                                                                  DataProvider()
                                                                      .primary,
                                                              size: 30.0,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              if (data['data'][
                                                                              'cartItems']
                                                                          [
                                                                          '$key']
                                                                      ['qty'] >
                                                                  0) {
                                                                SharedPreferences
                                                                    prefs =
                                                                    await SharedPreferences
                                                                        .getInstance();
                                                                var res = await loadWidget(
                                                                    context,
                                                                    DataProvider().CartEdite(
                                                                        key,
                                                                        data['data']['cartItems']['$key']['qty'] -
                                                                            1));

                                                                var data2 =
                                                                    json.decode(
                                                                        res);
                                                                if (data2[
                                                                        "success"] ==
                                                                    true) {
                                                                  dataProvider
                                                                          .setCatCounter =
                                                                      dataProvider
                                                                              .cartCounter -
                                                                          1;
                                                                
                                                                } else {
                                                                  DataProvider()
                                                                      .CartDelete(
                                                                          key);
                                                                }
                                                                setState(() {});

                                                                // if (data['data']['cartItems'] ['$key'] ['qty'] <1) {
                                                                //   DataProvider().CartDelete(key);
                                                                // }
                                                                setState(() {});
                                                              }
                                                            },
                                                          );
                                                        }),
                                                      ],
                                                    ),
                                                  ),
                                                  Consumer<DataProvider>(
                                                      builder: (context,
                                                          dataProvider, _) {
                                                    return IconButton(
                                                      icon: Icon(
                                                        Shopping.shopping_bag,
                                                        color: DataProvider()
                                                            .primary,
                                                        size: 30.0,
                                                      ),
                                                      onPressed: () async {
                                                        dataProvider
                                                            .setCatCounter = dataProvider
                                                                .cartCounter -
                                                            data['data'][
                                                                    'cartItems']
                                                                ['$key']['qty'];

                                                        await loadWidget(
                                                            context,
                                                            DataProvider()
                                                                .CartDelete(
                                                                    key));
                                                        setState(() {});
                                                      },
                                                    );
                                                  })
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "$totalAmount ",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Text(
                          "${data['data']['subtotal']} USD",
                          style: TextStyle(
                              fontSize: 18.0, color: DataProvider().primary),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width / 1.3,
                        height: 45,
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        UnderConstraction(title: "cart",)));
                          },
                          child: Text(
                            "$checkout",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0),
                          ),
                          color: DataProvider().primary,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          } else {
            return Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 5),
                      Column(
                        children: <Widget>[
                          Image.asset("lib/assets/images/mazad/Cart-Empty.png"),
                          Text(
                            "$emptyCart",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF707070)),
                          ),
                        ],
                      ),
                      ButtonTheme(
                        minWidth: MediaQuery.of(context).size.width / 1.3,
                        height: 45,
                        child: RaisedButton(
                          child: Text(
                            allTranslations.text("Go To Shopping"),
                            style: TextStyle(color: Colors.white),
                          ),
                          color: DataProvider().primary,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OnlineShoppingHome()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
      //   ],
      // ),
    );
  }

  Future<bool> increment() {}
  Future addFav(String name, String dec, String Image, String price,
      String offer, int isNew, int id) async {
    int ProductSaved = await db
        .saveProduct(new Product(name, dec, Image, price, offer, isNew, id));
  }

  Future deleteFav(int Isfav) async {
    int deleteCustmProduct = await db.deleteProduct(Isfav);
  }

  Future<bool> getDataBase(int id) async {
    Product mohamed = await db.getCustomProduct(id);

    if (mohamed == null) {
      return false;
    } else {
      return true;
    }
  }
}
