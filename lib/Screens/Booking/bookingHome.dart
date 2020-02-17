import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/booking/bookingProvider.dart';
import 'package:big/Screens/Booking/EmptyScreen.dart';
import 'package:big/componets/MainDrawer.dart';
import 'package:big/componets/searchWidget.dart';
import 'package:big/localization/all_translations.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookingHome extends StatefulWidget {
  @override
  _BookingHomeState createState() => _BookingHomeState();
}

class _BookingHomeState extends State<BookingHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<IconData> deleteMeIcon = [
    Icons.directions_car,
    Icons.account_balance,
    Icons.airplanemode_active,
    Icons.accessibility,
    Icons.flare
  ];
  List<String> deleteMe = ["Car", "Hotel", "Planes", "Events", "Bike"];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => BookingProvider(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              icon: new Icon(Icons.menu, color: DataProvider().primary),
              onPressed: () => _scaffoldKey.currentState.openDrawer()),
          backgroundColor: Colors.white,
          elevation: 0,
          titleSpacing: 50,
          title: new Text(
            allTranslations.text("Booking"),
            style: TextStyle(color: DataProvider().primary),
          ),
        ),
        key: _scaffoldKey,
        drawer: mainDrawer(context, "booking"),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 1,
            ),
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
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.search,
                          color: DataProvider().primary,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          allTranslations.text("search"),
                          style: TextStyle(color: DataProvider().primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView(
                scrollDirection: Axis.vertical,
                children: <Widget>[
                  buildSlider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      allTranslations.text("Categories"),
                      style: TextStyle(
                          color: DataProvider().primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                        itemCount: deleteMe.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 80,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2.0,
                                  )
                                ],
                                gradient: LinearGradient(
                                    begin: AlignmentDirectional.topStart,
                                    end: AlignmentDirectional.bottomEnd,
                                    colors: [
                                      Color(0xFFffffff),
                                      Color(0xFFffffff)
                                    ]),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Icon(deleteMeIcon[index]),
                                    Text(deleteMe[index]),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      allTranslations.text("Deals of the day"),
                      style: TextStyle(
                          color: DataProvider().primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 210,
                          width: MediaQuery.of(context).size.width / 2.2,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Material(
                                  child: InkWell(
                                    child: Builder(
                                      builder: (context, ) {
                                        bool hasError=false;
                                        return FutureBuilder(
                                      
                                            future: precacheImage(
                                            
                                                NetworkImage(
                                                    "https://k6u8v6y8.stackpathcdn.com/blog/wp-content/uploads/2014/05/Luxury-Hotels-in-India.jpg"),
                                                context,
                                              onError: (_,__){
                                              },
                                                ),
                                            builder: (context, snapshot) {
                                              if(snapshot.connectionState!=ConnectionState.done){
                                                return Container(height: MediaQuery.of(context).size.height *0.2,color: Colors.grey,);
                                              }
                                              return FadeInImage(
                                                placeholder: AssetImage(
                                                    "lib/assets/images/errorImage.png"),
                                                image: NetworkImage(
                                                    "https://k6u8v6y8.stackpathcdn.com/blog/wp-content/uploads/2014/05/Luxury-Hotels-in-India.jpg"),
                                                fit: BoxFit.cover,
                                        
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                              );
                                            });
                                      }
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  EmptyScreen()));
                                    },
                                  ),
                                ),
                                Divider(),
                                Wrap(children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Kingsgate Hotel",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.clip,
                                    ),
                                  )
                                ]),
                                Wrap(children: <Widget>[
                                  Text(
                                    " 350 USD  ",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '700 USD',
                                    style: TextStyle(
                                        fontSize: 10,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 210,
                          width: MediaQuery.of(context).size.width / 2.2,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    Transform.translate(
                                      offset: Offset(50.0, -2.0),
                                      child: Container(
                                        width: 45.0,
                                        height: 20.0,
                                        color: Color(0XFFff2b2b),
                                        child: Text(
                                          allTranslations.text("New"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Material(
                                  child: InkWell(
                                    child: FadeInImage(
                                      placeholder: AssetImage(
                                          "lib/assets/images/errorImage.png"),
                                      image: NetworkImage(
                                          "https://www.al-madina.com/uploads/images/2019/04/12/1591449.jpg"),
                                      fit: BoxFit.cover,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                    ),
                                    onTap: () {},
                                  ),
                                ),
                                Divider(),
                                Wrap(children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "SAUDIA",
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.clip,
                                      maxLines: 4,
                                    ),
                                  )
                                ]),
                                Wrap(children: <Widget>[
                                  Text(
                                    " 3500 USD  ",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '7000 USD',
                                    style: TextStyle(
                                        fontSize: 10,
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FadeInImage(
                    placeholder: AssetImage("lib/assets/images/errorImage.png"),
                    image: NetworkImage(
                        "https://www.hotelroyalblue.com/wp-content/uploads/2018/07/royalblue_slider_04-1500x630.jpg"),
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      allTranslations.text("Popular destinations"),
                      style: TextStyle(
                          color: DataProvider().primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                        itemCount: 6,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 130,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2.0,
                                  )
                                ],
                                gradient: LinearGradient(
                                    begin: AlignmentDirectional.topStart,
                                    end: AlignmentDirectional.bottomEnd,
                                    colors: [
                                      Color(0xFFffffff),
                                      Color(0xFFffffff)
                                    ]),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  ClipRect(
                                      child: FadeInImage(
                                    placeholder: AssetImage(
                                        "lib/assets/images/errorImage.png"),
                                    image: NetworkImage(
                                        "https://www.fodors.com/wp-content/uploads/2019/10/TopSightsOfEgypt__HERO_iStock-1023629520.jpg"),
                                  )),
                                  Text(
                                    "Aswan",
                                    textAlign: TextAlign.start,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text("Egypt"),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width / 2.1,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://2486634c787a971a3554-d983ce57e4c84901daded0f67d5a004f.ssl.cf1.rackcdn.com/_wyndham-dolce/media/dolce-alexander-home-reasons-to-stay-center-indianapolis-culture-5c81368d042fc.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width / 2.1,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgAEDj3qpFI3frMUy4adAbwvGB3ZGL5S4CeP7a1YzB5l2PZQzY&s"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      allTranslations.text("Recommended FOR YOU"),
                      style: TextStyle(
                          color: DataProvider().primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                        itemCount: 6,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 130,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2.0,
                                  )
                                ],
                                gradient: LinearGradient(
                                    begin: AlignmentDirectional.topStart,
                                    end: AlignmentDirectional.bottomEnd,
                                    colors: [
                                      Color(0xFFffffff),
                                      Color(0xFFffffff)
                                    ]),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  FadeInImage(
                                    placeholder: AssetImage(
                                        "lib/assets/images/errorImage.png"),
                                    image: NetworkImage(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcTZv1K7qHQKr2pnlaJVhwIA8q7Xph0HUwPEBf_oCMFpll9FSOVl"),
                                  ),
                                  Text(
                                    " Chevrolet Spark",
                                    textAlign: TextAlign.start,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text(" 350 USD"),
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox buildSlider() {
    return SizedBox(
        height: 170.0,
        width: MediaQuery.of(context).size.width / 1.1,
        child: Carousel(
          images: [
            NetworkImage(
                'https://www.corinthia.com/application/files/6315/0460/7084/corinthia-hotel-tripoli-lobby.jpg'),
            NetworkImage(
                'https://assets.tivolihotels.com/image/upload/q_auto,f_auto/media/minor/tivoli/images/brand_level/footer/1920x1000/thr_aboutus1_1920x1000.jpg'),
            NetworkImage(
                "https://k6u8v6y8.stackpathcdn.com/blog/wp-content/uploads/2014/05/Luxury-Hotels-in-India.jpg")
          ],
          boxFit: BoxFit.contain,
          autoplay: false,
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: Duration(milliseconds: 1000),
          dotSize: 3.0,
          dotIncreasedColor: DataProvider().primary,
          dotBgColor: Colors.transparent,
          dotPosition: DotPosition.bottomCenter,
          dotVerticalPadding: 10.0,
          showIndicator: true,
        ));
  }
}
