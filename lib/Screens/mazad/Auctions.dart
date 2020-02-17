import 'dart:convert';

import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/Mazad/mazadProvider.dart';
import 'package:big/Screens/mazad/nationalIDDialog.dart';
import 'package:big/componets/Error.dart';
import 'package:big/componets/ErrorScreen.dart';
import 'package:big/localization/all_translations.dart';
import 'package:big/model/mazad/auctionProduct.dart';
import 'package:flutter/material.dart';

import 'ActionProduct.dart';
import 'customItem.dart';
import 'package:async/async.dart';

class Auctions extends StatefulWidget {
  Auctions();
  @override
  _AuctionsState createState() => _AuctionsState();
}

class _AuctionsState extends State<Auctions> {
  AsyncMemoizer _memorizer = AsyncMemoizer();

  _AuctionsState();
  List<AuctionProduct> products = [];
  @override
  Widget build(BuildContext context) {
    final double itemHeight = MediaQuery.of(context).size.height * 0.36;
    final double itemWidth = MediaQuery.of(context).size.width * 0.40;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: DataProvider().primary),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          allTranslations.text("Acution"),
          style: TextStyle(color: DataProvider().secondry),
        ),
      ),
      body: FutureBuilder(
        future: _memorizer.runOnce(() async{
         await MazadProvider().getUserAuctions().then((res) async {
            print(res);
           print("^^^^^^");
           try { if (json.decode(res)["data"]['message'] ==
               "Sorry You have to create an auction account") {
                                         await nationalIdDialog(context);

             var res = await MazadProvider().getUserAuctions();
             products = [];
             json.decode(res)["data"].forEach((item) {
               products.add(AuctionProduct.fromJson(item));
             });
           }
           products = [];
           json.decode(res)["data"].forEach((item) {
             products.add(AuctionProduct.fromJson(item));
           });}catch(e){
             products = [];
             json.decode(res)["data"].forEach((item) {
               products.add(AuctionProduct.fromJson(item));
             });
           }

        
            products = [];
            json.decode(res)["data"].forEach((item) {
              products.add(AuctionProduct.fromJson(item));
            });
          });
        })
          ..catchError((onError) {
            print(onError);
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => ErrorScreen()));
          }),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget();
          }
          if (snapshot.connectionState == ConnectionState.done &&
              products.length != 0) {
            return GridView.builder(
                itemCount: products.length,
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
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
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: <Widget>[
                Spacer(),
                Center(
                  child: Image.asset(
                    "lib/assets/images/mazad/AuctionEmpty.png",
                    width: MediaQuery.of(context).size.width * 3 / 4,
                    height: MediaQuery.of(context).size.height * 2 / 4,
                  ),
                ),
                Spacer(),
                Container(
                  height: 40,
                  margin: EdgeInsets.symmetric(
                      horizontal:
                          MediaQuery.of(context).size.width * 6.7 / 100),
                  decoration: ShapeDecoration(
                      color: DataProvider().primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4))),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          allTranslations.text("Go Home"),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  height: 24,
                )
              ],
            );
          }
        },
      ),
    );
  }
}
