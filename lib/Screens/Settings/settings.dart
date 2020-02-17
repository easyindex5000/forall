import 'package:big/Langauge.dart';
import 'package:big/Providers/DataProvider.dart';
import 'package:big/Providers/languageProvider.dart';
import 'package:big/Screens/MasterHome.dart';
import 'package:big/Screens/Settings/ChangeMobileNumber.dart';
import 'package:big/Screens/Settings/ContactUs.dart';
import 'package:big/Screens/Settings/FAQ.dart';
import 'package:big/Screens/Settings/ShippingIstructions.dart';
import 'package:big/Screens/Settings/Terms.dart';
import 'package:big/Screens/Settings/changePassword.dart';
import 'package:big/Screens/Settings/earn_point.dart';
import 'package:big/componets/MainDrawer.dart';
import 'package:big/componets/settings_icons.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:big/Screens/Settings/returnPolicy.dart';
class Settings extends StatefulWidget {
  final bool isLogin;

  const Settings({Key key, this.isLogin}) : super(key: key);
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          allTranslations.text("Settings"),
          style: TextStyle(color: DataProvider().secondry),
        ),
      ),
      body: ListView(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LanguageScreen(true)));
            },
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        SettingIcons.language,
                        color: DataProvider().primary,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(allTranslations.text("Language"))
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Consumer<LanguageProvider>(builder: (context, model, _) {
                        return Text(model.locale.languageCode);
                      }),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: DataProvider().primary,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          if (isLogin)
            _item(
                title: allTranslations.text("Password"),
                icon: SettingIcons.lock,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangePassword()));
                }),
          if (isLogin)
            _item(
                title: allTranslations.text("Mobile Number"),
                icon: SettingIcons.smartphone_1,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeMobileNumber()));
                }),
          _item(
              title: allTranslations.text("Terms & Condistions"),
              icon: SettingIcons.outline,
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Terms()));
              }),
                  _item(
              title: allTranslations.text("Returns and Refund Policy"),
              icon: SettingIcons.outline,
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => ReturnPolicy()));
              }),
          _item(
              title: allTranslations.text("Delivery & Shipping Istructions"),
              icon: SettingIcons.delivery_truck,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShippingIstructions()));
              }),
          _item(
              title: allTranslations.text("FAQ"),
              icon: SettingIcons.help,
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => FAQ()));
              }),
          _item(
              title: allTranslations.text("Contact Us"),
              icon: SettingIcons.phone_call,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ContactUs()));
              }),
              //        _item(
              // title: allTranslations.text("Earn Points"),
              // icon: Icons.attach_money,
              // onTap: () {
              //   Navigator.push(context,
              //       MaterialPageRoute(builder: (context) => EarnPoints()));
              // }),
        ],
      ),
    );
  }

 Widget _item(
      {@required String title,
      @required IconData icon,
      @required Function onTap}) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Icon(
                    icon,
                    color: DataProvider().primary,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: DataProvider().primary,
            )
          ],
        ),
      ),
    );
  }
}
