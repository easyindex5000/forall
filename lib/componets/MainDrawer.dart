import 'package:big/Providers/AuthProvider.dart';
import 'package:big/Providers/DataProvider.dart';
import 'package:big/Screens/Booking/EmptyBookingHome.dart';
import 'package:big/Screens/ForAllHome.dart';
import 'package:big/Screens/Golovo/GolovoHome.dart';
import 'package:big/Screens/Mall/mall.dart';
import 'package:big/Screens/OnlineStoreHomeScreen.dart';
import 'package:big/Screens/Profile.dart';
import 'package:big/Screens/Settings/settings.dart';
import 'package:big/Screens/Uber/UberHomeScreen.dart';
import 'package:big/Screens/UnderConstraction.dart';
import 'package:big/Screens/login.dart';
import 'package:big/Screens/mazad/MazadHome.dart';
import 'package:big/Screens/my_orders.dart';
import 'package:big/Screens/whishlist.dart';
import 'package:big/componets/Error.dart';
import 'package:big/componets/drawer_icons_icons.dart';
import 'package:big/componets/platform_icons.dart';
import 'package:big/componets/shopping_icons.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool isLogin;
var userName;
var userEmail;
var userImage;
String dropdownValue = "English";

Future getData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if ((prefs.containsKey('userName') && prefs.containsKey('userEmail'))) {
    userName = prefs.getString('userName');
    userEmail = prefs.getString('userEmail');
    if (prefs.containsKey('userImage')) {
      userImage = prefs.getString('userImage');
    }
    isLogin = true;
  } else {
    isLogin = false;
  }
}

init() async {
  await getData();
}

Widget mainDrawer(BuildContext context, String title) {

  return FutureBuilder(
      future: init(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CustomErrorWidget();
        }
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.6,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (isLogin)
                            Builder(
                              builder: (_) {
                                bool hasError = false;
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Profile()));
                                  },
                                  child: FutureBuilder(
                                    future: precacheImage(
                                        NetworkImage(userImage), context,
                                        onError: (_, __) {
                                      hasError = true;
                                    }),
                                    builder: (_, snapshot) {
                                      if (snapshot.connectionState !=
                                          ConnectionState.done) {
                                        return CircleAvatar(
                                          backgroundColor: Colors.grey,
                                          radius: 50,
                                        );
                                      }
                                      if (!hasError &&
                                          snapshot.connectionState ==
                                              ConnectionState.done) {
                                        return CircleAvatar(
                                            backgroundColor: Colors.white,
                                            radius: 50,
                                            backgroundImage:
                                                NetworkImage(userImage));
                                      }
                                      return CircleAvatar(
                                          backgroundColor: Colors.white,
                                          radius: 50,
                                          backgroundImage: AssetImage(
                                              "lib/assets/images/errorImage.png"));
                                    },
                                  ),
                                );
                              },
                            )
                          else
                            CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    AssetImage("lib/assets/images/user.png")),
                          SizedBox(
                            height: 10,
                          ),
                          if (isLogin)
                            InkWell(
                              child: Text(
                                userName,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                Navigator.pop(context);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Profile()));
                              },
                            )
                          else
                            InkWell(
                              child: Text(
                                allTranslations.text("Login"),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                Navigator.pop(context);

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              },
                            ),
                        ],
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Row(children: <Widget>[
                      //     Padding(
                      //       padding: const EdgeInsets.all(8.0),
                      //       child: Icon(
                      //         Icons.language,
                      //         color: Colors.black,
                      //       ),
                      //     ),
                      //     Consumer<LanguageProvider>(builder: (context, snapshot, _) {
                      //       return DropdownButtonHideUnderline(
                      //         child: DropdownButton<String>(
                      //           value: dropdownValue,
                      //           onChanged: (String language) async {
                      //             if (language == 'عربي') {
                      //               await allTranslations.setNewLanguage("ar");
                      //             } else if (language == 'Française') {
                      //               await allTranslations.setNewLanguage("fr");
                      //             } else if (language == 'русский') {
                      //               await allTranslations.setNewLanguage("ru");
                      //             } else if (language == 'Türk') {
                      //               await allTranslations.setNewLanguage("tr");
                      //             } else if (language == 'italiana') {
                      //               await allTranslations.setNewLanguage("it");
                      //             } else if (language == 'Deutsch') {
                      //               await allTranslations.setNewLanguage("de");
                      //             } else if (language == '中文') {
                      //               await allTranslations.setNewLanguage("zh");
                      //             } else {
                      //               await allTranslations.setNewLanguage("en");
                      //             }
                      //             SharedPreferences prefs =
                      //                 await SharedPreferences.getInstance();
                      //             await prefs.setString('language', language);
                      //             setState(() {});
                      //             snapshot.setLang(language);
                      //             dropdownValue = language;
                      //           },
                      //           items: <String>[
                      //             'English',
                      //             'عربي',
                      //             'Française',
                      //             'русский',
                      //             'Türk',
                      //             'italiana',
                      //             'Deutsch',
                      //             '中文'
                      //           ].map<DropdownMenuItem<String>>((String value) {
                      //             return DropdownMenuItem<String>(
                      //               value: value,
                      //               child: Text(value),
                      //             );
                      //           }).toList(),
                      //         ),
                      //       );
                      //     }),
                      //   ]),
                      // ),

                      // Divider(),
                      if (!isLogin)
                        DrawerlistTile(DrawerIcons.user_1,
                            allTranslations.text("Profile"), false, () {
                          if (isLogin) {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile()));
                          } else {
                            Navigator.pop(context);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                          }
                        }),
                      if (!isLogin)
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 40,
                            ),
                            Expanded(
                                child: Divider(
                              color: Colors.black,
                            ))
                          ],
                        ),
                      if (title != "home")
                        DrawerlistTile(DrawerIcons.home,
                            allTranslations.text("Home Page"), false, () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => OnlineShoppingHome()),
                              (_) => false);
                        }),
                      if (title != "home")
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 40,
                            ),
                            Expanded(
                                child: Divider(
                              color: Colors.black,
                            ))
                          ],
                        ),

                      DrawerlistTile(Icons.favorite_border,
                          allTranslations.text("wishlist"), false, () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Wishlist()));
                      }),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 40,
                          ),
                          Expanded(
                              child: Divider(
                            color: Colors.black,
                          ))
                        ],
                      ),
                      if (isLogin)
                        DrawerlistTile(DrawerIcons.order,
                            allTranslations.text("my_order"), false, () {
                                                     Navigator.pop(context);

                                // if (title == "home") {
                                //   Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) =>
                                //               UnderConstraction(title: allTranslations.text("order"),)));
                               
                                // } else {
                                //   Navigator.pushReplacement(
                                //       context,
                                //       MaterialPageRoute(
                                //           builder: (context) =>
                                //               UnderConstraction(title: allTranslations.text("order"),)));
                          
                                // }


                          // Navigator.pop(context);
                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (_) => MyOrder()));
                        }),
                      if (isLogin)
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 40,
                            ),
                            Expanded(
                                child: Divider(
                              color: Colors.black,
                            ))
                          ],
                        ),

                      ExpansionTile(
                        leading: Icon(
                          DrawerIcons.list,
                          color: Colors.black,
                        ),
                        title: Text(allTranslations.text("categories")),
                        children: <Widget>[
                           if (title != "online Shopping")
                            Row(children: <Widget>[
                              SizedBox(
                                width: 32,
                              ),
                              Expanded(
                                  child: DrawerlistTile(
                                      DrawerIcons.calendar,
                                      allTranslations.text("online Shopping"),
                                      false, () {
                                    Navigator.pop(context);

                                    if (title == "home") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OnlineShoppingHome()));

                                    } else {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OnlineShoppingHome()));

                                    }
                                  }))
                            ],
                            ),
                          if (title != "mazadHome")
                            Row(
                              children: <Widget>[
                                SizedBox(
                                  width: 32,
                                ),
                                Expanded(
                                  child: DrawerlistTile(
                                      DrawerIcons.auction,
                                      allTranslations.text("Auction"),
                                      false, () {
                                    Navigator.pop(context);

                                    if (title == "home") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MazadHome()));
                                    } else {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MazadHome()));
                                    }
                                  }),
                                ),
                              ],
                            ),
                                                     Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 32,
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: InkWell(
                                    onTap: () {
                                       Navigator.pop(context);

                                    if (title == "home") {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Malls()));
                                    } else {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Malls()));
                                    }
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Image.asset(
                                          "lib/assets/images/mall.png",
                                          width: 24,
                                          height: 24,
                                          fit: BoxFit.fill,
                                        ),
                                        SizedBox(width: 8),
                                        Text(allTranslations.text("Malls")),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

//                           if (title != "booking")
//                             Row(children: <Widget>[
//                               SizedBox(
//                                 width: 32,
//                               ),
//                               Expanded(
//                                   child: DrawerlistTile(
//                                       DrawerIcons.calendar,
//                                       allTranslations.text("Booking"),
//                                       false, () {
//                                 Navigator.pop(context);

//                                 if (title == "home") {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               UnderConstraction(title: allTranslations.text("booking"),)));
                               
//                                 } else {
//                                   Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               UnderConstraction(title: allTranslations.text("booking"),)));
                          
//                                 }
//                               }))
//                             ],
//                             ),
//                           if (title != "Medical")
//                             Row(children: <Widget>[
//                               SizedBox(
//                                 width: 32,
//                               ),
//                               Expanded(
//                                   child: DrawerlistTile(
//                                       Platform.stethoscope,
//                                       allTranslations.text("Medical"),
//                                       false, () {
//                                     Navigator.pop(context);

//                                     if (title == "home") {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   UnderConstraction(title: allTranslations.text("Medical"),)));

//                                     } else {
//                                       Navigator.pushReplacement(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   UnderConstraction(title: allTranslations.text("Medical"),)));

//                                     }
//                                   }))
//                             ],
//                             ),
//                           if (title != "Recruitment")
//                             Row(children: <Widget>[
//                               SizedBox(
//                                 width: 32,
//                               ),
//                               Expanded(
//                                   child: DrawerlistTile(
//                                       Platform.job_seeker,
//                                       allTranslations.text("Recruitment"),
//                                       false, () {
//                                     Navigator.pop(context);

//                                     if (title == "home") {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   UnderConstraction(title: allTranslations.text("Recruitment"),)));

//                                     } else {
//                                       Navigator.pushReplacement(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   UnderConstraction(title: allTranslations.text("Recruitment"),)));

//                                     }
//                                   }))
//                             ],
//                             ),
                         
//                           if (title != "Golovo")
//                             Row(children: <Widget>[
//                               SizedBox(
//                                 width: 32,
//                               ),
//                               Expanded(
//                                   child: DrawerlistTile(
//                                       DrawerIcons.delivery_truck,
//                                       allTranslations.text("Delivery"),
//                                       false, () {
//                                 Navigator.pop(context);

//                                 if (title == "home") {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               UnderConstraction(title: allTranslations.text("Delivery"),)));
//                                   // Navigator.push(
//                                   //     context,
//                                   //     MaterialPageRoute(
//                                   //         builder: (context) => GolovoHome()));
//                                 } else {
//                                           Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               UnderConstraction(title: allTranslations.text("Delivery"),)));
                               
//                                   // Navigator.pushReplacement(
//                                   //     context,
//                                   //     MaterialPageRoute(
//                                   //         builder: (context) => GolovoHome()));
//                                 }
//                               }))
//                             ]),
//                                                       if (title != "uber")

//                             Row(children: <Widget>[
//                               SizedBox(width: 32,),      Expanded(
//                                 child: DrawerlistTile(
//                                     DrawerIcons.car_1,
//                                     allTranslations.text("Car Services"),
//                                     false, () {
//                                   Navigator.pop(context);

//                                   if (title == "home") {
// //                                             Navigator.push(
// //                                      context,
// //                                      MaterialPageRoute(
// //                                          builder: (context) =>
// //                                              UnderConstraction(title: allTranslations.text("Car Services"),)));
//                                      Navigator.push(
//                                          context,
//                                          MaterialPageRoute(
//                                              builder: (context) =>
//                                                  UberHomeScreen()));
//                                   } else {
// //                                     Navigator.pushReplacement(
// //                                      context,
// //                                      MaterialPageRoute(
// //                                          builder: (context) =>
// //                                              UnderConstraction(title: allTranslations.text("Car Services"),)));
//                                      Navigator.pushReplacement(
//                                          context,
//                                          MaterialPageRoute(
//                                              builder: (context) =>
//                                                  UberHomeScreen()));
//                                   }
//                                 }),
//                               ),
//                             ],),
                          // if (title != "home")
                          //   Row(
                          //     children: <Widget>[
                          //       SizedBox(
                          //         width: 32,
                          //       ),
                          //       Expanded(
                          //         child: DrawerlistTile(
                          //             Shopping.shopping_bag_01,
                          //             allTranslations.text("online Shopping"),
                          //             false, () {
                          //           Navigator.pop(context);

                          //           if (title == "home") {
                          //             Navigator.push(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                     builder: (context) =>
                          //                         OnlineShoppingHome()));
                          //           } else {
                          //             Navigator.pushReplacement(
                          //                 context,
                          //                 MaterialPageRoute(
                          //                     builder: (context) =>
                          //                         OnlineShoppingHome()));
                          //           }
                          //         }),
                          //       ),
                          //     ],
                          //   ),
                       
 
//                          DrawerlistTile(Icons.airport_shuttle, "Booking", () {
//                            Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) => Dialogbox()));
//                          }),
//                          DrawerlistTile(Icons.local_car_wash, "Golovo", () {
//                            Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) => GolovoHome()));
//                          }),
//                          DrawerlistTile(Icons.transfer_within_a_station, "tawzef", () {
//                            Navigator.push(context, MaterialPageRoute(builder: (context) => GolovoHome()));
//                          }),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 40,
                          ),
                          Expanded(
                              child: Divider(
                            color: Colors.black,
                          ))
                        ],
                      ),

                      DrawerlistTile(DrawerIcons.settings,
                          allTranslations.text("Settings"), false, () {
                        Navigator.pop(context);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Settings(
                                      isLogin: isLogin,
                                    )));
                      }),

                      // DrawerlistTile(
                      //     Icons.local_shipping, allTranslations.text("delivery"), () {
                      //   Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //           builder: (context) => ShippingIstructions()));
                      // }),
                      // DrawerlistTile(Icons.local_mall, allTranslations.text("terms"),
                      //     () {
                      //   Navigator.push(context,
                      //       MaterialPageRoute(builder: (context) => Terms()));
                      // }),
                      // DrawerlistTile(Icons.help, allTranslations.text("faq"), () {
                      //   Navigator.push(
                      //       context, MaterialPageRoute(builder: (context) => FAQ()));
                      // }),
                      // DrawerlistTile(Icons.phone, allTranslations.text("contact_us"),
                      //     () {
                      //   Navigator.push(context,
                      //       MaterialPageRoute(builder: (context) => ContactUs()));
                      // }),
                    ],
                  ),
                ),
                if (isLogin)
                  Container(
                    padding: EdgeInsets.all(16),
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border(
                      top: BorderSide(color: Colors.black54),
                    )),
                    child: InkWell(
                      onTap: () async {
                        await ShowAlertDailog(context);
                        setState(() {});
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.exit_to_app,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Flexible(
                            child: Text(
                              allTranslations.text("Logout"),
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          );
        });
      });
}

Future<void> ShowAlertDailog(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(15.0)),
        title: Text(allTranslations.text("Are you Sure ?")),
        actions: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Text(
                    allTranslations.text("Logout"),
                    style: TextStyle(color: Colors.white),
                  ),
                  color: DataProvider().primary,
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    isLogin = false;
                    String language = await prefs.getString('language');
                    prefs.clear();
                    prefs.setString('language', language);
                    AuthProvider().googleLogout();
                    AuthProvider().logoutFace();
                    await Navigator.of(context).pop();
                  },
                ),
              ),
              RaisedButton(
                child: Text(
                  allTranslations.text("Cancel"),
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

class DrawerlistTile extends StatelessWidget {
  IconData draweIcon;
  String drawerItem;
  bool hasDivider;
  Function drawerOnTap;
  DrawerlistTile(
      this.draweIcon, this.drawerItem, this.hasDivider, this.drawerOnTap);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: InkWell(
        onTap: drawerOnTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                Icon(
                  draweIcon,
                ),
                if (hasDivider)
                  Divider(
                    color: Colors.transparent,
                  )
              ],
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(drawerItem),
                  if (hasDivider)
                    Divider(
                      color: Colors.black,
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//test

const Duration _kExpand = Duration(milliseconds: 200);

class ExpansionTile extends StatefulWidget {
  const ExpansionTile({
    Key key,
    this.leading,
    @required this.title,
    this.backgroundColor,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.initiallyExpanded = false,
  })  : assert(initiallyExpanded != null),
        super(key: key);

  /// A widget to display before the title.
  ///
  /// Typically a [CircleAvatar] widget.
  final Widget leading;

  /// The primary content of the list item.
  ///
  /// Typically a [Text] widget.
  final Widget title;

  /// Called when the tile expands or collapses.
  ///
  /// When the tile starts expanding, this function is called with the value
  /// true. When the tile starts collapsing, this function is called with
  /// the value false.
  final ValueChanged<bool> onExpansionChanged;

  /// The widgets that are displayed when the tile expands.
  ///
  /// Typically [ListTile] widgets.
  final List<Widget> children;

  /// The color to display behind the sublist when expanded.
  final Color backgroundColor;

  /// A widget to display instead of a rotating arrow icon.
  final Widget trailing;

  /// Specifies if the list tile is initially expanded (true) or collapsed (false, the default).
  final bool initiallyExpanded;

  @override
  _ExpansionTileState createState() => _ExpansionTileState();
}

class _ExpansionTileState extends State<ExpansionTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  AnimationController _controller;
  Animation<double> _iconTurns;
  Animation<double> _heightFactor;
  Animation<Color> _borderColor;
  Animation<Color> _headerColor;
  Animation<Color> _iconColor;
  Animation<Color> _backgroundColor;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded =
        PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse().then<void>((void value) {
          if (!mounted) return;
          setState(() {
            // Rebuild without widget.children.
          });
        });
      }
      PageStorage.of(context)?.writeState(context, _isExpanded);
    });
    if (widget.onExpansionChanged != null)
      widget.onExpansionChanged(_isExpanded);
  }

  Widget _buildChildren(BuildContext context, Widget child) {
    final Color borderSideColor = _borderColor.value ?? Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        color: _backgroundColor.value ?? Colors.transparent,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTileTheme.merge(
              iconColor: _iconColor.value,
              textColor: _headerColor.value,
              child: Container(
                padding: EdgeInsets.all(10),
                child: InkWell(
                  onTap: _handleTap,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(DrawerIcons.list, color: Colors.black,size: 15,),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(allTranslations.text("categories")),
                      ),
                      Icon(!_isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up)
                    ],
                  ),
                ),
              )),
          ClipRect(
            child: Align(
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _borderColorTween..end = theme.dividerColor;
    _headerColorTween
      ..begin = theme.textTheme.subhead.color
      ..end = theme.accentColor;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = theme.accentColor;
    _backgroundColorTween..end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children),
    );
  }
}
