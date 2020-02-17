import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/languageProvider.dart';
import 'package:big/Screens/ForAllHome.dart';
import 'package:big/Screens/Profile.dart';
import 'package:big/Screens/Uber/UberHomeScreen.dart';
import 'package:big/Screens/mazad/MazadHome.dart';
import 'package:big/Screens/wuzzef/signup/career.dart';
import 'package:big/componets/Error.dart';
import 'package:big/componets/splashScreen.dart';
import 'package:big/intro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_country_picker/country.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Langauge.dart';
import 'package:big/Screens/OnlineStoreHomeScreen.dart';
import 'Screens/wuzzef/wuzzefHome.dart';
import 'localization/all_translations.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
void main() async {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Builder(
      builder: (context) {
        return CustomErrorWidget();
      },
    );
  };
  // ErrorWidget.builder = (FlutterErrorDetails details) {
  //   return Builder(
  //     builder: (context) {
  //       return SizedBox();
  //     },
  //   );
  // };

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<LanguageProvider>(create: (context) {
        return LanguageProvider(allTranslations.locale);
      }),
      ChangeNotifierProvider<DataProvider>(create: (context) {
        return DataProvider();
      })
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
    allTranslations.onLocaleChangedCallback = _onLocaleChanged;
  }

  _onLocaleChanged() async {
    // do anything you need to do if the language changes
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Consumer<LanguageProvider>(builder: (context, snapshot, _) {
      return MaterialApp(
        navigatorKey: navigatorKey,
        locale: snapshot.locale,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: allTranslations.supportedLocales(),

        routes: {"home": (context) => OnlineShoppingHome()},
        theme: ThemeData(
            canvasColor: Colors.white,
            fontFamily: 'Roboto',
            appBarTheme: AppBarTheme(
              actionsIconTheme: IconThemeData(color: DataProvider().primary),
              iconTheme: IconThemeData(color: DataProvider().primary),
              elevation: 0,
              color: Colors.white,
            )),
        home: Career(),
        //home:ForAllHome()
      );
    });
  }
}
