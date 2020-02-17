import 'package:big/Screens/cart.dart';
import 'package:big/Screens/login.dart';
import 'package:big/Screens/register.dart';
import 'package:big/Widgets/dataManager.dart';
import 'package:big/componets/searchWidget.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:big/Providers/DataProvider.dart';
import 'package:big/componets/shopping_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

AppBar Mybar(String titleA, bool searchCartA,
    [bool deleteItemsA = false, bool noBack = false]) {
  String title = titleA;
  bool searchCart = searchCartA;
  bool deleteItems = deleteItemsA;
  var appBarText = <Widget>[
    new Text(
      "$title",
      style: TextStyle(color: Colors.black),
    ),
  ];
  return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: DataProvider().primary,
              ),
              onPressed: () async{
                   SharedPreferences prefs = await SharedPreferences.getInstance();
                   Navigator.of(context).pop(prefs.clear());

              } 
              );
        },
      ),
      title: Row(children: appBarText),
      actions: <Widget>[
        deleteItems ? Dropdown(titleA) : Container(),
        searchCart
            ? Consumer<DataProvider>(
                builder: (context, dataProvider, _) {
                  return SearchCart(dataProvider.cartCounter);
                },
              )
            : Container()
      ]);
}

class SearchCart extends StatefulWidget {
  final int cartItems;
  bool issearch = false;
  bool iconColor;

  SearchCart(this.cartItems, [this.issearch = true, this.iconColor = true]);

  @override
  _SearchCartState createState() => _SearchCartState();
}

class _SearchCartState extends State<SearchCart> {
  int counter;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cart = new InkWell(
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey('userToken')) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CartPage()));
        } else {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
      },
      child: Stack(
        children: <Widget>[
          Icon(
            Shopping.shopping_bag_01,
            //Icons.shopping_cart,
            color: widget.iconColor ? DataProvider().primary : Colors.blue,
            //size: 50,
          ),
          new Consumer<DataProvider>(
              builder: (context, model,_) {
         var pref=model.cartCounter;
                if (pref > 0) {
                  return  CircleAvatar(backgroundColor: Colors.red,radius: 7,
                    child: new Center(
                                child: Consumer<DataProvider>(
                              builder: (context, snapshot, _) => new Text(
                                pref.toString(),
                                style: new TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                       
                    ),
                  );
                } else {
                  return Positioned(
                      top: 10,
                      right: 10,width: 24,height: 24,
                      child: new Stack(
                        children: <Widget>[
                          new Positioned(
                              top: 1.5,
                              right: 3.5,
                              child: new Center(
                                  child: Consumer<DataProvider>(
                                builder: (context, snapshot, _) => new Text(
                                  snapshot.getCartCounter.toString(),
                                  style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w500),
                                ),
                              ))),
                        ],
                      ));
                }
              }),
        ],
      ),
    );

    return widget.issearch
        ? Center(
          child: Row(crossAxisAlignment: CrossAxisAlignment.end,children: <Widget>[
                new InkWell(
                    child: Icon(
                      Icons.search,
                      color: DataProvider().primary,
                    ),
                    onTap: () {
                      showSearch(context: context, delegate: SearchWidget());
                    }),
              SizedBox(width: 10,),
              cart
            ]),
        )
        : cart;
  }

 
}

class Dropdown extends StatefulWidget {
  String pagetitle;

  Dropdown(this.pagetitle);

  @override
  _DropdownState createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String dropdownValue = " ${allTranslations.text('deleteItems')}";

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        icon: Icon(Icons.more_vert),
        value: null,
        onChanged: (String newValue) {
          setState(() {
            dropdownValue = newValue;
          });
        },
        items: <String>['$dropdownValue']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: InkWell(
              child: Text(value),
              onTap: () {
                var db = DatabaseManager();
                db.clearAllProduct();
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
