import 'package:big/Providers/DataProvider.dart';
import 'package:flutter/material.dart';

abstract class Styles {
  static const searchBarTitle = TextStyle(
    color: Color.fromRGBO(128, 128, 128, 1),
    fontFamily: 'NotoSans',
    fontSize: 16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

///////////////////////// Colors ///////////////////////////

  static  Color appFirstColor = DataProvider().primary;
  static const Color appSecondColor = Color(0xff7a90d6);

  static const Color searchBarColor = Color(0xfff9f9f9);

  static const Color catOneFirstColor = Color(0xff26a2ff);
  static const Color catOneSceondColor = Color(0xffd67ad3);

  static const Color catTwoFirstColor = Color(0xff77ffc0);
  static const Color catTwoSceondColor = Color(0xff349065);

  static const Color catThreeFirstColor = Color(0xfff296f9);
  static const Color catThreeSceondColor = Color(0xff8d2d95);

  static const Color catFourFirstColor = Color(0xffffb184);
  static const Color catFourSceondColor = Color(0xffea5500);

  static const Color catFiveFirstColor = Color(0xff5fd37a);
  static const Color catFiveSceondColor = Color(0xff134e5e);

  static const Color catSixFirstColor = Color(0xffc99cff);
  static const Color catSixSceondColor = Color(0xff614385);

  static const Color catSevenFirstColor = Color(0xff92f8ff);
  static const Color catSevenSceondColor = Color(0xff00a5d6);

  static const Color catEightFirstColor = Color(0xff8caaff);
  static  Color catEightSceondColor =DataProvider().primary;

  static const Color catNineFirstColor = Color(0xfff8cdda);
  static const Color catNineSceondColor = Color(0xffff1b60);
}
