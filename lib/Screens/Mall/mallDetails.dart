import 'dart:convert';

import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/mall/MallPovider.dart';
import 'package:big/componets/Error.dart';
import 'package:big/componets/ErrorScreen.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Stores.dart';

class MallDetails extends StatefulWidget {
  MallDetailsState createState() => MallDetailsState();
  final int id;
  MallDetails({this.id});
}

class MallDetailsState extends State<MallDetails> {
  String titlebar = "${allTranslations.text('mallDetails')}";
  String seeallshops = "${allTranslations.text('seeallshops')}";
  String workingTime = "${allTranslations.text('workingTime')}";
  String from = "${allTranslations.text('from')}";
  String to = "${allTranslations.text('to')}";
  String mallMap = "${allTranslations.text('mallMap')}";
List<String> week=["Saturday","Sunday","Monday","Tuesday","Wednesday","Thursday","Friday"];
  var data;
  var body;
  var openTime;
  var closeTime;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: Mybar(titlebar, false),
                      body: FutureBuilder(
          future: MallProvider().getMallDetails(widget.id).then((res) {
            data = json.decode(res);
            body = data["data"];
          })
            ..catchError((onError) {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => ErrorScreen()));
            }),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return CustomErrorWidget();
            }
            if (body != null) {
              bool isOpen = body["isOpen"];
              DateTime open = DateTime.parse(body["open_time"]["date"]
                  .substring(0, body["open_time"]["date"].indexOf("00") + 2));
              openTime=open.toString();

              DateTime close = DateTime.parse(body["close_time"]["date"]
                  .substring(0, body["close_time"]["date"].indexOf("00") + 2));
              closeTime=close.toString();
              DateTime now = DateTime.now();
             
              return Material(child:
                   Column(
                        children: <Widget>[
                          Expanded(
                                                    child: SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Container(
                                          width: 110.0,
                                          height: 110.0,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                    offset: Offset(0, 3),
                                                    color: Color(0xff29000000),
                                                    blurRadius: 6)
                                              ]),
                                          margin: const EdgeInsets.only(right: 10.0),
                                         // padding: const EdgeInsets.all(3.0),
                                          child: ClipOval(
                                            child: Stack(alignment: Alignment.center,
                                              children: <Widget>[
                                                cover(body: body),
                                            islock(isOpen: isOpen)
                                            
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.only(bottom: 17.0),
                                                child: name(body: body),
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.location_on,
                                                    color: DataProvider().primary,
                                                  ),
                                                  Expanded(child: city(body: body)),
                                                ],
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Icon(Icons.phone,
                                                      color: DataProvider().primary),
                                                  number(body: body),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      height: 48,
                                      color: Colors.grey,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        workingtime(workingTime: workingTime),
                                        SizedBox(height: 16),
                                        Row(
                                          children: <Widget>[
                                            CircleAvatar(radius: 5,backgroundColor: Colors.black,),SizedBox(width: 5,),   fromwidget(from: from, week: week, body: body, to: to),
                                          ],
                                        ),
                                     Row(
                                       children: <Widget>[
                                         CircleAvatar(radius: 5,backgroundColor: Colors.black,),SizedBox(width: 5,), Builder(
                                           builder: (context, ) {
                                             try{
    String s ='$from ${openTime.toString().substring(10,16)} $to ${closeTime.toString().substring(10,16)}';
                                             return Text(s);
                                             }catch(e){
                                               return SizedBox();
                                             }
                                       
                                           }
                                         ),
                                       ],
                                     ),
                                      ],
                                    ),
                                    Divider(
                                      height: 48,
                                      color: Colors.grey,
                                    ),
                                    mapimage(body: body),
                                 
                                  ],
                                ),
                              ),
                            ),
                          ),
                             Center(
                                      child: RaisedButton(padding: EdgeInsets.symmetric(horizontal: 5,),
                                          child: Text(
                                            '$seeallshops',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          color: DataProvider().primary,
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext context) =>
                                                        Stores(
                                                          mallID: widget.id,
                                                        )));
                                          }))
                        ],
                      ));
            } else {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          }),
    );
  }
}

class mapimage extends StatelessWidget {
  const mapimage({
    Key key,
    @required this.body,
  }) : super(key: key);

  final  body;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: precacheImage(
          NetworkImage(body["map"]),
          context),
      builder: (context, snapshot) {
        if(snapshot.connectionState!=ConnectionState.done){
          return Container(width: double.infinity,height: 200,color: Colors.grey);
        }
        return FadeInImage(
          placeholder: AssetImage(
              "lib/assets/images/errorImage.png"),
          image: NetworkImage(body["map"]),
        );
      }
    );
  }
}

class fromwidget extends StatelessWidget {
  const fromwidget({
    Key key,
    @required this.from,
    @required this.week,
    @required this.body,
    @required this.to,
  }) : super(key: key);

  final String from;
  final List<String> week;
  final  body;
  final String to;

  @override
  Widget build(BuildContext context) {
    try{
  String s='$from ${week[body["start_date"]]} $to ${week[body["end_date"]]}';
    return Text(s);
    }catch(e){
return SizedBox();
    }
  
  }
}

class workingtime extends StatelessWidget {
  const workingtime({
    Key key,
    @required this.workingTime,
  }) : super(key: key);

  final String workingTime;

  @override
  Widget build(BuildContext context) {
    if(workingTime==null){
      return SizedBox();
    }
    return Text('$workingTime', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
  }
}

class number extends StatelessWidget {
  const number({
    Key key,
    @required this.body,
  }) : super(key: key);

  final  body;

  @override
  Widget build(BuildContext context) {
    if(body['mobile_number']==null){
      return SizedBox();
    }
    return Text(body["mobile_number"]);
  }
}

class city extends StatelessWidget {
  const city({
    Key key,
    @required this.body,
  }) : super(key: key);

  final  body;

  @override
  Widget build(BuildContext context) {
       if(body['city']==null){
      return SizedBox();
    }
    return Text(body['city']);
  }
}

class name extends StatelessWidget {
  const name({
    Key key,
    @required this.body,
  }) : super(key: key);

  final  body;

  @override
  Widget build(BuildContext context) {
       if(body['name']==null){
      return SizedBox();
    }
    return Text(body['name'],
        style: TextStyle(
            fontWeight: FontWeight.bold));
  }
}

class islock extends StatelessWidget {
  const islock({
    Key key,
    @required this.isOpen,
  }) : super(key: key);

  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
          if(!isOpen)
        Container(color: Color(0xffa6000000).withOpacity(0.5),width:double.infinity,height: double.infinity,),
        if(!isOpen)
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset( "lib/assets/images/lock.png"),
        )
    ],);
  }
}

class cover extends StatelessWidget {
  const cover({
    Key key,
    @required this.body,
  }) : super(key: key);

  final  body;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: precacheImage(
    NetworkImage(
    body["cover"]),
                                              context),
      builder: (context, snapshot) {
        if(snapshot.connectionState!=ConnectionState.done){
          return Container(width: double.infinity,height: 200,color: Colors.grey);
        }
        return FadeInImage(
          placeholder: AssetImage(
              "lib/assets/images/errorImage.png"),
          image: NetworkImage(body["cover"]),
          fit: BoxFit.fitWidth,
        );
      }
    );
  }
}
