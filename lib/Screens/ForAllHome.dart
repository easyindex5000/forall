import 'package:big/Providers/DataProvider.dart';
import 'package:big/Screens/OnlineStoreHomeScreen.dart';
import 'package:big/componets/ConnectivityChecker.dart';
import 'package:big/componets/ErrorScreen.dart';
import 'package:big/componets/MainDrawer.dart';
import 'package:big/componets/notification.dart';
import 'package:big/componets/searchWidget.dart';
import 'package:big/localization/all_translations.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

class ForAllHome extends StatefulWidget {
  @override
  _ForAllHomeState createState() => _ForAllHomeState();
}

class _ForAllHomeState extends State<ForAllHome> {
  getAllData() async {
    return true;
  }

  @override
  void initState() {
    // NotificationHandler().init(context);
    // ConnectivityChecker().init(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: new Text(
          allTranslations.text('For All'),
          style: TextStyle(color: Colors.black),
        ),
      ),
      drawer: mainDrawer(context, "forall"),
      body: FutureBuilder(
          future: getAllData()
            ..catchError((onError) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => ErrorScreen()));
            }),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  HomeScreenTop(allTranslations.text("search_text")),
                  Offers(allTranslations.text("shop_now")),
                  HomeOffers(allTranslations.text("Recommended FOR YOU"),
                      "popular", MyBanner()),
                ],
              ),
            );
          }),
    ));
  }

  Future<void> ShowAlertDailog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(15.0)),
          title: Text(allTranslations.text('Are you Sure ?')),
          actions: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text(
                      allTranslations.text('Logout'),
                      style: TextStyle(color: Colors.white),
                    ),
                    color: DataProvider().primary,
                    onPressed: () async {},
                  ),
                ),
                RaisedButton(
                  child: Text(
                    allTranslations.text('Cancel'),
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.red,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class HomeScreenTop extends StatefulWidget {
  String searchText;
  HomeScreenTop(this.searchText);
  HomeScreenTopState createState() => HomeScreenTopState();
}

class HomeScreenTopState extends State<HomeScreenTop> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0)),
          child: Container(
            height: 160,
            decoration: BoxDecoration(
//                        gradient: LinearGradient(
//                            colors: [
//                      Styles.appFirstColor,
//                      Styles.appSecondColor
//
//                            ]
//                        ),
                ),
            child: Column(
              children: <Widget>[
                SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Material(
                    elevation: 5.0,
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    child: InkWell(
                      onTap: () {
                        showSearch(context: context, delegate: SearchWidget());
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
                              Expanded(
                                child: Text(
                                  allTranslations.text(
                                      "Search for Products, Booking, Auction, ....."),
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      TextStyle(color: DataProvider().primary),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.only(top: 80, left: 15, right: 15),
        //   child: SizedBox(
        //       height: 180.0,
        //       child: Carousel(
        //         onImageTap: (int index) {},
        //         boxFit: BoxFit.contain,
        //         autoplay: false,
        //         animationCurve: Curves.fastOutSlowIn,
        //         animationDuration: Duration(milliseconds: 1000),
        //         dotSize: 4.0,
        //         dotIncreasedColor: DataProvider().primary,
        //         dotBgColor: Colors.transparent,
        //         dotPosition: DotPosition.bottomCenter,
        //         dotVerticalPadding: 10.0,
        //         showIndicator: true,
        //         indicatorBgPadding: 7.0,
        //         images: [],
        //       )),
        // ),
      ],
    );
  }
}

class Offers extends StatefulWidget {
  String shop_now;
  Offers(this.shop_now);
  @override
  _OffersState createState() => _OffersState();
}

class _OffersState extends State<Offers> {
  Color iconColor = Colors.grey;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(spacing: 10, children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              allTranslations.text("Deals of the day"),
              style: TextStyle(
                  color: DataProvider().primary, fontWeight: FontWeight.bold),
            ),
            InkWell(
              child: Text(
                allTranslations.text("See more"),
                style: TextStyle(color: DataProvider().primary),
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width * .46,
        height: MediaQuery.of(context).size.height * 0.3,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Material(
                    child: InkWell(
                      child: FutureBuilder(
                        future: precacheImage(
                        NetworkImage(
                          "listData[0].cover"),
    context),
                        builder: (context, snapshot) {
    if(snapshot.connectionState!=ConnectionState.done){
    return Container(width: double.infinity,height: 50,color: Colors.grey);
    }
                          return FadeInImage(
                            placeholder:
                                AssetImage("lib/assets/images/errorImage.png"),
                            image: NetworkImage(
                              "listData[0].cover",
                            ),
                            fit: BoxFit.fill,
                            height: MediaQuery.of(context).size.height / 4,
                          );
                        }
                      ),
                      onTap: () {},
                    ),
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "name",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                    Text(
                      "category",
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Spacer(
                        flex: 3,
                      ),
                      Text(
                        "20 USD",
                        style: TextStyle(fontSize: 10),
                      ),
                      Spacer(),
                      Text(
                        '20 USD  ',
                        style: TextStyle(
                            fontSize: 10,
                            decoration: TextDecoration.lineThrough),
                      ),
                      Spacer(
                        flex: 3,
                      ),
                    ]),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}

class HomeOffers extends StatelessWidget {
  final String offerTitle;
  final MyBanner banner;
  final String state;

  HomeOffers(this.offerTitle, this.state, [this.banner]);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          banner,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  offerTitle,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: DataProvider().primary),
                ),
              )
            ],
          ),
          Container(
              padding: EdgeInsets.symmetric(vertical: 5.0),
              height: MediaQuery.of(context).size.height * 0.3,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {},
                        child: Container(
                          width: MediaQuery.of(context).size.width * .46,
                          height: MediaQuery.of(context).size.height / 2.8,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Material(
                                      child: InkWell(
                                        child: FadeInImage(
                                          placeholder: AssetImage(
                                              "lib/assets/images/errorImage.png"),
                                          image: NetworkImage(
                                            "image",
                                          ),
                                          fit: BoxFit.cover,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                        ),
                                        onTap: () {},
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  Text(
                                    "name",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 4,
                                  ),
                                  Text(
                                    '${200} USD  ',
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
                  }))
        ],
      ),
    );
  }
}

class MyBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: MediaQuery.of(context).size.height * 0.150,
      width: double.infinity,
      child: InkWell(
        child: FadeInImage(
          placeholder: AssetImage("lib/assets/images/errorImage.png"),
          image: NetworkImage(
            "myImageurl",
          ),
          fit: BoxFit.fill,
        ),
        onTap: () {},
      ),
    );
  }
}
