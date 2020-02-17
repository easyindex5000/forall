import 'dart:convert';

import 'package:big/Providers/AuthProvider.dart';
import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/MainProvider.dart';
import 'package:big/Screens/Mall/mall.dart';
import 'package:big/Screens/SeeMore.dart';
import 'package:big/Screens/SubCategory.dart';
import 'package:big/Screens/companyProducts.dart';
import 'package:big/componets/BottomNavigationBar.dart';
import 'package:big/componets/ConnectivityChecker.dart';
import 'package:big/componets/ErrorScreen.dart';
import 'package:big/componets/MainDrawer.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/componets/notification.dart';
import 'package:big/componets/searchWidget.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:big/model/Category.dart';
import 'dart:async';
import '../localization/all_translations.dart';
import 'package:big/model/Productsmodel.dart';
import 'package:big/Screens/details.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:big/componets/Loading.dart';

List slider = [];
List<Map<String, dynamic>> sliderData = [];
List<Category> mylist;
List<Data> listData;
String myImageurl =
    'https://assets.tatacliq.com/medias/sys_master/images/13615969468446.jpg';
String myImageurl2 =
    'https://assets.tatacliq.com/medias/sys_master/images/13615969468446.jpg';
List<Data> homepageListdata;
bool isSliderLoaded = false;

class OnlineShoppingHome extends StatefulWidget {
  _OnlineShoppingHomeState createState() => _OnlineShoppingHomeState();
}

class _OnlineShoppingHomeState extends State<OnlineShoppingHome> {
  AsyncMemoizer _memorizer = AsyncMemoizer();
  StreamController _streamController = StreamController();

  // String dropdownValue = 'language';
  String logout = allTranslations.text("logout");
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLogin = true;
  String userName;
  String userEmail;
  String userImage =
      "https://onlinecoursemasters.com/wp-content/uploads/2019/05/OCM-16-Maximilian-Schwarzmuller.jpg";

  // Banner Part to show banner image

  @override
  void initState() {
    super.initState();
  }

  bool isCategoriesLoaded = false;
  bool isBannerLoaded = false;
  bool isNewLoaded = false;
  bool isPopularLoaded = false;

  Future getAllData() async {
    await sliderImages();
    _streamController.sink.add(true);
    isSliderLoaded = true;

    await fetchCategories();
    _streamController.sink.add(true);
    isCategoriesLoaded = true;

    await getBanner();
    _streamController.sink.add(true);
    isBannerLoaded = true;

    await fetchdataNew();
    _streamController.sink.add(true);
    isNewLoaded = true;

    await fetchdataPopular();
    _streamController.sink.add(true);
    isPopularLoaded = true;

    return true;
  }

  Future getBanner() async {
    await DataProvider().getPromotions().then((res) {
      var data = json.decode(res);

      myImageurl = data["data"]['image_1'];
      myImageurl2 = data["data"]['image_2'];
    });
  }

  Future<List<dynamic>> sliderImages() async {
    await DataProvider().getsliderImages().then((res) async {
      var data = json.decode(res)["data"];
      for (int x = 0; x < data.length; x++) {
        if (slider.length < data.length) {
          bool hasError = false;
          await precacheImage(NetworkImage('${data[x]['banner']}'), context,
              onError: (_, __) {
            hasError = true;
          });
          if (hasError) {
            slider.add(AssetImage(
              "lib/assets/images/errorImage.png",
            ));
          } else {
            slider.add(NetworkImage(
              '${data[x]['banner']}',
            ));
          }
        }
        sliderData.add({
          "id": data[x]['company_id'],
          "company_name": data[x]['company_name'],
        });
      }
    });
  }

  Future<List<Category>> fetchCategories() async {
    final res = await http.get(MainProvider().baseUrl + "/categories");
    List<Category> list;

    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var rest = data["data"] as List;

      mylist = rest.map<Category>((json) => Category.fromJson(json)).toList();
    }
    return list;
  }

  Future<List<Data>> fetchdataNew() async {
    final res = await http.get(MainProvider().baseUrl + "/products/new");
    List<Data> list;
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      listData = data.map<Data>((json) => Data.fromJson(json)).toList();
    }
    return list;
  }

  Future<List<Data>> fetchdataPopular() async {
    final res = await http.get(MainProvider().baseUrl + "/products/popular");
    List<Data> list;
    if (res.statusCode == 200) {
      var data = json.decode(res.body)["data"];
      homepageListdata = data.map<Data>((json) => Data.fromJson(json)).toList();

    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomNavigationBar(),
      appBar: AppBar(
        leading: IconButton(
            icon: new Icon(Icons.menu, color: DataProvider().primary),
            onPressed: () => _scaffoldKey.currentState.openDrawer()),
        backgroundColor: Colors.white,
        elevation: 0,
        //titleSpacing: 50,
        title: new Text(
          allTranslations.text('title_home'),
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          Consumer<DataProvider>(builder: (context, dataProvider, _) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchCart(dataProvider.cartCounter, false, true),
            );
          }),
        ],
      ),
      key: _scaffoldKey,
      drawer: mainDrawer(context, "home"),
      body: FutureBuilder(
          future: _memorizer.runOnce(() async {
            await Future.delayed(Duration(milliseconds: 50));

            await loadWidget(context, getAllData());
          })
            ..catchError((onError) {
              print(onError);
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => ErrorScreen()));
            }),
          builder: (context, snapshot) {
            return StreamBuilder(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                // if (snapshot.connectionState != ConnectionState.done) {
                //   return Center(child: CircularProgressIndicator());
                // }
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      HomeScreenTop(allTranslations.text("search_text")),
                      if (isCategoriesLoaded && mylist.length > 0)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                allTranslations.text("categories"),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: DataProvider().primary),
                              ),
                            )
                          ],
                        ),

                      if (isCategoriesLoaded && mylist.length > 0)
                        CategoriesList(),
                      if (isNewLoaded && listData.length > 1)
                        Offers(allTranslations.text("shop_now")),
                      //  Mygrid(),
                      if (isBannerLoaded && isPopularLoaded)
                        HomeOffers(allTranslations.text("Recommended FOR YOU"),
                            "popular", MyBanner()),
                    ],
                  ),
                );
              },
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
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      setState(() {
                        isLogin = false;
                        prefs.clear();
                        AuthProvider().googleLogout();
                        AuthProvider().logoutFace();
                      });
                      await Navigator.of(context).pop();
                    },
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                margin: EdgeInsets.all(20),
                child: Material(
                  elevation: 5.0,
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  child: InkWell(
                    onTap: () {
                      showSearch(context: context, delegate: SearchWidget());
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.search,
                              color: DataProvider().primary,
                            ),
                            SizedBox(width: 5),
                            Text(
                              widget.searchText,
                              style: TextStyle(color: DataProvider().primary),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isSliderLoaded && slider.length != 0)
          Padding(
            padding: EdgeInsets.only(top: 15, left: 15, right: 15),
            child: SizedBox(
                height: 180.0,
                child: Carousel(
                  onImageTap: (int index) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompnayProduct(
                                  compId: sliderData[index]["id"],
                                  subtitle: sliderData[index]["company_name"],
                                )));
                  },
                  boxFit: BoxFit.fill,
                  autoplay: false,
                  animationCurve: Curves.fastOutSlowIn,
                  animationDuration: Duration(milliseconds: 1000),
                  dotSize: 4.0,
                  dotIncreasedColor: DataProvider().primary,
                  dotBgColor: Colors.transparent,
                  dotPosition: DotPosition.bottomCenter,
                  dotVerticalPadding: 10.0,
                  showIndicator: true,
                  indicatorBgPadding: 7.0,
                  images: slider,
                )),
          ),
      ],
    );
  }
}

class CategoriesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        height: MediaQuery.of(context).size.height * 0.20,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: mylist.length,
            itemBuilder: ((BuildContext context, int index) {
              return AspectRatio(
                aspectRatio: 1,
                child: Container(
                    decoration: BoxDecoration(
                      //    border: Border.all(color: Colors.black),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 2.0,
                        )
                      ],
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFFffffff), Color(0xFFffffff)]),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => SubCategory(
                                      catID: mylist[index].id,
                                      subtitle: mylist[index].name,
                                    )));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            flex: 6,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 7.0),
                              width: MediaQuery.of(context).size.width * 0.13,
                              child: FittedBox(
                                child: Icon(
                                  IconData(int.parse(mylist[index].iconCode),
                                      fontFamily: mylist[index].iconFont),
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            mylist[index].name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Spacer()
                        ],
                      ),
                    )),
              );
            })));
  }
}

//offers Part Two Cards ---------Torres

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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    if (width >= 600) {}
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
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SeeMore(listData)));
              },
            ),
          ],
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ProductDetails(listData[0].id)));
        },
        child: Container(
          width: MediaQuery.of(context).size.width * .46,
          height: 200,
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
                      child: FutureBuilder(
                          future: precacheImage(
                              NetworkImage(listData[0].cover), context),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState !=
                                ConnectionState.done) {
                              return Container(
                                  width: double.infinity,
                                  height: 100,
                                  color: Colors.grey);
                            }
                            return FadeInImage(
                              placeholder: AssetImage(
                                  "lib/assets/images/errorImage.png"),
                              image: NetworkImage(
                                listData[0].cover,
                              ),
                              fit: BoxFit.fill,
                              height: MediaQuery.of(context).size.height / 4,
                            );
                          }),
                    ),
                  ),
                  Divider(),
                  Text(
                    "${listData[0].name}",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  ),
                  Wrap(children: <Widget>[
                    Text(
                      '${listData[0].price} USD  ',
                      style: TextStyle(
                          fontSize: 10, decoration: TextDecoration.lineThrough),
                    ),
                    Text(
                      "  ${listData[0].offer} USD",
                      style: TextStyle(fontSize: 10),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
      InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      ProductDetails(listData[1].id)));
        },
        child: Container(
          width: MediaQuery.of(context).size.width * .46,
          height: 200,
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
                                  listData[1].cover,
                                ),
                                context),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState !=
                                  ConnectionState.done) {
                                return Container(
                                    width: double.infinity,
                                    height: 100,
                                    color: Colors.grey);
                              }
                              return FadeInImage(
                                placeholder: AssetImage(
                                    "lib/assets/images/errorImage.png"),
                                image: NetworkImage(
                                  listData[1].cover,
                                ),
                                fit: BoxFit.fill,
                                height: MediaQuery.of(context).size.height / 4,
                              );
                            }),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ProductDetails(listData[1].id)));
                        },
                      ),
                    ),
                  ),
                  Divider(),
                  Text(
                    "${listData[1].name}",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                  ),
                  Wrap(children: <Widget>[
                    Text(
                      '${listData[1].price} USD  ',
                      style: TextStyle(
                          fontSize: 10, decoration: TextDecoration.lineThrough),
                    ),
                    Text(
                      "  ${listData[1].offer} USD",
                      style: TextStyle(fontSize: 10),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}

class MyBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      height: MediaQuery.of(context).size.height * 0.150,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder(
          future: precacheImage(NetworkImage(myImageurl), context),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                          constraints:
                              BoxConstraints(maxWidth: double.infinity),
                          width: 200,
                          height: 100,
                          color: Colors.grey),
                    ),
                  ),
                ],
              );
            }
            return FadeInImage(
              placeholder: AssetImage("lib/assets/images/errorImage.png"),
              image: NetworkImage(
                myImageurl,
              ),
              fit: BoxFit.fill,
            );
          }),
    );
  }
}
// offers like most arraival & best seller
//take title & bannerimage from banner class and will take List of proucdes

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
                  itemCount: homepageListdata.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      ProductDetails(
                                          homepageListdata[index].id)));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .46,
                          height: 200,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: Material(
                                      child: InkWell(
                                        child: FutureBuilder(
                                            future: precacheImage(
                                                NetworkImage(
                                                    homepageListdata[0].cover),
                                                context),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState !=
                                                  ConnectionState.done) {
                                                return Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    height: 50,
                                                    color: Colors.grey);
                                              }
                                              return FadeInImage(
                                                placeholder: AssetImage(
                                                    "lib/assets/images/errorImage.png"),
                                                image: NetworkImage(
                                                  homepageListdata[0].cover,
                                                ),
                                                fit: BoxFit.cover,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    4,
                                              );
                                            }),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContextcontext) =>
                                                          ProductDetails(
                                                              homepageListdata[
                                                                      0]
                                                                  .id)));
                                        },
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  Text(
                                    "${homepageListdata[0].name}",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 4,
                                  ),
                                  Wrap(children: <Widget>[
                                    Text(
                                      '${homepageListdata[0].price} USD  ',
                                      style: TextStyle(
                                          fontSize: 10,
                                          decoration:
                                              TextDecoration.lineThrough),
                                    ),
                                    Text(
                                      "  ${homepageListdata[0].offer} USD",
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ]),
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
