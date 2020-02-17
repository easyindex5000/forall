import 'package:big/Providers/DataProvider.dart';
import 'package:big/componets/ConnectivityChecker.dart';
import 'package:big/componets/MainDrawer.dart';
import 'package:big/componets/notification.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyOrder extends StatefulWidget {
  @override
  _MyOrderState createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  @override
  void initState() {

        super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final double itemHeight = MediaQuery.of(context).size.height * 0.36;
    final double itemWidth = MediaQuery.of(context).size.width * 0.40;
    return Scaffold(
      drawer: mainDrawer(context, "HomePage"),
      appBar: AppBar(
        title: Text(allTranslations.text("Main Home"),style: TextStyle(color: Colors.black),),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              allTranslations.text("on shipping"),
              style: TextStyle(
                  fontSize: 18,
                  color: DataProvider().primary,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          SizedBox(
            height: 160,
            width: double.infinity,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return AspectRatio(
                  aspectRatio: 125 / 140,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: ShapeDecoration(
                        color: Colors.white,
                        shadows: [
                          BoxShadow(
                              color: Color(0xff29000000),
                              offset: Offset(3, 3),
                              blurRadius: 6)
                        ],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    //  width: MediaQuery.of(context).size.width * 0.35,
                    //    height: MediaQuery.of(context).size.height * .21,
                    height: 160,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                            flex: 7,
                            child: Container(
                              decoration: ShapeDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                        "lib/assets/images/errorImage.png",
                                      ),
                                      fit: BoxFit.contain),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  )),
                            )),
                        SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Phone"),
                              Wrap(children: <Widget>[
                                Text(
                                  '50 USD',
                                  style: TextStyle(
                                      fontSize: 10,
                                      decoration: TextDecoration.lineThrough),
                                ),
                                Text(
                                  "100 USD",
                                  style: TextStyle(fontSize: 10),
                                ),
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: 10,
            ),
          ),
          SizedBox(
            height: 32,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              allTranslations.text("History"),
              style: TextStyle(
                  fontSize: 18,
                  color: DataProvider().primary,
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
                itemCount: 5,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: MediaQuery.of(context).size.width>600?3:2,
                                    mainAxisSpacing: 5,
                                    crossAxisSpacing: 5,
                                    childAspectRatio: 0.8),

                //  new SliverGridDelegateWithFixedCrossAxisCount(
                //     mainAxisSpacing: 12.0,
                //     crossAxisCount: 2,
                //     crossAxisSpacing: 24,
                //     childAspectRatio: itemWidth / itemHeight),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: InkWell(
                                  child: Builder(builder: (
                                    context,
                                  ) {
                                    bool hasError = false;
                                    return FutureBuilder(
                                        future: precacheImage(
                                            NetworkImage(
                                                "productList[index].cover"),
                                            context, onError: (_, __) {
                                          hasError = true;
                                        }),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState !=
                                              ConnectionState.done) {
                                            return new Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  if (true)
                                                    Stack(
                                                      children: <Widget>[
                                                        Transform.translate(
                                                          offset: Offset(
                                                              -10.0, -10.0),
                                                          child: Container(
                                                            width: 45.0,
                                                            height: 20.0,
                                                            color: Color(
                                                                0XFFff2b2b),
                                                            child: Text(
                                                              allTranslations
                                                                  .text("New"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                              decoration: new BoxDecoration(
                                                color: Colors.grey,
                                              ),
                                            );
                                          }
                                          if (!hasError &&
                                              snapshot.connectionState ==
                                                  ConnectionState.done) {
                                            return new Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  if (true)
                                                    Stack(
                                                      children: <Widget>[
                                                        Transform.translate(
                                                          offset: Offset(
                                                              -10.0, -10.0),
                                                          child: Container(
                                                            width: 45.0,
                                                            height: 20.0,
                                                            color: Color(
                                                                0XFFff2b2b),
                                                            child: Text(
                                                              allTranslations
                                                                  .text("New"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                              decoration: new BoxDecoration(
                                                image: new DecorationImage(
                                                    fit: BoxFit.contain,
                                                    image: NetworkImage(
                                                        "productList[index].cover")),
                                              ),
                                            );
                                          } else {
                                            return Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  if (true)
                                                    Stack(
                                                      children: <Widget>[
                                                        Transform.translate(
                                                          offset: Offset(
                                                              -10.0, -10.0),
                                                          child: Container(
                                                            width: 45.0,
                                                            height: 20.0,
                                                            color: Color(
                                                                0XFFff2b2b),
                                                            child: Text(
                                                              allTranslations
                                                                  .text("New"),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                ],
                                              ),
                                              decoration: new BoxDecoration(
                                                image: new DecorationImage(
                                                    fit: BoxFit.contain,
                                                    image: AssetImage(
                                                        "lib/assets/images/errorImage.png")),
                                              ),
                                            );
                                          }
                                        });
                                  }),
                                  onTap: () {}),
                            ),
                            new Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Wrap(
                                          children: <Widget>[
                                            new Text(
                                              " 200 \EGY ",
                                              style: new TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color: Color(0XFF161a28)),
                                            ),
                                            Text(
                                              "200\EGY",
                                              style: TextStyle(
                                                  color: Color(0XFF7f7f7f),
                                                  fontWeight: FontWeight.w100,
                                                  fontSize: 12,
                                                  decoration: TextDecoration
                                                      .lineThrough),
                                            ),
                                          ],
                                        ),
                                      ),
                                      StatefulBuilder(
                                          builder: (context, setState) {
                                        return FutureBuilder<bool>(
                                            future: null,
                                            builder: (context, snapshot) {
                                              // if (!snapshot.hasData) {
                                              //   return SizedBox();
                                              // }
                                              return new IconButton(
                                                  iconSize: 20.0,
                                                  padding:
                                                      const EdgeInsets.all(0.0),
                                                  alignment: Alignment.center,
                                                  icon: Icon(
                                                    Icons.favorite,
                                                    color: Colors.grey,
                                                  ),
                                                  onPressed: () {});
                                            });
                                      }),
                                    ],
                                  ),
                                  Text(
                                    "name",
                                    overflow: TextOverflow.ellipsis,
                                    style: new TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 12,
                                        color: Color(0XFF5d5e62)),
                                    maxLines: 2,
                                  ),
                                  Consumer<DataProvider>(
                                    builder: (context, dataProvider, _) =>
                                        (Container(
                                      width: double.infinity,
                                      child: RaisedButton(
                                        color: DataProvider().primary,
                                        onPressed: () async {},
                                        child: Text(
                                            allTranslations.text("ADD TO BAG"),
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    )),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ));
                }),
          )
        ],
      ),
    );
  }
}
