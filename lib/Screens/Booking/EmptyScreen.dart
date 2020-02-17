import 'package:big/Providers/DataProvider.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/componets/shopping_icons.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
class EmptyScreen extends StatefulWidget {
  @override
  _EmptyScreenState createState() => _EmptyScreenState();
}

class _EmptyScreenState extends State<EmptyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Mybar(allTranslations.text("CARS"),true),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(height: 32,
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 6.7 / 100),
                color: Color(0xffc6c6c6),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("0 "+allTranslations.text("item"), style: TextStyle(fontSize: 16, color: Color(0xff707070)),),
                    Row(
                      children: <Widget>[
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: <Widget>[
                              Text(allTranslations.text("sort by"), style: TextStyle(fontSize: 16, color: Color(0xff707070)),),
                              SizedBox(width: 10,),
                              Icon(Shopping.swap_vertical, size: 20, color: Color(0xff707070))
                            ],
                          ),
                        ),
                        SizedBox(width: 10,),
                        InkWell(onTap: () async {},
                          child: Row(
                            children: <Widget>[
                              Text(allTranslations.text("Filter"),
                                style: TextStyle(fontSize: 16, color: Color(0xff707070)),),
                              SizedBox(width: 10,),
                              Icon(Shopping.path_263, size: 12, color: Color(0xff707070))
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 100,
                          height: 100,
                          child: Image.asset("lib/assets/images/robot.png"),
                      ),
                      SizedBox(height: 50,),
                      Text(allTranslations.text("Sorry we couldn't find any matches for your search"),style: TextStyle(color: DataProvider().primary,fontWeight: FontWeight.bold),),
                      SizedBox(height: 20,),
                      Text(allTranslations.text("Let's Try Again..."),style: TextStyle(color: DataProvider().primary,fontWeight: FontWeight.bold),),
                      SizedBox(height: 20,),
                      OutlineButton(
                        onPressed: (){},
                        child: Text(allTranslations.text("S E A R C H"),style: TextStyle(color: DataProvider().primary,fontWeight: FontWeight.bold),),
                          borderSide: BorderSide(
                            color: DataProvider().primary, //Color of the border
                            style: BorderStyle.solid, //Style of the border
                            width: 0.8, //width of the border
                          )
                      ),
                    ],
                  ),
                ),
        ],

      ),
    );
  }
}
