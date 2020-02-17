import 'package:big/Langauge.dart';
import 'package:big/Providers/AuthProvider.dart';
import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/languageProvider.dart';
import 'package:big/Screens/MasterHome.dart';
import 'package:big/Screens/OnlineStoreHomeScreen.dart';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:async/async.dart';

class SplashScreen extends StatefulWidget {
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  AsyncMemoizer _memorizer = AsyncMemoizer();

  String splash;
  @override
  void initState() {
    super.initState();
   
    splash = "lib/assets/images/logo/logo_final.png";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(builder: (context, model, _) {
      return Consumer(builder: (context, DataProvider dataProvider, _) {
        return FutureBuilder(future: _memorizer.runOnce(() {
          return updateProgress(model, dataProvider, context);
        }), builder: (context, snapshot) {
          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                                width: 300,
                                height: 200,
                                child: Image.asset("$splash")),
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                            ),
                            Container(
                              width: 150,
                              height: 5,
                              child: LinearProgressIndicator(
                                  backgroundColor: Colors.grey,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xff27b67c))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            bottomNavigationBar: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Copy Right' + " \u00a9 " + 'Easy Index' + " 2020",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      });
    });
  }

  // by updating the progress value
  Future updateProgress(
      LanguageProvider langModel, DataProvider dataProvider, context) async {
    try {
      await AuthProvider().deviceReg();
      print("1");
      bool res = await AuthProvider().introduction(langModel, dataProvider);

      if (res) {
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LanguageScreen(false)));
      } else {
        await Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => MasterHome()));
      }
    } catch (e) {
      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LanguageScreen(false)));
    }
  }
}
