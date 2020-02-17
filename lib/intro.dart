import 'package:big/Providers/AuthProvider.dart';
import 'package:big/Providers/DataProvider.dart';
import 'package:big/Screens/MasterHome.dart';
import 'package:big/Screens/OnlineStoreHomeScreen.dart';
import 'package:flutter/material.dart';

import 'localization/all_translations.dart';

class IntroductionPage extends StatefulWidget {
  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  PageController _controller;
  int currentIndex = 0;
  List<String> texts = [
    allTranslations.text("Def-onlineshopping"),
    allTranslations.text("Def-Malls"),
    allTranslations.text("Def-Auction"),
    allTranslations.text("Def-booking"),
    allTranslations.text("Def-Cars"),
    allTranslations.text("Def-delivery")
  ];
  @override
  void initState() {
    _controller = PageController();
    _controller.addListener(() {
      currentIndex = _controller.page.round();
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Align(
                alignment: AlignmentDirectional(1, 0),
                child: InkWell(
                  onTap: () {
                    AuthProvider().setFirst();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => MasterHome()));
                  },
                  child: Text(
                    allTranslations.text("skip"),
                    style: TextStyle(color: DataProvider().primary,decoration: TextDecoration.underline),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 2 / 3,
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: PageView.builder(
                    itemCount: 6,
                    controller: _controller,
                    itemBuilder: (context, snapshot) {
                      return Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Image.asset(
                            "lib/assets/images/intro/${currentIndex + 1}.png",
                            height: MediaQuery.of(context).size.height * 2 / 3,
                            fit: BoxFit.contain,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xff29000000),
                                      offset: Offset(5, 5),
                                      blurRadius: 10)
                                ]),
                            height: MediaQuery.of(context).size.height * 2 / 3,
                            margin: EdgeInsets.fromLTRB(60, 40, 60, 40),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Image.asset(
                                    "lib/assets/images/intro/${currentIndex + 1}_${currentIndex + 1}.png",
                                    width: double.infinity,
                                    height: 150,
                                  ),
                                  SizedBox(
                                    height: 24,
                                  ),
                                  Expanded(
                                    child: ListView(
                                      children: <Widget>[
                                        Text(
                                          texts[currentIndex],
                                          style: TextStyle(
                                              color: DataProvider().primary),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    }),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    margin: EdgeInsets.all(5),
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        border: Border.all(color: DataProvider().primary),
                        color: currentIndex == index
                            ? DataProvider().primary
                            : null,
                        shape: BoxShape.circle),
                  );
                }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                currentIndex == 0
                    ? SizedBox()
                    : InkWell(
                        onTap: () {
                          _controller.animateToPage(--currentIndex,
                              duration: Duration(milliseconds: 400),
                              curve: Curves.easeInOut);
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: ShapeDecoration(
                              color: DataProvider().primary,
                              shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadiusDirectional.only(
                                bottomEnd: Radius.circular(15),
                                topEnd: Radius.circular(15)))),
                          child: Icon(
                            Icons.navigate_before,
                            color: Colors.white,
                            textDirection:
                                allTranslations.locale.languageCode == "ar"
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                          ),
                        ),
                      ),
                InkWell(
                  onTap: () {
                    if (currentIndex < 5) {
                      _controller.animateToPage(++currentIndex,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut);
                    } else {
                      AuthProvider().setFirst();

                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => MasterHome()));
                    }
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: ShapeDecoration(
                        color: DataProvider().primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusDirectional.only(
                                bottomStart: Radius.circular(15),
                                topStart: Radius.circular(15)))),
                    child: Icon(
                      currentIndex == 5
                          ? Icons.play_arrow
                          : Icons.navigate_next,
                      textDirection: allTranslations.locale.languageCode == "ar"
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                allTranslations.text('Copy Right') +
                    " \u00a9 " +
                    allTranslations.text('Easy Index') +
                    " 2019",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
