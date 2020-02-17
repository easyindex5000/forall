import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/wuzzef/wuzzef_provider.dart';
import 'package:big/Screens/wuzzef/jobDetails.dart';
import 'package:big/Widgets/dataManager.dart';
import 'package:big/componets/searchWidget.dart';
import 'package:big/localization/all_translations.dart';
import 'package:big/Screens/wuzzef/applications.dart';
import 'package:big/model/wuzzef/job.dart';
import 'package:flutter/material.dart';
class WuzzefHome extends StatefulWidget {
  @override
  _WuzzefHomeState createState() => _WuzzefHomeState();
}

class _WuzzefHomeState extends State<WuzzefHome> {
  Color iconColor = Colors.grey;
  DatabaseManager db = DatabaseManager();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text(
              allTranslations.text("home"),
              style: TextStyle(color: Colors.black),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Material(
                      elevation: 5.0,
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      child: InkWell(
                        onTap: () {
                          showSearch(
                              context: context, delegate: SearchWidget());
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.search,
                                  color: DataProvider().primary,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  "search",
                                  style:
                                      TextStyle(color: DataProvider().primary),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "UI/UX Designer",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                " [Full Time]",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        DataProvider().primary),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: <Widget>[
                                              Container(
                                                  height: 50,
                                                  width: 50,
                                                  child: Builder(builder: (
                                                    context,
                                                  ) {
                                                    bool hasError = false;
                                                    return FutureBuilder(
                                                        future: precacheImage(
                                                            NetworkImage(
                                                                "https://thenextscoop.com/wp-content/uploads/2017/02/apple-logo.jpg"),
                                                            context,
                                                            onError: (_, __) {
                                                          hasError = true;
                                                        }),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (hasError) {
                                                            Image.asset(
                                                                "lib/assets/images/errorImage.png");
                                                          }
                                                          if (snapshot
                                                                  .connectionState !=
                                                              ConnectionState
                                                                  .done) {
                                                            return Container(
                                                              color:
                                                                  Colors.grey,
                                                            );
                                                          }
                                                          return Image.network(
                                                            "https://thenextscoop.com/wp-content/uploads/2017/02/apple-logo.jpg",
                                                            loadingBuilder: (_,
                                                                child,
                                                                progress) {
                                                              return progress ==
                                                                      null
                                                                  ? child
                                                                  : Container(
                                                                      color: Colors
                                                                          .grey,
                                                                    );
                                                            },
                                                          );
                                                        });
                                                  })),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.location_on,
                                          size: 15,
                                          color: DataProvider().primary,
                                        ),
                                        Text("Alexandria,Egypt")
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                            child: Text("Alexandria,Egypt")),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(
                                              Icons.share,color: Colors.grey,),
                                          onPressed: () {
                                          },
                                        ),
                                        StatefulBuilder(
                                            builder: (context, snapshot) {
                                          return FutureBuilder(
                                              future: db.getItem(
                                                  db.wuzzefTable, index),
                                              builder: (context, snapshot) {
                                                if (!snapshot.hasData) {
                                                  return SizedBox();
                                                }
                                                return IconButton(
                                                  icon: Icon(
                                                    Icons.favorite,
                                                    color:
                                                        snapshot.data.length > 0
                                                            ? Colors.red
                                                            : Colors.grey,
                                                  ),
                                                  onPressed: () async {
                                                    if (snapshot.data.length >
                                                        0) {
                                                      print(index);
                                                      print("^^^^^^^^^^");
                                                      await WuzzefProvider()
                                                          .deleteItem(index);
                                                    } else {
                                                      await WuzzefProvider()
                                                          .saveItem(Job(
                                                              id: index,
                                                              title:
                                                                  "index $index",
                                                              city: "Ss",
                                                              country: "Ss",
                                                              description:
                                                                  "blaaaaa",
                                                              imageUrl:
                                                                  "https://thenextscoop.com/wp-content/uploads/2017/02/apple-logo.jpg",
                                                              jobType: "s"));
                                                    }
                                                    setState(() {});
                                                  },
                                                );
                                              });
                                        }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => JobDetails()));
                            },
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned.directional(
            bottom: 8,
            end: 8,
            textDirection: Localizations.localeOf(context).languageCode == "ar"
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: SafeArea(
                child: FloatingActionButton(
//              radius: 25,
              backgroundColor: DataProvider().primary,
              child: Icon(
                Icons.calendar_today,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => Applications()));
              },
            )))
      ],
    );
  }
}
