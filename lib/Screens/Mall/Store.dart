import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/mall/MallPovider.dart';
import 'package:big/componets/Error.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/localization/all_translations.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

class StoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: null,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return CustomErrorWidget();
          }

          return Material(
              child: Scaffold(
                  appBar: Mybar("store name", false),
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                width: 110.0,
                                height: 110.0,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 3),
                                          color: Color(0xff29000000),
                                          blurRadius: 6)
                                    ]),
                                margin: const EdgeInsets.only(right: 10.0),
                                padding: const EdgeInsets.all(3.0),
                                child: 

                                ClipOval(
                                    child: Stack(alignment: Alignment.center,
                                      children: <Widget>[
                                        FadeInImage(
                                          placeholder: AssetImage(
                                              "lib/assets/images/errorImage.png"),
                                          image: NetworkImage('body["cover"]'),
                                          fit: BoxFit.fitWidth,
                                        ),
                                        Container(color: Color(0xffa6000000).withOpacity(0.5),width:double.infinity,height: double.infinity,),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Image.asset( "lib/assets/images/lock.png"),
                                        )
                                      ],
                                    ),
                                  ),
                              ),
                             Builder(
                                builder: (context, ) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 17.0),
                                        child: Text("body['name']",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.location_on,
                                            color: DataProvider().primary,
                                          ),
                                          Text("body['city']"),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Icon(Icons.phone,
                                              color: DataProvider().primary),
                                          Text("body[mobile_number]"),
                                        ],
                                      ),
                                    ],
                                  );
                                }
                              ),
                            ],
                          ),  Divider(
                            height: 48,
                            color: Colors.grey,
                          ),

// Carousel(),

                          Divider(
                            height: 48,
                            color: Colors.grey,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${allTranslations.text('workingTime')}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                             Builder(
                                builder: (context, ) {
                                  return Text('From Sat to Wed');
                                }
                              ),
                            Builder(
                                builder: (context, ) {
                                  return Text('from 5 to 5 ');
                                }
                              ),
                            ],
                          ),
                          Divider(
                            height: 48,
                            color: Colors.grey,
                          ),
                         Builder(
                            builder: (context, ) {
                              return Column(
                                children: <Widget>[
                                  Text(allTranslations.text("Description"),
                                      style: TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.bold)),
                                              SizedBox(
                                height: 8,
                              ),
                              Text(" bla bla bla b lba"),
                                ],
                              );
                            }
                          ),
                      
                          Divider(
                            height: 48,
                            color: Colors.grey,
                          ),
                            FadeInImage(
                placeholder: AssetImage("lib/assets/images/errorImage.png"),
                image: NetworkImage("ss"),
              ),
                          Center(
                              child: RaisedButton(
                                  child: Text(
                                    allTranslations.text('Shopping'),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: DataProvider().primary,
                                  onPressed: () {})),
                        ],
                      ),
                    ),
                  )));
        });
  }
}
