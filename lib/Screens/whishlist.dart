import 'package:big/Providers/DataProvider.dart';
import 'package:big/Screens/Mall/Products.dart';
import 'package:big/Screens/Mall/mallDetails.dart';
import 'package:big/Screens/details.dart';
import 'package:big/Screens/wuzzef/jobDetails.dart';
import 'package:big/Widgets/dataManager.dart';
import 'package:big/componets/Error.dart';
import 'package:big/componets/ErrorScreen.dart';
import 'package:big/componets/platform_icons.dart';
import 'package:big/componets/shopping_icons.dart';
import 'package:big/localization/all_translations.dart';
import 'package:big/model/Mall/Mall.dart';
import 'package:big/model/Mall/Stores.dart';
import 'package:big/model/Productsmodel.dart';
import 'package:big/model/wuzzef/job.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';
import 'package:provider/provider.dart';
import 'package:big/componets/drawer_icons_icons.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'OnlineStoreHomeScreen.dart';

enum _SelectedTabs { Shopping, Malls, Stores, Wuzzef }

class Wishlist extends StatefulWidget {
  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  AsyncMemoizer _memorizer = AsyncMemoizer();

  String title = "${allTranslations.text('wishlist')}";
  bool _onEdit = false;
  // List productList = DataProvider.productList;
  int val = 25;
  List ProductDb = [];
  List<MallData> malls = [];
  List<Store> stores = [];
  List<Job> jobs = [];

  var db = DatabaseManager();
  List<int> selectedIDsSopping = [];
  List<int> selectedIDsMalls = [];
  List<int> selectedIDsStores = [];
  List<int> selectedIDsJobs = [];

  final List<_TabData> tabs = [
    _TabData(allTranslations.text("Shopping"), Shopping.product,
        _SelectedTabs.Shopping),
    _TabData(allTranslations.text("Malls"), Shopping.mall, _SelectedTabs.Malls),
    _TabData(
        allTranslations.text("Store"), Shopping.shop, _SelectedTabs.Stores),
    _TabData(
        allTranslations.text("wuzzef"), Platform.job_seeker, _SelectedTabs.Wuzzef),
  ];
  _SelectedTabs _selectedTab = _SelectedTabs.Shopping;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double itemHeight = MediaQuery.of(context).size.height * 0.36;
    final double itemWidth = MediaQuery.of(context).size.width * 0.40;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: DataProvider().primary,
                  ),
                  onPressed: () => Navigator.of(context).pop());
            },
          ),
          title: Text(
            allTranslations.text("WishList"),
            style: TextStyle(color: DataProvider().secondry),
          ),
          actions: <Widget>[
            if (ProductDb.length + malls.length + stores.length > 0)
              IconButton(
                  onPressed: () {
                    _onEdit = !_onEdit;
                    setState(() {});
                  },
                  icon: Icon(
                    _onEdit ? Icons.close : Shopping.edit,
                    color: DataProvider().primary,
                  ))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tabs.length,
                  itemBuilder: (_, index) {
                    if (index == 2) {
                      return InkWell(
                        onTap: () {
                          _selectedTab = tabs[index]._selectedTab;
                          setState(() {});
                        },
                        child: Container(
                          margin: EdgeInsetsDirectional.fromSTEB(0, 10, 10, 10),
                          height: 80,
                          width: 80,
                          decoration: ShapeDecoration(
                              color: Colors.white,
                              shadows: [
                                BoxShadow(
                                  blurRadius: 6,
                                  color: Color(0xff29000000),
                                  offset: Offset(3, 3),
                                ),
                              ],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                "lib/assets/images/mall.png",
                                width: 24,
                                height: 24,
                                fit: BoxFit.fill,
                                color: _selectedTab == tabs[index]._selectedTab
                                    ? DataProvider().primary
                                    : Colors.black,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                tabs[index].title,
                                style: TextStyle(
                                    color:
                                        _selectedTab == tabs[index]._selectedTab
                                            ? DataProvider().primary
                                            : Colors.black),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                    return InkWell(
                      onTap: () {
                        _selectedTab = tabs[index]._selectedTab;
                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsetsDirectional.fromSTEB(0, 10, 10, 10),
                        height: 80,
                        width: 80,
                        decoration: ShapeDecoration(
                            color: Colors.white,
                            shadows: [
                              BoxShadow(
                                blurRadius: 6,
                                color: Color(0xff29000000),
                                offset: Offset(3, 3),
                              ),
                            ],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              tabs[index].iconData,
                              color: _selectedTab == tabs[index]._selectedTab
                                  ? DataProvider().primary
                                  : Colors.black,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              tabs[index].title,
                              style: TextStyle(
                                  color:
                                      _selectedTab == tabs[index]._selectedTab
                                          ? DataProvider().primary
                                          : Colors.black),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: _memorizer.runOnce(() async {
                    return await getData();
                  })
                    ..catchError((onError) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => ErrorScreen()));
                    }),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return CustomErrorWidget();
                    }
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if ((snapshot.connectionState == ConnectionState.done) &&
                        (_SelectedTabs.Shopping == _selectedTab &&
                                ProductDb.length > 0 ||
                            _SelectedTabs.Malls == _selectedTab &&
                                malls.length > 0 ||
                            _SelectedTabs.Stores == _selectedTab &&
                                stores.length > 0||
                            _SelectedTabs.Wuzzef == _selectedTab &&
                                jobs.length > 0)) {
                      print(_selectedTab.toString()+" elected tab");
                      return Column(
                        children: <Widget>[
                          Expanded(
                            child: ListView(
                              children: <Widget>[
                                if(_selectedTab==_SelectedTabs.Wuzzef&&jobs.length>0)
                                  _wuzzef(),
                                if ((_selectedTab == _SelectedTabs.Shopping) &&
                                    ProductDb.length > 0)
                                  _shopping(),
                                if ((_selectedTab == _SelectedTabs.Malls) &&
                                    malls.length > 0)
                                  _malls(itemWidth, itemHeight),
                                if ((_selectedTab == _SelectedTabs.Stores) &&
                                    stores.length > 0)
                                  _stores(itemWidth, itemHeight),
                              ],
                            ),
                          ),
                          if (_onEdit)
                            RaisedButton(
                              color: selectedIDsSopping.length +
                                          selectedIDsMalls.length +
                                          selectedIDsStores.length >
                                      0
                                  ? DataProvider().primary
                                  : Colors.white,
                              child: Container(
                                width: double.infinity,
                                child: Text(
                                  allTranslations.text("Delete"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: selectedIDsSopping.length +
                                                  selectedIDsMalls.length +
                                                  selectedIDsStores.length >
                                              0
                                          ? Colors.white
                                          : DataProvider().primary),
                                ),
                              ),
                              onPressed: () async {
                                await deleteFav();
                                setState(() {});
                              },
                            )
                        ],
                      );
                    } else {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Spacer(),
                              Expanded(
                                child: Image.asset(
                                  "lib/assets/images/mazad/Wishlist-Empty.png",
                                ),
                              ),
                              Text(
                                allTranslations.text("Your Wishlist is Empty"),
                                style: TextStyle(
                                    color: Color(0xFF707070),
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              RaisedButton(
                                color: DataProvider().primary,
                                child: Container(
                                  width: double.infinity,
                                  child: Text(
                                    allTranslations.text("ExPLORE OuR OfFERS"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                onPressed: () async {
                                  await Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              OnlineShoppingHome()));
                                  getData();
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
Widget _wuzzef()
{
  print("aaaaaaaaaaaaaaa");
 return ListView.builder(
      itemCount: jobs.length,shrinkWrap: true,
      itemBuilder: (context, index) {
        return Stack(
          children: <Widget>[
            InkWell(
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
                                  jobs[index].title,
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight.bold),
                                ),
                                Text(
                                  " [${jobs[index].jobType}]",
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight.bold,
                                      color: DataProvider()
                                          .primary),
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
                          Text("${jobs[index].city},${jobs[index].country}")
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                              child:
                              Text(jobs[index].description)),
                        ],
                      ),
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons
                                .subdirectory_arrow_right),
                            onPressed: () {},
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
              onTap: () {
                if(_onEdit){
                  if (selectedIDsJobs
                      .contains(jobs[index].id)) {
                    selectedIDsJobs
                        .remove(jobs[index].id);
                  } else {
                    selectedIDsJobs.add(jobs[index].id);
                  }
                  setState(() {});
                }else{
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => JobDetails()));
                }

              },
            ),
            if (_onEdit &&
                selectedIDsJobs
                    .contains(jobs[index].id))
              Positioned(
                  top: 10,
                  left: 10,
                  child: Icon(
                    Icons.check_circle,
                    color: DataProvider().primary,
                  )),
            if (_onEdit &&
                !selectedIDsJobs
                    .contains(jobs[index].id))
              Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                                12),
                            side: BorderSide(
                                color: DataProvider()
                                    .primary,
                                width: 2))),
                  ))
          ],
        );
      });

}  Widget _stores(double itemWidth, double itemHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Text(
          allTranslations.text("Stores"),
          style: TextStyle(
              color: DataProvider().primary,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        GridView.builder(
            shrinkWrap: true,
            itemCount: stores.length,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 144 / 165,
                crossAxisSpacing: 24,
                mainAxisSpacing: 17),
            itemBuilder: (BuildContext context, int index) {
              return StatefulBuilder(builder: (context, setState) {
                return Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Container(
                      child: Card(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: InkWell(
                                  child: Stack(
                                    children: <Widget>[
                                      Builder(builder: (
                                        context,
                                      ) {
                                        bool hasError = false;
                                        return FutureBuilder(
                                            future: precacheImage(
                                                NetworkImage(
                                                    "${stores[index].cover}"),
                                                context, onError: (_, __) {
                                              hasError = true;
                                            }),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState !=
                                                  ConnectionState.done) {
                                                return new Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[],
                                                  ),
                                                  height: double.infinity,
                                                  decoration: new BoxDecoration(
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              }
                                              if (!snapshot.hasError &&
                                                  snapshot.connectionState ==
                                                      ConnectionState.done) {
                                                return new Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[],
                                                  ),
                                                  height: double.infinity,
                                                  decoration: new BoxDecoration(
                                                    image: new DecorationImage(
                                                        fit: BoxFit.contain,
                                                        image: NetworkImage(
                                                            "${stores[index].cover}")),
                                                  ),
                                                );
                                              } else {
                                                return Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[],
                                                  ),
                                                  height: double.infinity,
                                                  decoration: new BoxDecoration(
                                                    image: new DecorationImage(
                                                        fit: BoxFit.contain,
                                                        image: AssetImage(
                                                            "lib/assets/images/errorImage.png")),
                                                  ),
                                                );
                                              }
                                            });
                                      }),
                                      if (_onEdit &&
                                          selectedIDsStores
                                              .contains(stores[index].id))
                                        Positioned(
                                            top: 10,
                                            left: 10,
                                            child: Icon(
                                              Icons.check_circle,
                                              color: DataProvider().primary,
                                            )),
                                      if (_onEdit &&
                                          !selectedIDsStores
                                              .contains(stores[index].id))
                                        Positioned(
                                            top: 10,
                                            left: 10,
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              decoration: ShapeDecoration(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      side: BorderSide(
                                                          color: DataProvider()
                                                              .primary,
                                                          width: 2))),
                                            ))
                                    ],
                                  ),
                                  onTap: () async {
                                    if (_onEdit) {
                                      if (selectedIDsStores
                                          .contains(stores[index].id)) {
                                        selectedIDsStores
                                            .remove(stores[index].id);
                                      } else {
                                        selectedIDsStores.add(stores[index].id);
                                      }
                                      setState(() {});
                                    } else {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => Products(
                                                  mallID: stores[index].mallID,
                                                  storeID: stores[index].id)));
                                      getData();
                                    }
                                  }),
                            ),
                            new Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            new Text(
                                              "${stores[index].name} ",
                                              style: new TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 12,
                                                  color: Color(0XFF161a28)),
                                            ),
                                            new Text(
                                              stores[index].name.toString(),
                                              style: TextStyle(
                                                  color: Color(0XFF7f7f7f),
                                                  fontWeight: FontWeight.w100,
                                                  fontSize: 8,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          color: Colors.white,
                                          child: Text(
                                            stores[index].location,
                                            overflow: TextOverflow.ellipsis,
                                            style: new TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 8,
                                                color: Color(0XFF5d5e62)),
                                            maxLines: 2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                width: double.infinity,
                                margin: EdgeInsets.all(10.0),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 13, vertical: 6),
                                decoration: ShapeDecoration(
                                    color: DataProvider().primary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4))),
                                child: Text(allTranslations.text("View Store"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white))),
                          ],
                        ),
                      ),
                    ));
              });
            }),
      ],
    );
  }

  Widget _malls(double itemWidth, double itemHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Text(
          allTranslations.text("Malls"),
          style: TextStyle(
              color: DataProvider().primary,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        GridView.builder(
            shrinkWrap: true,
            itemCount: malls.length,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 144 / 165,
                crossAxisSpacing: 24,
                mainAxisSpacing: 17),
            itemBuilder: (BuildContext context, int index) {
              return StatefulBuilder(builder: (context, setState) {
                return Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Container(
                      child: Card(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: InkWell(
                                  child: Stack(
                                    children: <Widget>[
                                      Builder(builder: (
                                        context,
                                      ) {
                                        bool hasError = false;
                                        return FutureBuilder(
                                            future: precacheImage(
                                                NetworkImage(
                                                    "${malls[index].cover}"),
                                                context, onError: (_, __) {
                                              hasError = true;
                                            }),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState !=
                                                  ConnectionState.done) {
                                                return new Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[],
                                                  ),
                                                  height: double.infinity,
                                                  decoration: new BoxDecoration(
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              }
                                              if (!hasError &&
                                                  snapshot.connectionState ==
                                                      ConnectionState.done) {
                                                return new Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[],
                                                  ),
                                                  height: double.infinity,
                                                  decoration: new BoxDecoration(
                                                    image: new DecorationImage(
                                                        fit: BoxFit.contain,
                                                        image: NetworkImage(
                                                            "${malls[index].cover}")),
                                                  ),
                                                );
                                              } else {
                                                return Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[],
                                                  ),
                                                  height: double.infinity,
                                                  decoration: new BoxDecoration(
                                                    image: new DecorationImage(
                                                        fit: BoxFit.contain,
                                                        image: AssetImage(
                                                            "lib/assets/images/errorImage.png")),
                                                  ),
                                                );
                                              }
                                            });
                                      }),
                                      if (_onEdit &&
                                          selectedIDsMalls
                                              .contains(malls[index].id))
                                        Positioned(
                                            top: 10,
                                            left: 10,
                                            child: Icon(
                                              Icons.check_circle,
                                              color: DataProvider().primary,
                                            )),
                                      if (_onEdit &&
                                          !selectedIDsMalls
                                              .contains(malls[index].id))
                                        Positioned(
                                            top: 10,
                                            left: 10,
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              decoration: ShapeDecoration(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      side: BorderSide(
                                                          color: DataProvider()
                                                              .primary,
                                                          width: 2))),
                                            ))
                                    ],
                                  ),
                                  onTap: () async {
                                    if (_onEdit) {
                                      if (selectedIDsMalls
                                          .contains(malls[index].id)) {
                                        selectedIDsMalls
                                            .remove(malls[index].id);
                                      } else {
                                        selectedIDsMalls.add(malls[index].id);
                                      }
                                      setState(() {});
                                    } else {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MallDetails(
                                                  id: malls[index].id)));
                                      getData();
                                    }
                                  }),
                            ),
                            new Padding(
                              padding: EdgeInsets.all(2.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start 
                                
                                ,
                                children: <Widget>[
                                  new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            new Text(
                                              "${malls[index].name} ",
                                              style: new TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 13,
                                                  color: Color(0XFF161a28)),
                                            ),
                                            new Text(
                                              malls[index].name.toString(),
                                              style: TextStyle(
                                                  color: Color(0XFF7f7f7f),
                                                  fontWeight: FontWeight.w100,
                                                  fontSize: 10,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          color: Colors.white,
                                          child: Text(
                                            malls[index].city,
                                            overflow: TextOverflow.ellipsis,
                                            style: new TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12,
                                                color: Color(0XFF5d5e62)),
                                            maxLines: 2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                        SmoothStarRating(
                    allowHalfRating: true,
                    rating:malls[index].rating ,
                    size: 12,
                    color: Color(0xffefce4a),
                    borderColor: Colors.grey,
                  )
                                ],
                              ),
                            ),
                            Container(
                                width: double.infinity,
                                margin: EdgeInsets.all(5.0),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 13, vertical: 6),
                                decoration: ShapeDecoration(
                                    color: DataProvider().primary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4))),
                                child: Text(allTranslations.text("View Mall"),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white))),
                          ],
                        ),
                      ),
                    ));
              });
            }),
      ],
    );
  }

  Widget _shopping() {
    final double itemHeight = MediaQuery.of(context).size.height * 0.36;
    final double itemWidth = MediaQuery.of(context).size.width * 0.40;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 10,
        ),
        Text(
          allTranslations.text("Shopping"),
          style: TextStyle(
              color: DataProvider().primary,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        GridView.builder(
            shrinkWrap: true,
            itemCount: ProductDb.length,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 0.8),
            itemBuilder: (BuildContext context, int index) {
              Product product = Product.map(ProductDb[index]);

              return StatefulBuilder(builder: (context, setState) {
                return Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Container(
                      child: Card(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: InkWell(
                                  child: Stack(
                                    children: <Widget>[
                                      Builder(builder: (
                                        context,
                                      ) {
                                        bool hasError = false;
                                        return FutureBuilder(
                                            future: precacheImage(
                                                NetworkImage(
                                                    "${product.imageUrl}"),
                                                context, onError: (_, __) {
                                              hasError = true;
                                            }),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState !=
                                                  ConnectionState.done) {
                                                return new Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[],
                                                  ),
                                                  height: double.infinity,
                                                  decoration: new BoxDecoration(
                                                    color: Colors.grey,
                                                  ),
                                                );
                                              }
                                              if (!hasError &&
                                                  snapshot.connectionState ==
                                                      ConnectionState.done) {
                                                return new Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      if (product.isNew == 1)
                                                        Stack(
                                                          children: <Widget>[
                                                            Transform.translate(
                                                              offset: Offset(
                                                                  -10.0, -10.0),
                                                              child: Container(
                                                                width: 45.0,
                                                                height: 20.0,
                                                                color: Color(
                                                                    0XFFff2b2b),
                                                                child: Text(
                                                                  allTranslations
                                                                      .text(
                                                                          "New"),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                  height: double.infinity,
                                                  decoration: new BoxDecoration(
                                                    image: new DecorationImage(
                                                        fit: BoxFit.contain,
                                                        image: NetworkImage(
                                                            "${product.imageUrl}")),
                                                  ),
                                                );
                                              } else {
                                                return new Container(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      if (product.isNew == 1)
                                                        Stack(
                                                          children: <Widget>[
                                                            Transform.translate(
                                                              offset: Offset(
                                                                  -10.0, -10.0),
                                                              child: Container(
                                                                width: 45.0,
                                                                height: 20.0,
                                                                color: Color(
                                                                    0XFFff2b2b),
                                                                child: Text(
                                                                  allTranslations
                                                                      .text(
                                                                          "New"),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                  height: double.infinity,
                                                  decoration: new BoxDecoration(
                                                    image: new DecorationImage(
                                                        fit: BoxFit.contain,
                                                        image: AssetImage(
                                                            "lib/assets/images/errorImage.png")),
                                                  ),
                                                );
                                              }
                                            });
                                      }),
                                      if (_onEdit &&
                                          selectedIDsSopping
                                              .contains(product.productID))
                                        Positioned(
                                            top: 10,
                                            left: 10,
                                            child: Icon(
                                              Icons.check_circle,
                                              color: DataProvider().primary,
                                            )),
                                      if (_onEdit &&
                                          !selectedIDsSopping
                                              .contains(product.productID))
                                        Positioned(
                                            top: 10,
                                            left: 10,
                                            child: Container(
                                              width: 24,
                                              height: 24,
                                              decoration: ShapeDecoration(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      side: BorderSide(
                                                          color: DataProvider()
                                                              .primary,
                                                          width: 2))),
                                            ))
                                    ],
                                  ),
                                  onTap: () async {
                                    if (_onEdit) {
                                      if (selectedIDsSopping
                                          .contains(product.productID)) {
                                        selectedIDsSopping
                                            .remove(product.productID);
                                      } else {
                                        selectedIDsSopping
                                            .add(product.productID);
                                      }
                                      setState(() {});
                                    } else {
                                      await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductDetails(
                                                      product.productID)));
                                      getData();
                                    }
                                  }),
                            ),
                            new Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          children: <Widget>[
                                            new Text(
                                              "${product.offer} ",
                                              style: new TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color: Color(0XFF161a28)),
                                            ),
                                            new Text(
                                              product.price.toString(),
                                              style: TextStyle(
                                                  color: Color(0XFF7f7f7f),
                                                  fontWeight: FontWeight.w100,
                                                  fontSize: 12,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          color: Colors.white,
                                          child: Text(
                                            product.description,
                                            overflow: TextOverflow.ellipsis,
                                            style: new TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 12,
                                                color: Color(0XFF5d5e62)),
                                            maxLines: 2,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Consumer<DataProvider>(
                                builder: (context, dataProvider, _) {
                              return InkWell(
                                onTap: () async {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              ProductDetails(product.id)));
                                  getData();
                                },
                                child: Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.all(10.0),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 13, vertical: 6),
                                    decoration: ShapeDecoration(
                                        color: DataProvider().primary,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(4))),
                                    child: Text(
                                        allTranslations.text("Add To Bag"),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white))),
                              );
                            })
                          ],
                        ),
                      ),
                    ));
              });
            }),
      ],
    );
  }

  Future getData() async {
    await getProducts();
    await getMalls();

    await getStores();
    await getJobs();
    setState(() {});
  }

  Future getProducts() async {
    ProductDb = await db.getAllProducts();
  }

  getJobs() async {
    print("mmmmmmmmmm");

    var res = await db.getallRows(db.wuzzefTable);

    jobs = res.map<Job>((json) {
      print(json);
      return Job.fromJson(json);
    }).toList();
    print(jobs.length);
    print("sggggggggg");
  }

  getMalls() async {
    var res = await db.getallRows(db.mallTable);

    malls = res.map<MallData>((json) {
      return MallData(
        id: json['id'],
        name: json['name'] as String,
        image: json['cover'] as String,
        openTime: json['open_time'] as String,
        closeTime: json['close_time'] as String,
        map: json['map'] as String,
        cover: json['cover'] as String,
        city: json['city'] as String,
        location: json['location'] as String,
                rating: json['rating'] ,

      );
    }).toList();
  }

  getStores() async {
    var res = await db.getallRows(db.storeTable);
    stores = res.map<Store>((json) => Store.fromJson(json)).toList();
  }

  Future deleteFav() async {
    for (int id in selectedIDsSopping) {
      await db.deleteProduct(id);
      ProductDb.removeWhere((test) {
        return test["productID"] == id;
      });
    }
    for (int id in selectedIDsMalls) {
      await db.deleteItem(db.mallTable, id);
      malls.removeWhere((test) {
        return test.id == id;
      });
    }
    for (int id in selectedIDsStores) {
      await db.deleteItem(db.storeTable, id);
      stores.removeWhere((test) {
        return test.id == id;
      });
    }
    for (int id in selectedIDsJobs) {
      await db.deleteItem(db.wuzzefTable, id);
      jobs.removeWhere((test) {
        return test.id == id;
      });
    }
    setState(() {});
  }
}

class _TabData {
  final String title;
  final IconData iconData;
  _SelectedTabs _selectedTab;
  _TabData(this.title, this.iconData, this._selectedTab);
}
