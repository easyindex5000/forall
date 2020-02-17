import 'package:big/Screens/mazad/MazadHome.dart';
import 'package:big/Screens/mazad/customItem.dart';
import 'package:big/componets/shopping_icons.dart';
import 'package:big/localization/all_translations.dart';
import 'package:big/model/mazad/auctionProduct.dart';
import 'package:flutter/material.dart';
import 'package:big/Providers/DataProvider.dart';

class ProductAuctionWidget extends StatelessWidget {
  final AuctionProduct product;

  const ProductAuctionWidget({Key key, @required this.product})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => CustomItem(
                        id: product.id,
                      )));
        },
        child: Container(
          height: 200,width: 150,
          margin: EdgeInsets.all(5),
          decoration: ShapeDecoration(
              color: Colors.white,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              shadows: [
                BoxShadow(
                    color: Color(0xff29000000),
                    blurRadius: 6,
                    offset: Offset(3, 3))
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Builder(builder: (
                  context,
                ) {
                  bool hasError = false;
                  return FutureBuilder(
                      future: precacheImage(
                          NetworkImage(
                            product.cover,
                          ),
                          context, onError: (_, __) {
                        hasError = true;
                      }),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.only(
                                    topStart: Radius.circular(5),
                                    topEnd: Radius.circular(5)),
                                color: Colors.grey),
                          );
                        }
                        if (!hasError &&
                            snapshot.connectionState == ConnectionState.done) {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadiusDirectional.only(
                                    topStart: Radius.circular(5),
                                    topEnd: Radius.circular(5)),
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: NetworkImage(
                                      product.cover,
                                    ))),
                          );
                        } else {
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    topRight: Radius.circular(5)),
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: AssetImage(
                                      "lib/assets/images/errorImage.png",
                                    ))),
                          );
                        }
                      });
                }),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 8),
                child: Text(
                  product.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 8),
                child: Row(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Icon(
                          Shopping.auction,
                          size: 10,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          product.numberOfBidders.toString(),
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    ),
                    Spacer(),
                    Flexible(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(Shopping.hourglass, size: 10),
                          SizedBox(
                            width: 2,
                          ),
                          Flexible(
                            child: Text(
                              product.remaining_time,
                              textAlign: TextAlign.end,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              if (!product.owner)
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal:8),
                  child: Row(
                    children: <Widget>[
                      Icon(Shopping.placeholder, size: 10),
                      SizedBox(
                        width: 2,
                      ),
                      Expanded(
                        child: Text(
                          product.location,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                    ],
                  ),
                ),
              if (!product.owner)
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 8),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            product.started
                                ? allTranslations.text("Bid now")
                                : product.subscribe
                                    ? allTranslations.text("Unsubscribe")
                                    : allTranslations.text("Subscribe"),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            )),
                        SizedBox(width: 5),
                        if (product.started)
                          Expanded(
                              child: Text(
                                  "${product.currentPrice + product.minIncrement} LE",
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  )))
                      ],
                    ),
                    decoration: ShapeDecoration(
                        color: DataProvider().primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4))),
                  ),
                ),
              if (product.owner)
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 5.6 / 100,
                      vertical: 5),
                  child: Container(
                    width: double.infinity,
                    //  margin: EdgeInsets.symmetric(vertical: 5),
                    //padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  //  height: 24,
                  padding: EdgeInsets.symmetric(vertical: 3.5),
                    child: Text(allTranslations.text("Bids"),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: DataProvider().primary,
                          fontSize: 13,
                        )),
                    decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color:DataProvider().primary ),
                            borderRadius: BorderRadius.circular(
                              4,
                            ))),
                  ),
                )
            ],
          ),
        ),
      
    );
  }
}
