import 'package:big/Providers/DataProvider.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';

class EarnPoints extends StatefulWidget {
  @override
  _EarnPointsState createState() => _EarnPointsState();
}

class _EarnPointsState extends State<EarnPoints> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            allTranslations.text("point"),
            style: TextStyle(color: Colors.black),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return _sellYourPointsDialog();
                });
          },
          child: Image.asset(
            "lib/assets/images/euro.png",
            height: 24,
            width: 24,
          ),
          backgroundColor: DataProvider().primary,
        ),
        body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(allTranslations.text("Your Points"),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(
                  height: 8,
                ),
                Container(
                  width: 100,
                  height: 70,
                  alignment: Alignment.center,
                  child: Text(
                    "2000",
                    style: TextStyle(fontSize: 16),
                  ),
                  decoration: ShapeDecoration(
                      color: Colors.white,
                      shadows: [
                        BoxShadow(
                            blurRadius: 6,
                            offset: Offset(0, 3),
                            color: Color(0xff29000000))
                      ],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32))),
                ),
                SizedBox(
                  height: 24,
                ),
                Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      allTranslations.text("Adding Points"),
                      style: TextStyle(color: Colors.grey),
                    )),
                    SizedBox(height: 8,),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return _addYourPoints();
                        });
                  },
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 12,
                        backgroundImage:
                            AssetImage("lib/assets/images/logo/logo_final.png"),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text("For All"),
                      Spacer(),
                      Text("1 USD")
                    ],
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (_, index) {
                      return InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return _addYourPoints();
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                radius: 12,
                                backgroundImage: NetworkImage(
                                    "https://cdn0.iconfinder.com/data/icons/avatar-78/128/12-512.png"),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text("Ahmed"),
                              Spacer(),
                              Text("1 USD")
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            )));
  }

  Dialog _addYourPoints() {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Column(
              children: <Widget>[
                Text(
                  allTranslations.text("Add your Total Points"),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffd4d4d4), width: 1)),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: "200"),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Container(
            color: DataProvider().primary,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Text(allTranslations.text("Buy"),
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
               SizedBox(
                  height: 24,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      margin: EdgeInsets.all(1),
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: Text(
                        allTranslations.text("Close"),
                        style: TextStyle(color: DataProvider().primary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Dialog _sellYourPointsDialog() {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Column(
              children: <Widget>[
                Text(
                  allTranslations.text("Sell your points"),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffd4d4d4), width: 1)),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            allTranslations.text("Points you want to sell")),
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffd4d4d4), width: 1)),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: allTranslations.text("Price of one Point")),
                  ),
                ),
                 SizedBox(
                  height: 24,
                ),
              ],
            ),
          ),
          Container(
            color: DataProvider().primary,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      child: Text(allTranslations.text("Sell"),
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 40,
                      margin: EdgeInsets.all(1),
                      alignment: Alignment.center,
                      color: Colors.white,
                      child: Text(
                        allTranslations.text("Close"),
                        style: TextStyle(color: DataProvider().primary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
