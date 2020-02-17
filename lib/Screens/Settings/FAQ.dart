import 'dart:convert';

import 'package:big/Providers/DataProvider.dart';
import 'package:big/componets/Error.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';

class FAQ extends StatefulWidget {
  @override
  _FAQState createState() => _FAQState();
}

class _FAQState extends State<FAQ> {
  var data;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            allTranslations.text("FAQ"),
            style: TextStyle(
              color: DataProvider().secondry,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: ListView.builder(
            itemCount: 7,
            itemBuilder: (context, index) {
              return buildExpansionTile(
                  allTranslations.text("q$index"),
                  DataProvider().primary,
                  allTranslations.text("a$index"),
                  Colors.grey[700]);
            }));
  }

  ExpansionTile buildExpansionTile(
      String header, Color headerColor, String body, Color setColor) {
    return ExpansionTile(
      title: new Text(
        header,
        style: TextStyle(color: headerColor),
      ),
      children: <Widget>[
        new Column(
          children: <Widget>[
            ListTile(
              title: Text(
                body,
                style: TextStyle(color: setColor),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
