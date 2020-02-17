import 'package:big/Providers/ColorsProvider.dart';
import 'package:big/Providers/DataProvider.dart';
import 'package:big/Screens/OnlineStoreHomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:big/localization/all_translations.dart';
import 'customProgess.dart';
import 'package:big/Screens/ForAllHome.dart';

class SubmittedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 200,
                width: 100,
                child: Image.asset("lib/assets/images/fullbag.png"),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1,
                height: 50,
                child: RaisedButton(
                  child: Text(
                    allTranslations.text("return_home"),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        new MaterialPageRoute(builder: (context) => new OnlineShoppingHome()));
                  },
                  elevation: 10.0,
                  color: DataProvider().primary,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
