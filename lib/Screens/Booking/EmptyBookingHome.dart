import 'package:big/Providers/DataProvider.dart';
import 'package:big/Screens/stores/mainStores.dart';
import 'package:big/Screens/stores/storeDetails.dart';
import 'package:big/componets/MainDrawer.dart';
import 'package:big/componets/searchWidget.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';

class EmptyBookingHome extends StatefulWidget {
  @override
  _EmptyBookingHomeState createState() => _EmptyBookingHomeState();
}

class _EmptyBookingHomeState extends State<EmptyBookingHome> {
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: new Icon(Icons.menu, color: DataProvider().primary),
            onPressed: () => _scaffoldKey.currentState.openDrawer()),
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 50,
        title: new Text(
          allTranslations.text("booking"),
          style: TextStyle(color: DataProvider().secondry),
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
              children: <Widget>[
                FutureBuilder(
                    future: precacheImage(
                        NetworkImage(
                            "https://k6u8v6y8.stackpathcdn.com/blog/wp-content/uploads/2014/05/Luxury-Hotels-in-India.jpg"),
                        context),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState!=ConnectionState.done){
                        
                        return Container(width: double.infinity,height: 200,color: Colors.grey);
                      
                        
                      }
                      return FadeInImage(
                          placeholder:
                              AssetImage("lib/assets/images/errorImage.png"),
                          image: NetworkImage("https://k6u8v6y8.stackpathcdn.com/blog/wp-content/uploads/2014/05/Luxury-Hotels-in-India.jpg"));
                    }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    allTranslations.text("Categories"),
                    style: TextStyle(
                        color: DataProvider().secondry,
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
                                  end: Alignment.bottomRight,
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
                        color: DataProvider().secondry,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(child: Image.asset("lib/assets/images/broken_heart.png",width: 100,height: 100,color: Colors.black,),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => MainStores()));
                      },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          allTranslations
                              .text("Sorry we couldn't find any matches for you"),
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
