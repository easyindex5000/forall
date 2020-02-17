import 'dart:async';
import 'dart:ui';

import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/Uber/UberProvider.dart';
import 'package:big/Screens/Uber/SearchScreen.dart';
import 'package:big/componets/Error.dart';
import 'package:big/componets/MainDrawer.dart';
import 'package:big/componets/shopping_icons.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:provider/provider.dart';
import 'package:async/async.dart';
import 'package:toast/toast.dart';
import 'package:big/componets/uber_types_icons.dart';
import 'dart:io' show Platform;

class UberHomeScreen extends StatefulWidget {
  @override
  _UberHomeScreenState createState() => _UberHomeScreenState();
}

class _UberHomeScreenState extends State<UberHomeScreen> {
  final AsyncMemoizer<LatLng> _memoizer = AsyncMemoizer();

  _checkForGps() async {
    if(Platform.isAndroid){
 const platform = const MethodChannel('samples.flutter.dev/gps');
    try {
      final result = await platform.invokeMethod('getLocation');
      Toast.show("UnderConstraction", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

    } on PlatformException catch (e) {}
    }
   
    return true;
  }

  @override
  void dispose() {
    const platform = const MethodChannel('samples.flutter.dev/gps');
    platform.invokeMethod('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MapProvider>(
      create: (_) {
        return MapProvider();
      },
      child: Builder(builder: (
        context,
      ) {
        return WillPopScope(
          onWillPop: () {
            return Provider.of<MapProvider>(context).onBackPressed(context);
          },
          child: FutureBuilder(
              future: _checkForGps(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return FutureBuilder<LatLng>(
                    future: _memoizer.runOnce(() async {
                  return await Provider.of<MapProvider>(context)
                      .getMyLocation();
                }), builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return CustomErrorWidget();
                  }
                  if (snapshot.hasData) {
                    return Scaffold(
                      drawer: mainDrawer(context, "uber"),
                      backgroundColor: Colors.transparent,
                      body: Builder(builder: (context) {
                        return Stack(
                          children: <Widget>[
                            Builder(builder: (context) {
                              return GoogleMap(
                                compassEnabled: false,
                                onTap: (_) {
                                  if (Provider.of<MapProvider>(context).state ==
                                      AppState.estimate) {
                                    Provider.of<MapProvider>(context)
                                        .onBackPressed(context);
                                  }
                                },
                                onCameraMoveStarted: () {
                                  if (Provider.of<MapProvider>(context).state ==
                                      AppState.estimate) {
                                    Provider.of<MapProvider>(context)
                                        .onBackPressed(context);
                                  }
                                },
                                polylines:
                                    Provider.of<MapProvider>(context).polyLines,
                                markers:
                                    Provider.of<MapProvider>(context).markers,
                                myLocationEnabled: true,
                                myLocationButtonEnabled: false,
                                onCameraMove: (cameraPosition) =>
                                    Provider.of<MapProvider>(context)
                                        .onCameraMove(cameraPosition),
                                initialCameraPosition: CameraPosition(
                                    zoom: 15,
                                    target: LatLng(snapshot.data.latitude,
                                        snapshot.data.longitude)),
                                onMapCreated: (controller) {
                                  Provider.of<MapProvider>(context)
                                      .mapController = controller;
                                },
                              );
                            }),
                            _drawerIcon(context),
                            _topbar(context),
                            if (Provider.of<MapProvider>(context).state ==
                                    AppState.select_car ||
                                Provider.of<MapProvider>(context).state ==
                                    AppState.select_pickUp)
                              _carType(context),
                            _bottemCenter(context),
                            if (Provider.of<MapProvider>(context).state ==
                                AppState.estimate)
                              paymentMethodDialog(context),
                            if ((Provider.of<MapProvider>(context).state ==
                                    AppState.select_pickUp) ||
                                (Provider.of<MapProvider>(context).state ==
                                    AppState.select_dis))
                              _pickerLocation(context),
                            if ((Provider.of<MapProvider>(context).state ==
                                AppState.select_dis))
                              _skip(context),
                            if ((Provider.of<MapProvider>(context).state ==
                                AppState.searching))
                              _cancelRide(context),
                            if ((Provider.of<MapProvider>(context).state !=
                                AppState.select_car))
                              _myLocationButton(context),
                          ],
                        );
                      }),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                });
              }),
        );
      }),
    );
  }

  Widget _myLocationButton(context) {
    return Positioned.directional(
      textDirection: allTranslations.locale.languageCode == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      end: 10,
      bottom: MediaQuery.of(context).size.height / 5,
      child: InkWell(
        onTap: () {
          Provider.of<MapProvider>(context).mapController.animateCamera(
              CameraUpdate.newLatLng(
                  Provider.of<MapProvider>(context).myLocation));
        },
        child: Container(
          child: Icon(Icons.gps_fixed),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
                color: Colors.black54, blurRadius: 3, offset: Offset(0, 3))
          ]),
        ),
      ),
    );
  }

  Widget _drawerIcon(context) {
    return Positioned.directional(
      textDirection: allTranslations.locale.languageCode == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      top: 10 + MediaQuery.of(context).padding.top,
      start: MediaQuery.of(context).size.width * 6.7 / 100,
      child: InkWell(
        child: Icon(
          Provider.of<MapProvider>(context).state == AppState.select_car ||
                  Provider.of<MapProvider>(context).state ==
                      AppState.select_pickUp
              ? Icons.menu
              : Icons.arrow_back,
          color: DataProvider().primary,
        ),
        onTap: () {
          if (Provider.of<MapProvider>(context).state == AppState.select_car ||
              Provider.of<MapProvider>(context).state ==
                  AppState.select_pickUp) {
            Provider.of<MapProvider>(context).openDrawer(context);
          } else {
            Provider.of<MapProvider>(context).onBackPressed(context);
          }
        },
      ),
    );
  }

  Widget _topbar(context) {
    return Positioned.directional(
        textDirection: allTranslations.locale.languageCode == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        top: MediaQuery.of(context).size.height * 10 / 100 +
            MediaQuery.of(context).padding.top,
        width: MediaQuery.of(context).size.width,
        height:
            Provider.of<MapProvider>(context).state == AppState.select_car ||
                    Provider.of<MapProvider>(context).state ==
                        AppState.select_pickUp
                ? 50
                : 101,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: ShapeDecoration(
              shadows: [
                BoxShadow(
                    color: Color(0xff4d000000),
                    offset: Offset(0, 3),
                    blurRadius: 6)
              ],
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 6.7 / 100),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 22, 8, 8),
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: DataProvider().primary),
                    ),
                    if (!(Provider.of<MapProvider>(context).state ==
                            AppState.select_pickUp) &&
                        !(Provider.of<MapProvider>(context).state ==
                            AppState.select_car))
                      Container(
                        width: 1,
                        height: 28,
                        color: DataProvider().primary,
                      ),
                    if (!(Provider.of<MapProvider>(context).state ==
                            AppState.select_pickUp) &&
                        !(Provider.of<MapProvider>(context).state ==
                            AppState.select_car))
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: DataProvider().primary, width: 1),
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (!(Provider.of<MapProvider>(context).state ==
                              AppState.select_pickUp) &&
                          !(Provider.of<MapProvider>(context).state ==
                              AppState.select_car))
                        _distination(context),
                      if (!(Provider.of<MapProvider>(context).state ==
                              AppState.select_pickUp) &&
                          !(Provider.of<MapProvider>(context).state ==
                              AppState.select_car))
                        Container(
                          width: double.infinity,
                          height: 0.5,
                          color: Colors.black,
                        ),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            if (Provider.of<MapProvider>(context).state ==
                                    AppState.searching ||
                                Provider.of<MapProvider>(context).state ==
                                    AppState.estimate) {
                              return;
                            }
                            var result = await Navigator.of(context)
                                .push(MaterialPageRoute(
                                    builder: (context) => SearchScreen(
                                          isPickup: true,
                                        )));

                            if (result != null) {
                              Provider.of<MapProvider>(context)
                                  .getFromSearchPickUp(result);
                              Provider.of<MapProvider>(context)
                                  .mapController
                                  .animateCamera(CameraUpdate.newLatLng(
                                      LatLng(result.lat, result.lng)));
                            }
                          },
                          child: FutureBuilder<Placemark>(
                              future: Provider.of<MapProvider>(context)
                                  .getAddressFromLatLong(
                                      Provider.of<MapProvider>(context)
                                          .pickupPosition),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return Container(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Text(
                                        allTranslations.text("Where to go?"),
                                        textAlign: TextAlign.start,
                                      ));
                                }
                                if (snapshot.hasData) {
                                  return Container(
                                      alignment:
                                          AlignmentDirectional.centerStart,
                                      child: Text(
                                        snapshot.data == ""
                                            ? allTranslations
                                                .text("Where to go?")
                                            : snapshot.data
                                                    .subAdministrativeArea +
                                                ", " +
                                                snapshot.data.thoroughfare,
                                        textAlign: TextAlign.start,
                                        overflow: TextOverflow.ellipsis,
                                      ));
                                } else {
                                  return SizedBox();
                                }
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget _distination(context) {
    return Expanded(
      child: InkWell(
        onTap: () async {
          if (Provider.of<MapProvider>(context).state == AppState.searching ||
              Provider.of<MapProvider>(context).state == AppState.estimate) {
            return;
          }
          var result = await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SearchScreen(
                    isPickup: false,
                  )));

          if (result != null) {
            Provider.of<MapProvider>(context).getFromSearchDis(result);
            Provider.of<MapProvider>(context).mapController.animateCamera(
                CameraUpdate.newLatLng(LatLng(result.lat, result.lng)));
          }
        },
        child: FutureBuilder<Placemark>(
            future: Provider.of<MapProvider>(context).getAddressFromLatLong(
                Provider.of<MapProvider>(context).distinationPostion),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Container(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      allTranslations.text("type your destination?"),
                      textAlign: TextAlign.start,
                    ));
                // return CustomErrorWidget();
              }
              if (snapshot.hasData) {
                return Container(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      snapshot.data.subAdministrativeArea +
                          ", " +
                          snapshot.data.thoroughfare,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                    ));
              } else {
                return SizedBox();
              }
            }),
      ),
    );
  }

  Widget _carType(context) {
    return Positioned.directional(
      textDirection: allTranslations.locale.languageCode == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      top: MediaQuery.of(context).size.height * 75 / 100,
      width: MediaQuery.of(context).size.width,height: 80,
      child: ListView(
       scrollDirection: Axis.horizontal,
        children: <Widget>[
          SizedBox(width: 26,),

          _carItem(
              context,
              CarTypes.sedan,
              "lib/assets/images/uber/sedan_car.png",
              allTranslations.text("Economy")),
          SizedBox(width: 52,),
          _carItem(
              context,
              CarTypes.supercar,
              "lib/assets/images/uber/super_car.png",
              allTranslations.text("Select")),
          SizedBox(width: 52,),

          _carItem(
              context,
              CarTypes.racing_car,
              "lib/assets/images/uber/racing_car.png",
              allTranslations.text("VIP")),
          SizedBox(width: 52,),




          _carItem2(
              context,
              CarTypes.bike,
              UberTypes.bicycle ,
              allTranslations.text("bike")),
          SizedBox(width: 52,),
          _carItem2(
              context,
              CarTypes.yatch,
              UberTypes.yatch ,
              allTranslations.text("yatch")),

          SizedBox(width: 52,),
          _carItem2(
              context,
              CarTypes.scooter,
              UberTypes.scooter ,
              allTranslations.text("scooter")),

          SizedBox(width: 52,),
          _carItem2(
              context,
              CarTypes.motorCycle,
              UberTypes.bike,
              allTranslations.text("motorcylce")),
          SizedBox(width: 52,),
          _carItem2(
              context,
              CarTypes.planes,
           UberTypes.helicopter  ,
              allTranslations.text("planes")),
          SizedBox(width: 52,),
          _carItem2(
              context,
              CarTypes.recovery,
              UberTypes.recovery  ,
              allTranslations.text("recovery")),
          SizedBox(width: 52,),
          _carItem2(
              context,
              CarTypes.train,
              UberTypes.train  ,
              allTranslations.text("train")),
          SizedBox(width: 52,),
          _carItem2(
              context,
              CarTypes.metro,
              UberTypes.metro  ,              allTranslations.text("metro")),
          SizedBox(width: 52,),
        ],
      ),
    );
  }

  Column _carItem(context, CarTypes carType, String assets, String title) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            Provider.of<MapProvider>(context).selectedCar = carType;
            Provider.of<MapProvider>(context).state = AppState.select_pickUp;
            Provider.of<MapProvider>(context).notifyListeners();
          },
          child: CircleAvatar(
            backgroundColor: DataProvider().primary,
            radius: 24,
            child: CircleAvatar(
              backgroundColor:
                  Provider.of<MapProvider>(context).selectedCar == carType
                      ? DataProvider().primary
                      : Colors.white,
              radius: 23.5,
              child: Image.asset(
                assets,
                height: 20,
                width: 30,
                color: Provider.of<MapProvider>(context).selectedCar == carType
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(title)
      ],
    );
  }



  Column _carItem2(context, CarTypes carType, IconData iconData, String title) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            Provider.of<MapProvider>(context).selectedCar = carType;
            Provider.of<MapProvider>(context).state = AppState.select_pickUp;
            Provider.of<MapProvider>(context).notifyListeners();
          },
          child: CircleAvatar(
            backgroundColor: DataProvider().primary,
            radius: 24,
            child: CircleAvatar(
              backgroundColor:
              Provider.of<MapProvider>(context).selectedCar == carType
                  ? DataProvider().primary
                  : Colors.white,
              radius: 23.5,
              child: Icon(
                iconData,
                size: 20,
                color: Provider.of<MapProvider>(context).selectedCar == carType
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Text(title)
      ],
    );
  }
  Widget _bottemCenter(context) {
    return Positioned.directional(
      textDirection: allTranslations.locale.languageCode == "ar"
          ? TextDirection.rtl
          : TextDirection.ltr,
      bottom: 0,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 10 / 100,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 32.2 / 100),
        child: InkWell(
          onTap: () {
            Provider.of<MapProvider>(context).bottomClicked();
          },
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new BottomButton(
                key: UniqueKey(),
                state: Provider.of<MapProvider>(context).state,
              ),
              Column(
                children: <Widget>[
                  Spacer(
                    flex: 3,
                  ),
                  Text(
                    Provider.of<MapProvider>(context).bottomText,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  Spacer()
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _skip(context) {
    return Positioned.directional(
        textDirection: allTranslations.locale.languageCode == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: InkWell(
          onTap: () {
            Provider.of<MapProvider>(context).skip();
          },
          child: Text(
            allTranslations.text("Skip"),
            style: TextStyle(color: DataProvider().primary, fontSize: 16),
          ),
        ),
        end: 24,
        top: 10 + MediaQuery.of(context).padding.top);
  }

  Widget _cancelRide(context) {
    return Positioned.directional(
        textDirection: allTranslations.locale.languageCode == "ar"
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: InkWell(
          onTap: () {
            Provider.of<MapProvider>(context).onBackPressed(context);
          },
          child: Text(
            allTranslations.text("Cancel Ride"),
            style: TextStyle(color: DataProvider().primary, fontSize: 16),
          ),
        ),
        end: 24,
        top: 10 + MediaQuery.of(context).padding.top);
  }

  Widget _pickerLocation(context) {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CircleAvatar(
          radius: 11,
          backgroundColor: DataProvider().primary,
          child:
              Provider.of<MapProvider>(context).state == AppState.select_pickUp
                  ? CircleAvatar(
                      radius: 10.5,
                      backgroundColor: DataProvider().primary,
                    )
                  : SizedBox(),
        ),
        Container(
          width: 1.5,
          height: 10,
          color: DataProvider().primary,
        ),
        CircleAvatar(radius: 4, backgroundColor: DataProvider().primary),
        SizedBox(
          height: (22 + 10 + 2).toDouble(),
        )
      ],
    ));
  }
}

class BottomButton extends StatefulWidget {
  final AppState state;

  const BottomButton({
    Key key,
    @required this.state,
  }) : super(key: key);

  @override
  _BottomButtonState createState() => _BottomButtonState();
}

class _BottomButtonState extends State<BottomButton>
    with SingleTickerProviderStateMixin {
  Animation<double> animation1;
  AnimationController controller1;

  @override
  void initState() {
    super.initState();
    controller1 =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    animation1 = Tween<double>(begin: 0.0, end: 3.0).animate(controller1)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    controller1.value = 1 / 3;
    if (widget.state == AppState.searching) {
      controller1.repeat();
    }
  }

  @override
  void dispose() {
    controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: BottomCirclePainter(
        Provider.of<MapProvider>(context).state,
        animation1.value,
      ),
    );
  }
}

class BottomCirclePainter extends CustomPainter {
  BottomCirclePainter(
    this.state,
    this.value,
  );

  AppState state;
  final double value;
  double value2, value3;

  adjustSizes() {
    if (value > 0 && value <= 1) {
      value2 = 0;
      value3 = 0;
    }
    if (value > 1 && value < 2) {
      value2 = value;
      value3 = 0;
    }
    if (value >= 2 && value <= 3) {
      value2 = 2;
      value3 = value;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    adjustSizes();

    Color color;
    if (state == AppState.select_car) {
      color = DataProvider().primary.withOpacity(0.5);
    } else {
      color = DataProvider().primary;
    }
//biger circle
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height),
            radius: size.width * value3 / 2.5),
        3.14,
        3.14 * 2,
        true,
        Paint()..color = color.withOpacity(0.15));

// //meduim circle
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height),
            radius: size.width * value2 / 2.5),
        3.14,
        3.14 * 2,
        true,
        Paint()..color = color.withOpacity(0.25));
//small circle
    canvas.drawArc(
        Rect.fromCircle(
            center: Offset(size.width / 2, size.height),
            radius: size.width / 2),
        3.14,
        3.14 * 2,
        true,
        Paint()..color = color);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

Widget paymentMethodDialog(context) {
  return Positioned.directional(
    textDirection: allTranslations.locale.languageCode == "ar"
        ? TextDirection.rtl
        : TextDirection.ltr,
    top: MediaQuery.of(context).size.height * 40.6 / 100,
    width: MediaQuery.of(context).size.width,
    height: 150,
    child: Container(
      width: MediaQuery.of(context).size.width,
      decoration: ShapeDecoration(
          shadows: [
            BoxShadow(
                color: Color(0xff29000000), offset: Offset(0, 3), blurRadius: 6)
          ],
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 15 / 100),
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Center(
                  child: Text(
                Provider.of<MapProvider>(context).distinationPostion != null
                    ? "21-28  LE"
                    : allTranslations.text("Estimate Fare"),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ))),
          Container(
            color: DataProvider().primary,
            width: double.infinity,
            height: .5,
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: <Widget>[
                Expanded(
                    child: InkWell(
                  onTap: () {
                    Provider.of<MapProvider>(context).isCash = true;
                    Provider.of<MapProvider>(context).notifyListeners();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        Provider.of<MapProvider>(context).isCash
                            ? "lib/assets/images/uber/cash.png"
                            : "lib/assets/images/uber/cash_grey.png",
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        allTranslations.text("Cash"),
                        style: TextStyle(
                            color: Provider.of<MapProvider>(context).isCash
                                ? Colors.black
                                : Colors.grey,
                            fontSize: 16),
                      )
                    ],
                  ),
                )),
                Container(
                  width: .5,
                  color: DataProvider().primary,
                ),
                Expanded(
                    child: InkWell(
                  onTap: () {
                    Provider.of<MapProvider>(context).isCash = false;
                    Provider.of<MapProvider>(context).notifyListeners();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        !Provider.of<MapProvider>(context).isCash
                            ? "lib/assets/images/uber/prepaid.png"
                            : "lib/assets/images/uber/prepaid_grey.png",
                        width: 20,
                        height: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        allTranslations.text("Card"),
                        style: TextStyle(
                            color: !Provider.of<MapProvider>(context).isCash
                                ? Colors.black
                                : Colors.grey,
                            fontSize: 16),
                      )
                    ],
                  ),
                )),
              ],
            ),
          )
        ],
      ),
    ),
  );
}
