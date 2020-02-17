import 'package:big/Providers/DataProvider.dart';
import 'package:big/Screens/wuzzef/signup/uppertab_widget.dart';
import 'package:big/Screens/wuzzef/wuzzefHome.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';

class Professional extends StatefulWidget {
  @override
  _ProfessionalState createState() => _ProfessionalState();
}

class _ProfessionalState extends State<Professional> {
  List<TextEditingController> _controllers = [TextEditingController()];
  Map<int, String> _languageLevel = {
    1: allTranslations.text("Low"),
    2: allTranslations.text("Intermediate"),
    3: allTranslations.text("Fluent")
  };
  //first int language id  secound int selectedLanguageLevelID
  Map<int, int> _selectedLanguageLevel = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
         allTranslations.text("sign_up"),
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: ListView(
          children: <Widget>[
            tab(2),
            SizedBox(
              height: 24,
            ),
            DropdownButton(
              isExpanded: true,
              hint: Text(allTranslations.text("Experience Year(s)")),
              icon: Icon(Icons.keyboard_arrow_down),
              value: 1,
              onChanged: (value) {},
              items: [],
            ),
            DropdownButton(
              isExpanded: true,
              hint: Text(allTranslations.text("Current Education Level")),
              icon: Icon(Icons.keyboard_arrow_down),
              value: 1,
              onChanged: (value) {},
              items: [],
            ),
            DropdownButton(
              isExpanded: true,
              hint: Text(allTranslations.text("Level Of English Language")),
              icon: Icon(Icons.keyboard_arrow_down),
              value: 1,
              onChanged: (value) {},
              items: [],
            ),
            ...List.generate(_controllers.length, (index) {
              if (_controllers[index] == null) {
                return SizedBox();
              }
              return Column(
                children: <Widget>[
                  TextField(
                    controller: _controllers[index],
                    decoration:
                        InputDecoration(hintText: allTranslations.text("What languages do you know")),
                    onChanged: (String value) {
                      if (value.trim().isNotEmpty &&
                          index == _controllers.length - 1 &&
                          _controllers.length < 3) {
                        _controllers.add(TextEditingController());
                      }
                      setState(() {});
                    },
                  ),
                  if (_controllers[index].text.trim().isNotEmpty)
                    DropdownButton(
                      isExpanded: true,
                      hint:
                          Text("${allTranslations.text('Level Of')} ${_controllers[index].text} ${allTranslations.text('Language')}"),
                      icon: Icon(Icons.keyboard_arrow_down),
                      value: _selectedLanguageLevel[
                          _languageLevel.keys.elementAt(index)],
                      onChanged: (value) {
                        _selectedLanguageLevel[
                            _languageLevel.keys.elementAt(index)] = value;
                        setState(() {});
                      },
                      items: List<DropdownMenuItem>.generate(
                          _languageLevel.length, (index) {
                        return DropdownMenuItem(
                          value: _languageLevel.keys.elementAt(index),
                          child: Text(
                            _languageLevel.values.elementAt(index),
                          ),
                        );
                      }),
                    ),
                ],
              );
            }),
            SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(allTranslations.text("Upload Your CV")),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      color: Color(0xff707070)),
                  child: Text(
                    allTranslations.text("Upload"),
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 32,
            ),
            InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => WuzzefHome()));
              },
              child: Container(
                alignment: Alignment.center,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 13),
                decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    color: DataProvider().primary),
                child: Text(
                  allTranslations.text( "Next"),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
