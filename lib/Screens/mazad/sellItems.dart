import 'dart:convert';

import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/Mazad/mazadProvider.dart';
import 'package:big/Screens/mazad/ActionProduct.dart';
import 'package:big/componets/Error.dart';
import 'package:big/componets/ErrorScreen.dart';
import 'package:big/localization/all_translations.dart';
import 'package:big/model/mazad/auctionProduct.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login.dart';
import 'customItem.dart';
import 'Addacution.dart';
import 'nationalIDDialog.dart';
import 'package:async/async.dart';

class SellItems extends StatefulWidget {
  @override
  _SellItemsState createState() => _SellItemsState();
}

class _SellItemsState extends State<SellItems> {
  AsyncMemoizer _memorizer = AsyncMemoizer();
  @override
  Widget build(BuildContext context) {
    final double itemHeight = MediaQuery.of(context).size.height * 0.36;
    final double itemWidth = MediaQuery.of(context).size.width * 0.40;
    List<AuctionProduct> products = [];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: DataProvider().primary),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          allTranslations.text("Your Sell"),
          style: TextStyle(color: DataProvider().secondry),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: FutureBuilder(
                future: _memorizer.runOnce(() async{
                 await MazadProvider().getUserSelles().then((res) async {
                    print(res);
                    print("^^^^^^^^^6");
                    try{
                      if (json.decode(res)["data"]['message'] ==
                          "Sorry You have to create an auction account") {
                        await nationalIdDialog(context);
                        var res = await MazadProvider().getUserSelles();
                        products = [];

                        json.decode(res)["data"].forEach((item) {
                          products.add(AuctionProduct.fromJson(item));
                        });
                      }
                    }catch(e){
                      products = [];

                      json.decode(res)["data"].forEach((item) {
                        products.add(AuctionProduct.fromJson(item));
                      });
                    }



                  });
                })
                  ..catchError((onError) {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => ErrorScreen()));
                  }),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return CustomErrorWidget();
                  }
                  if (snapshot.connectionState == ConnectionState.done &&
                      products.length != 0) {
                   
return GridView.builder(
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                MediaQuery.of(context).size.width > 600 ? 3 : 2,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            childAspectRatio: 0.8),
                        itemBuilder: (BuildContext context, int index) {
                          return ProductAuctionWidget(
                            product: products[index],
                          );
                        });
                     
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(
                      child: Image.asset(
                        "lib/assets/images/mazad/SellEmpty.png",
                        width: MediaQuery.of(context).size.width * 3 / 4,
                        height: MediaQuery.of(context).size.height * 2 / 4,
                      ),
                    );
                  }
                },
              ),
            ),
            Container(
              height: 40,
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 6.7 / 100),
              decoration: ShapeDecoration(
                  color: DataProvider().primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
              child: InkWell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      allTranslations.text("Add Auction"),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  if (!prefs.containsKey('userToken')) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddAcution()));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
