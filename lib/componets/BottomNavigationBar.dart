import 'package:big/Providers/DataProvider.dart';
import 'package:big/Screens/Mall/mall.dart';
import 'package:big/Screens/Profile.dart';
import 'package:big/Screens/Settings/settings.dart';
import 'package:big/Screens/Uber/UberHomeScreen.dart';
import 'package:big/Screens/emptyOrder.dart';
import 'package:big/Screens/login.dart';
import 'package:big/Screens/mazad/MazadHome.dart';
import 'package:big/Screens/wuzzef/signup/career.dart';
import 'package:big/componets/platform_icons.dart';
import 'package:big/componets/shopping_icons.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:big/Screens/UnderConstraction.dart';
import 'drawer_icons_icons.dart';
import 'package:big/Screens/OnlineStoreHomeScreen.dart';

class CustomNavigationBar extends StatefulWidget {
  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Container(
        color: Colors.white,
        height: 56,
        child: Row(
          children: [
            Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Icon(
                    DrawerIcons.home,
                    color: currentIndex==0 ?DataProvider().primary:Colors.black,
                  ),
                  Text(
                    allTranslations.text("home"),
                    style: TextStyle(color:currentIndex==0 ?DataProvider().primary:Colors.black, fontSize: 12),
                  )
                ])),
            Expanded(
                child: InkWell(
              onTap: () async{
                currentIndex=1;
                setState(() {
                  
                });
              await   showDialog(
                    context: context,
                    builder: (context) {
                      return _PlatformPicker();
                    });
 currentIndex=0;
setState(() {
  
});
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(DrawerIcons.list,color:currentIndex==1 ?DataProvider().primary:Colors.black),
                    Text(
                      allTranslations.text("platform"),
                      style: TextStyle(fontSize: 12,color: currentIndex==1 ?DataProvider().primary:Colors.black),
                    )
                  ]),
            )),
            Expanded(
                child: InkWell(
                    onTap: () {
                   //   Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmptyOrder(title: allTranslations.text("order"),)));
                    },
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(DrawerIcons.order),
                          Text(
                            allTranslations.text("order"),
                            style: TextStyle(fontSize: 12),
                          )
                        ]))),
            Expanded(
                child: InkWell(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                bool isLogin = false;
                if ((prefs.containsKey('userName'))) {
                  isLogin = true;
                }
                if (isLogin) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                } else {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(DrawerIcons.user_1),
                    Text(
                      allTranslations.text("Profile"),
                      style: TextStyle(fontSize: 12),
                    )
                  ]),
            )),
            Expanded(
                child: InkWell(
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                bool isLogin = false;
                if ((prefs.containsKey('userName'))) {
                  isLogin = true;
                }
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Settings(
                              isLogin: isLogin,
                            )));
              },
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(DrawerIcons.settings),
                    Text(
                      allTranslations.text("settings"),
                      style: TextStyle(fontSize: 12),
                    )
                  ]),
            )),
          ],
        ),
      ),
    );
  }
}

class _PlatformPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[


               _item(allTranslations.text("online Shopping"), Shopping.shopping_bag_01, () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OnlineShoppingHome()));
                }),
                _item(allTranslations.text("Auction"), Platform.auction, () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MazadHome()));
                }),
                   Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Malls()));
                  },
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: ShapeDecoration(
                        shadows: [
                          BoxShadow(
                              offset: Offset(3, 3),
                              blurRadius: 6,
                              color: Color(0xff29000000))
                        ],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4)),
                        color: Colors.white),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset(
                          "lib/assets/images/mall.png",
                          height: 24,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          allTranslations.text("malls"),
                          style: TextStyle(fontSize: 10),
                        )
                      ],
                    ),
                  ),
                ),
                // _item(allTranslations.text("Booking"), Platform.calendar, () {
                //   Navigator.pop(context);
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => UnderConstraction(
                //                 title: allTranslations.text("Booking"),
                //               )));
                // }),
                // _item(allTranslations.text("Medical"), Platform.stethoscope,
                //     () {
                //   Navigator.pop(context);
                //   Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //           builder: (context) => UnderConstraction(
                //                 title: allTranslations.text("Medical"),
                //               )));
                // })
              ],
            ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: <Widget>[
            //     _item(allTranslations.text("online Shopping"), Shopping.shopping_bag_01, () {
            //       Navigator.pop(context);
            //       Navigator.push(
            //           context,
            //           MaterialPageRoute(
            //               builder: (context) => OnlineShoppingHome()));
            //     }),
            //     _item(allTranslations.text("Auction"), Platform.auction, () {
            //       Navigator.pop(context);
            //       Navigator.push(context,
            //           MaterialPageRoute(builder: (context) => MazadHome()));
            //     }),
            //        Column(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: <Widget>[
            //     InkWell(
            //       onTap: () {
            //         Navigator.pop(context);
            //         Navigator.push(context,
            //             MaterialPageRoute(builder: (context) => Malls()));
            //       },
            //       child: Container(
            //         width: 70,
            //         height: 70,
            //         decoration: ShapeDecoration(
            //             shadows: [
            //               BoxShadow(
            //                   offset: Offset(3, 3),
            //                   blurRadius: 6,
            //                   color: Color(0xff29000000))
            //             ],
            //             shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(4)),
            //             color: Colors.white),
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: <Widget>[
            //             Image.asset(
            //               "lib/assets/images/mall.png",
            //               height: 24,
            //             ),
            //             SizedBox(
            //               height: 5,
            //             ),
            //             Text(
            //               allTranslations.text("malls"),
            //               style: TextStyle(fontSize: 10),
            //             )
            //           ],
            //         ),
            //       ),
            //     ),
            //     // _item(allTranslations.text("Booking"), Platform.calendar, () {
            //     //   Navigator.pop(context);
            //     //   Navigator.push(
            //     //       context,
            //     //       MaterialPageRoute(
            //     //           builder: (context) => UnderConstraction(
            //     //                 title: allTranslations.text("Booking"),
            //     //               )));
            //     // }),
            //     // _item(allTranslations.text("Medical"), Platform.stethoscope,
            //     //     () {
            //     //   Navigator.pop(context);
            //     //   Navigator.push(
            //     //       context,
            //     //       MaterialPageRoute(
            //     //           builder: (context) => UnderConstraction(
            //     //                 title: allTranslations.text("Medical"),
            //     //               )));
            //     // })
            //   ],
            // ),
         
            //     // _item(allTranslations.text("Car Services"), Platform.around, () {
            //     //   Navigator.pop(context);
            //     //   Navigator.push(
            //     //       context,
            //     //       MaterialPageRoute(
            //     //           builder: (context) => UberHomeScreen()));
            //     // })
            //   ],
            // ),
            // // Column(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: <Widget>[
            //     Spacer(),
            //   //   _item(allTranslations.text("Recruitment"), Platform.job_seeker,
            //   //       () {
            //   //     Navigator.pop(context);
            //   //  //   Navigator.push(context, MaterialPageRoute(builder: (context) => Career()));
            //   //     Navigator.push(context, MaterialPageRoute(builder: (context) => UnderConstraction(
            //   //       title: allTranslations.text("Recruitment"),)));
            //   //   }),
            //     Spacer(),
            //     // _item(allTranslations.text("Delivery"), Platform.delivery_truck,
            //     //     () {
            //     //   Navigator.pop(context);
            //     //   Navigator.push(
            //     //       context,
            //     //       MaterialPageRoute(
            //     //           builder: (context) => UnderConstraction(
            //     //                 title: allTranslations.text("Delivery"),
            //     //               )));
            //     // }),
            //     Spacer(),
            //   ],
            // ),
         
          ],
        ),
      ),
    );
  }

  _item(String title, IconData icon, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 70,
        decoration: ShapeDecoration(
            shadows: [
              BoxShadow(
                  offset: Offset(3, 3),
                  blurRadius: 6,
                  color: Color(0xff29000000))
            ],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon),
            SizedBox(
              height: 5,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 10),textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
