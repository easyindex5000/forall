import 'dart:convert';

import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/Mazad/mazadProvider.dart';
import 'package:big/Screens/mazad/customItem.dart';
import 'package:big/componets/Error.dart';
import 'package:big/componets/ErrorScreen.dart';
import 'package:big/localization/all_translations.dart';
import 'package:big/model/mazad/notification.dart';
import 'package:flutter/material.dart';

import 'MazadHome.dart';

class MazadNotifications extends StatefulWidget {
  @override
  _MazadNotificationsState createState() => _MazadNotificationsState();
}

class _MazadNotificationsState extends State<MazadNotifications> {
  List<MazadNotification> notifications;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: DataProvider().primary),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          allTranslations.text("Notification"),
          style: TextStyle(color: DataProvider().primary),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
              future: MazadProvider().getNotification().then((res) {
                var result = json.decode(res)["data"];
                notifications = [];
                result.forEach((item) {
                  notifications.add(MazadNotification.fromJson(item));
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
                if (snapshot.connectionState == ConnectionState.done) {
                
  return ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 140,
                        margin: EdgeInsets.symmetric(
                            vertical:
                                MediaQuery.of(context).size.height * 2.5 / 100),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xff29000000),
                                  blurRadius: 9,
                                  offset: Offset(3, 3))
                            ]),
                        child: InkWell(
                          onTap: () {
                            MazadProvider().seen(notifications[index].id);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => CustomItem(
                                          id: notifications[index].auctionId,
                                        )));
                          },
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      _getTitle(notifications[index].type),
                                      style: TextStyle(
                                          color: DataProvider().primary,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Spacer(),
                                    if (!notifications[index].seen)
                                      Icon(
                                        Icons.fiber_manual_record,
                                        size: 10,
                                        color: Colors.red,
                                      ),
                                    Text(notifications[index].time),
                                  ],
                                ),
                              ),
                              Divider(),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: 40,
                                  ),
                                  FutureBuilder(
                                      future: precacheImage(
                                          NetworkImage(
                                              notifications[index].cover),
                                          context),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState !=
                                            ConnectionState.done) {
                                          return Container(
                                              width: 40,
                                              height: 40,
                                              color: Colors.grey);
                                        }
                                        return FadeInImage(
                                          placeholder: AssetImage(
                                              "lib/assets/images/errorImage.png"),
                                          image: NetworkImage(
                                            notifications[index].cover,
                                          ),
                                          width: 40,
                                          height: 40,
                                        );
                                      }),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(notifications[index].auctionName),
                                        Text(
                                            "${_getAmount(notifications[index])}"),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                           
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
    );
  }

  _getTitle(int type) {
    String title;
    if (type == 0) {
      title = allTranslations.text("Bid Added");
    } else if (type == 1) {
      title = allTranslations.text("Auction started");
    } else if (type == 2) {
      title = allTranslations.text("Auction Ended");
    } else if (type == 3) {
      title = allTranslations.text("Auction Aprove");
    } else if (type == 4) {
      title = allTranslations.text("you win");
    }
    return title;
  }

  _getAmount(MazadNotification notification) {
    String text;
    if (notification.type == 0) {
      text = "${allTranslations.text("With price")} ${notification.amount} USD";
    } else if (notification.type == 1) {
      text = "${allTranslations.text("Inc to")} ${notification.amount} USD";
    } else if (notification.type == 2) {
      text = "${allTranslations.text("Inc to")} ${notification.amount} USD";
    } else if (notification.type == 3) {
      text =
          "${allTranslations.text("Auction Started with to")} ${notification.amount} USD";
    } else if (notification.type == 4) {
      text = "${allTranslations.text("you win")} ${notification.amount} USD";
    }
    return text;
  }
}
