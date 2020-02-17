import 'package:big/Providers/AuthProvider.dart';
import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/languageProvider.dart';
import 'package:big/componets/Loading.dart';
import 'package:big/componets/splashScreen.dart';
import 'package:big/intro.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'componets/flags_icons.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen(this.isPop);
  bool isPop;
  List<_Data> languages = [
    _Data(
      "عربي",
      "lib/assets/images/flags/saudi_arabia.png",
    ),
    _Data("English", "lib/assets/images/flags/Group_5501.png"),
    _Data("Française", "lib/assets/images/flags/Group_5502.png"),
    _Data("русский", "lib/assets/images/flags/Group_5500.png"),
    _Data("Türk", "lib/assets/images/flags/Group_5499.png"),
    _Data("italiana", "lib/assets/images/flags/Group_5498.png"),
    _Data("Deutsch", "lib/assets/images/flags/Group_5497.png"),
    _Data("中文", "lib/assets/images/flags/Group_5496.png")
  ];
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, langauge, _) {
        return Scaffold(
          appBar: isPop ? AppBar() : null,
          body: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Text(
                      isPop
                          ? allTranslations.text("Choose Langauge")
                          : "Choose Langauge",
                      style: TextStyle(
                          color: DataProvider().primary, fontSize: 20)),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: languages.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: ()async {
                      try{
                        await loadWidget(context, setlangLocalyAndtoServer(index, langauge));

                      }catch(e){

                      }
                      if (isPop) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IntroductionPage()));
                      }
                    },
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width * .1,
                          vertical: 16),
                      decoration: ShapeDecoration(
                          color: Colors.white,
                          shadows: [
                            BoxShadow(
                                offset: Offset(0, 3),
                                blurRadius: 6,
                                color: Color(0xff4d000000))
                          ],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: <Widget>[
                          Image.asset(
                            languages.elementAt(index).imagePath,
                            width: 40,
                            height: 40,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            languages.elementAt(index).title,
                            style: TextStyle(fontSize: 18),
                          )
                        ]),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future setlangLocalyAndtoServer(int index, LanguageProvider langauge) async {
    print(1);
    await   langauge.setLang(languages[index].title);
    print(2);

    await   AuthProvider().setLanguage(languages[index].title);
    print(3);

  }
}

class _Data {
  String title;
  String imagePath;
  _Data(this.title, this.imagePath);
}
