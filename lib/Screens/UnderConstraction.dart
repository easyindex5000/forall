import 'package:big/Providers/DataProvider.dart';
import 'package:big/componets/MainDrawer.dart';
import 'package:flutter/material.dart';

class UnderConstraction extends StatelessWidget {
  final String title;

  const UnderConstraction({Key key, @required this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: mainDrawer(context, "Under Constraction"),
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: FutureBuilder(
            future: precacheImage(
                AssetImage("lib/assets/images/under_construction.png"),
                context),
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return CircularProgressIndicator();
              }
              return Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      offset: Offset(1, 1),
                      blurRadius: 3,
                      color: Color(0xff29000000))
                ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset("lib/assets/images/under_construction.png"),
                    SizedBox(
                      height: 18,
                    ),
                    Localizations.localeOf(context).languageCode == "en"
                        ? Text("Under Constraction",
                            style: TextStyle(
                                fontFamily: "SHATTERB",
                                color: DataProvider().primary,
                                fontSize: 24))
                        : Text("تحت الأنشاء",
                            style: TextStyle(
                                fontFamily: "aldhabi",
                                color: DataProvider().primary,
                                fontSize: 40)),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
