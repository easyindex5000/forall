  import 'package:big/Providers/DataProvider.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
Widget tab(int  index) {
    return Row(
      children: <Widget>[
//        Column(
//          children: <Widget>[
//            CircleAvatar(
//              backgroundColor: DataProvider().primary,
//              radius: 10,
//            ),
//            SizedBox(
//              height: 10,
//            ),
//            Text(allTranslations.text("General"))
//          ],
//        ),
//        Expanded(
//          child: Container(
//            width: double.infinity,
//            height: 1,
//            color:index!=0? DataProvider().primary:Colors.black,
//          ),
//        ),
        Column(
          children: <Widget>[
            CircleAvatar(
              backgroundColor:index> 0?DataProvider().primary:Colors.grey,
              radius: 10,
            ),
            SizedBox(
              height: 10,
            ),
            Text(allTranslations.text("Career"))
          ],
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            height: 1,
            color:index> 1?DataProvider().primary:Colors.grey
          ),
        ),
        Column(
          children: <Widget>[
            CircleAvatar(
              backgroundColor: index> 1?DataProvider().primary:Colors.grey,
              radius: 10,
            ),
            SizedBox(
              height: 10,
            ),
            Text(allTranslations.text("Professional"))
          ],
        ),
      ],
    );
  }