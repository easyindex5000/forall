import 'package:big/Providers/DataProvider.dart';
import 'package:big/Screens/Mall/mall.dart';
import 'package:big/Screens/OnlineStoreHomeScreen.dart';
import 'package:big/Screens/Uber/UberHomeScreen.dart';
import 'package:big/Screens/UnderConstraction.dart';
import 'package:big/Screens/mazad/MazadHome.dart';
import 'package:big/componets/BottomNavigationBar.dart';
import 'package:big/componets/ConnectivityChecker.dart';
import 'package:big/componets/MainDrawer.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:provider/provider.dart';
import 'package:big/componets/notification.dart';

import 'ForAllHome.dart';

class MasterHome extends StatefulWidget {
  @override
  _MasterHomeState createState() => _MasterHomeState();
}

class _MasterHomeState extends State<MasterHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
@override
  void initState() {
 NotificationHandler().init(context);
    ConnectivityChecker().init(context);    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'FOR ALL',
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          Consumer<DataProvider>(builder: (context, dataProvider, _) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(8.0,15,8,8),
              child: SearchCart(dataProvider.cartCounter, false, true),
            );
          }),
        ],
      ),
      key: _scaffoldKey,
      drawer: mainDrawer(context, "home"),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(cacheExtent: 10000,
                children: <Widget>[
                  // HomeScreenTop(allTranslations.text("search_text")),
                  SizedBox(
                      height: 200.0,
                      width: 350.0,
                      child: Carousel(
                        images: [
                          NetworkImage(
                              'https://images.unsplash.com/photo-1522204523234-8729aa6e3d5f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80'),
                          NetworkImage(
                              'https://images.unsplash.com/photo-1483450388369-9ed95738483c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80'),
                          NetworkImage(
                              'https://images.unsplash.com/photo-1533777857889-4be7c70b33f7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80'),
                        ],
                        dotSize: 4.0,
                        dotSpacing: 15.0,
                        dotColor: DataProvider().primary,
                        indicatorBgPadding: 5.0,
                        dotBgColor: Colors.transparent,
                        borderRadius: true,
                        moveIndicatorFromBottom: 180.0,
                        noRadiusForIndicator: true,
                      )),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          allTranslations.text("Online shopping"),
                          style: TextStyle(
                              color: DataProvider().primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  OnlineShoppingHome()));
                    },
                    child: Container(
                      height: 140,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 32, right: 32),
                        child: _loadingAndCachingWidget(
                          "https://images.unsplash.com/photo-1483985988355-763728e1935b?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: 128,
                          child: Card(
                              child: _loadingAndCachingWidget(
                            "https://images.unsplash.com/photo-1546054454-aa26e2b734c7?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2000&q=80",
                            fit: BoxFit.fill,
                          )),
                        ),
                        Spacer(),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          height: 128,
                          child: Card(
                              child: _loadingAndCachingWidget(
                                  "https://images.unsplash.com/photo-1519415943484-9fa1873496d4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80",
                                  fit: BoxFit.fill)),
                        ),
                      ],
                    ),
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     Padding(
                  //       padding: const EdgeInsets.all(24.0),
                  //       child: Text(
                  //         allTranslations.text("Booking"),
                  //         style: TextStyle(
                  //             color: DataProvider().primary,
                  //             fontWeight: FontWeight.bold),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (BuildContext context) =>
                  //                 UnderConstraction(
                  //                   title: "Booking",
                  //                 )));
                  //   },
                  //   child: Container(
                  //     height: 140,
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(left: 32, right: 32),
                  //       child: _loadingAndCachingWidget(
                  //         "https://www.pegs.com/wp-content/uploads/2016/11/tt-reztrip-mobile-booking-engine.jpg",
                  //         fit: BoxFit.cover,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: <Widget>[
                  //       Container(
                  //         height: 128,
                  //         width: MediaQuery.of(context).size.width / 2.5,
                  //         child: _loadingAndCachingWidget(
                  //           "https://cdn.pixabay.com/photo/2016/03/04/19/36/beach-1236581_960_720.jpg",
                  //           fit: BoxFit.fill,
                  //         ),
                  //       ),
                  //       Spacer(),
                  //       Container(
                  //         height: 128,
                  //         width: MediaQuery.of(context).size.width / 2.5,
                  //         child: _loadingAndCachingWidget(
                  //           "https://cdn.pixabay.com/photo/2017/07/21/23/57/concert-2527495_960_720.jpg",
                  //           fit: BoxFit.fill,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          allTranslations.text("Online Mall"),
                          style: TextStyle(
                              color: DataProvider().primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Malls()));
                    },
                    child: Container(
                      height: 140,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 32, right: 32),
                        child: _loadingAndCachingWidget(
                          "https://images.unsplash.com/photo-1522684462852-01b24e76b77d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 128,
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: _loadingAndCachingWidget(
                              "https://images.unsplash.com/photo-1441984904996-e0b6ba687e04?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80",
                              fit: BoxFit.fill),
                        ),
                        Spacer(),
                        Container(
                          height: 128,
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: _loadingAndCachingWidget(
                              "https://images.unsplash.com/photo-1521335629791-ce4aec67dd15?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80",
                              fit: BoxFit.fill),
                        ),
                      ],
                    ),
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     Padding(
                  //       padding: const EdgeInsets.all(24.0),
                  //       child: Text(
                  //         allTranslations.text("Delivery"),
                  //         style: TextStyle(
                  //             color: DataProvider().primary,
                  //             fontWeight: FontWeight.bold),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (BuildContext context) =>
                  //                 UnderConstraction(
                  //                   title: "Delivery",
                  //                 )));
                  //   },
                  //   child: Container(
                  //     height: 140,
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(left: 32, right: 32),
                  //       child: _loadingAndCachingWidget(
                  //         "https://images.unsplash.com/photo-1548695607-9c73430ba065?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1484&q=80",
                  //         fit: BoxFit.cover,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: <Widget>[
                  //       Container(
                  //         height: 128,
                  //         width: MediaQuery.of(context).size.width / 2.5,
                  //         child: _loadingAndCachingWidget(
                  //             "https://images.unsplash.com/photo-1560971017-e39da06c9a31?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=947&q=80",
                  //             fit: BoxFit.fill),
                  //       ),
                  //       Spacer(),
                  //       Container(
                  //         height: 128,
                  //         width: MediaQuery.of(context).size.width / 2.5,
                  //         child: _loadingAndCachingWidget(
                  //             "https://images.unsplash.com/photo-1565290538967-a18f519b6cae?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1350&q=80",
                  //             fit: BoxFit.fill),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                 
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(
                          allTranslations.text("Auction"),
                          style: TextStyle(
                              color: DataProvider().primary,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => MazadHome()));
                    },
                    child: Container(
                      height: 140,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 32, right: 32),
                        child: _loadingAndCachingWidget(
                          "https://images.unsplash.com/photo-1575505586569-646b2ca898fc?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1505&q=80",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          height: 128,
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: _loadingAndCachingWidget(
                              "https://news.artnet.com/app/news-upload/2017/11/GettyImages-50947488-1024x687.jpg",
                              fit: BoxFit.fill),
                        ),
                        Spacer(),
                        Container(
                          height: 128,
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: _loadingAndCachingWidget(
                              "https://images.squarespace-cdn.com/content/v1/597f9bfdb3db2beb6fcdce94/1510554673422-AI3Z99RMAABQ0KKH5V2B/ke17ZwdGBToddI8pDm48kFyD7pzB8zoMIVY5aiUuFlp7gQa3H78H3Y0txjaiv_0fDoOvxcdMmMKkDsyUqMSsMWxHk725yiiHCCLfrh8O1z4YTzHvnKhyp6Da-NYroOW3ZGjoBKy3azqku80C789l0jG2lbcDYBOeMi4OFSYem8DMb5PTLoEDdB05UqhYu-xbnSznFxIRsaAU-3g5IaylIg/WVAuction-1007.jpg?format=2500w",
                              fit: BoxFit.fill),
                        ),
                      ],
                    ),
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     Padding(
                  //       padding: const EdgeInsets.all(24.0),
                  //       child: Text(
                  //         allTranslations.text("Transportation"),
                  //         style: TextStyle(
                  //             color: DataProvider().primary,
                  //             fontWeight: FontWeight.bold),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (BuildContext context) =>
                  //                 UberHomeScreen()));
                  //   },
                  //   child: Container(
                  //     height: 140,
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(left: 32, right: 32),
                  //       child: _loadingAndCachingWidget(
                  //         "https://www.english-learn-online.com/wp-content/uploads/transportation-696x373.jpg",
                  //         fit: BoxFit.cover,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: <Widget>[
                  //       Container(
                  //         height: 128,
                  //         width: MediaQuery.of(context).size.width / 2.5,
                  //         child: _loadingAndCachingWidget(
                  //             "https://cdn5.img.sputniknews.com/images/105098/83/1050988386.jpg",
                  //             fit: BoxFit.fill),
                  //       ),
                  //       Spacer(),
                  //       Container(
                  //         height: 128,
                  //         width: MediaQuery.of(context).size.width / 2.5,
                  //         child: _loadingAndCachingWidget(
                  //             "https://en.parisinfo.com/var/otcp/sites/images/node_43/node_51/node_77884/node_77889/uber-airport-pickup-paris-%7C-630x405-%7C-%C2%A9-uber/18856048-1-fre-FR/Uber-Airport-pickup-Paris-%7C-630x405-%7C-%C2%A9-UBER.jpg",
                  //             fit: BoxFit.fill),
                  //       ),
                  //     ],
                  //   ),
                  // ),
            
                  // Row(
                  //   children: <Widget>[
                  //     Padding(
                  //       padding: const EdgeInsets.all(24.0),
                  //       child: Text(
                  //         allTranslations.text("Recruitment"),
                  //         style: TextStyle(
                  //             color: DataProvider().primary,
                  //             fontWeight: FontWeight.bold),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (BuildContext context) =>
                  //                 UnderConstraction(
                  //                   title: "Recruitment",
                  //                 )));
                  //   },
                  //   child: Container(
                  //     height: 140,
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(left: 32, right: 32),
                  //       child: _loadingAndCachingWidget(
                  //         "http://www.visionaires.co/wp-content/uploads/2019/09/Looking-for-your-next-career-move-1024x576.png",
                  //         fit: BoxFit.cover,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: <Widget>[
                  //       Container(
                  //         height: 128,
                  //         width: MediaQuery.of(context).size.width / 2.5,
                  //         child: _loadingAndCachingWidget(
                  //             "https://www.recruitbpm.com/wp-content/uploads/2017/05/recruitment-management.jpg",
                  //             fit: BoxFit.fill),
                  //       ),
                  //       Spacer(),
                  //       Container(
                  //         height: 128,
                  //         width: MediaQuery.of(context).size.width / 2.5,
                  //         child: _loadingAndCachingWidget(
                  //             "https://mbs.com.eg/wp-content/uploads/2019/09/metro-ex.jpg",
                  //             fit: BoxFit.fill),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Row(
                  //   children: <Widget>[
                  //     Padding(
                  //       padding: const EdgeInsets.all(24.0),
                  //       child: Text(
                  //         allTranslations.text("Medical"),
                  //         style: TextStyle(
                  //             color: DataProvider().primary,
                  //             fontWeight: FontWeight.bold),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // InkWell(
                  //   onTap: () {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (BuildContext context) =>
                  //                 UnderConstraction(
                  //                   title: "Medical",
                  //                 )));
                  //   },
                  //   child: Container(
                  //     height: 140,
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(left: 32, right: 32),
                  //       child: _loadingAndCachingWidget(
                  //         "http://www.watersportsinfuengirola.com/wp-content/uploads/2019/07/medical-banner2.jpg",
                  //         fit: BoxFit.cover,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(left: 32, right: 32, bottom: 32),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: <Widget>[
                  //       Container(
                  //         height: 128,
                  //         width: MediaQuery.of(context).size.width / 2.5,
                  //         child: _loadingAndCachingWidget(
                  //             "https://cached.imagescaler.hbpl.co.uk/resize/scaleWidth/620/cached.offlinehbpl.hbpl.co.uk/news/2MM/GettyImages-1135377656_1240x776px-20191003035656667.jpg",
                  //             fit: BoxFit.fill),
                  //       ),
                  //       Spacer(),
                  //       Container(
                  //           height: 128,
                  //           width: MediaQuery.of(context).size.width / 2.5,
                  //           child: _loadingAndCachingWidget(
                  //               "https://i.pinimg.com/originals/02/2e/96/022e9691c5ba65d23cbf27a53f83163e.jpg")),
                  //     ],
                  //   ),
                  // ),
                
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadingAndCachingWidget(String image, {BoxFit fit = BoxFit.fill}) {
    return FutureBuilder(
      future: precacheImage(NetworkImage(image), context),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey,
          );
        }
        return Image.network(image,gaplessPlayback: true,fit: fit, );
        return Container(
          decoration: BoxDecoration(
              image: DecorationImage(image: NetworkImage(image), fit: fit)),
        );
      },
    );
  }
}
