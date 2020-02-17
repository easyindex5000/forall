import 'dart:convert';

import 'package:big/Providers/AuthProvider.dart';
import 'package:big/Providers/ColorsProvider.dart';
import 'package:big/Providers/DataProvider.dart';
import 'package:big/Screens/OnlineStoreHomeScreen.dart';
import 'package:big/Screens/ForAllHome.dart';
import 'package:big/componets/Loading.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  Color danger = DataProvider().primary;
  Color danger2 = DataProvider().primary;
  String changePassword = allTranslations.text('changePassword');
  String currentPassword = allTranslations.text('currentPassword');
  String newPassword = allTranslations.text('newPassword');
  String confirmPassword = allTranslations.text('confirmPassword');
  String updatePassword = allTranslations.text('updatePassword');
  TextEditingController oldPasswordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  double hieghtAll = 20.0;
  final _formKey = GlobalKey<FormState>();
  bool securePassword=true,securePassword2 = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Mybar("$changePassword", false),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: hieghtAll),
                  // buildTextForm(oldPasswordController, "$currentPassword",
                  //     "$currentPassword", null, null, true),
                  TextFormField(
                    controller: oldPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: currentPassword,
                    ),
                    keyboardType: TextInputType.text,
                    autovalidate: true,
                    validator: (value){
                      if(value.isEmpty){
                        return null;
                      }
                      else if(value.length<8){
                        return "Please Enter more than 8 ";
                      }
                      else return null;
                    },
                  ),

                  SizedBox(height: hieghtAll),
                  // buildTextForm(newPasswordController, "$newPassword",
                  //     "$newPassword", null, null, true),
                  TextFormField(
                    obscureText: securePassword,
                    controller: newPasswordController,
                    maxLength: 32,
                    autovalidate: true,
                    validator: (value){
                      if(value.isEmpty){
                        return null;
                      }
                      else if(value.length<8){
                        return "Please Enter more than 8 ";
                      }
                      else return null;
                    },
                    decoration: InputDecoration(
                      counterText: "",
                      labelText: newPassword,
                      suffixIcon: new IconButton(
                        icon: new Icon(Icons.remove_red_eye, color: danger),
                        onPressed: () {
                          if (danger == DataProvider().primary) {
                            setState(() {
                              danger = Colors.red;
                            });
                          } else if (danger == Colors.red) {
                            setState(() {
                              danger = DataProvider().primary;
                            });
                          }
                          bool viewHide = securePassword == true ? false : true;
                          securePassword = viewHide;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: hieghtAll),
                  // buildTextForm(confirmPasswordController, "$confirmPassword",
                  //     "$confirmPassword", null, null, true),
                  TextFormField(
                    obscureText: securePassword2,
                    controller: confirmPasswordController,
                    maxLength: 32,
                    autovalidate: true,
                    validator: (value){
                      if(value.isEmpty){
                        return null;
                      }
                      else if(value.length<8){
                        return "Please Enter more than 8 ";
                      }
                      else return null;
                    },
                    decoration: InputDecoration(
                      counterText: "",
                      labelText: confirmPassword,
                      suffixIcon: new IconButton(
                        icon: new Icon(Icons.remove_red_eye, color: danger2),
                        onPressed: () {
                          if (danger2 == DataProvider().primary) {
                            setState(() {
                              danger2 = Colors.red;
                            });
                          } else if (danger2 == Colors.red) {
                            setState(() {
                              danger2 = DataProvider().primary;
                            });
                          }
                          bool viewHide = securePassword2 == true ? false : true;
                          securePassword2 = viewHide;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: hieghtAll),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      width: double.infinity,
                      height: 50.0,
                      child: RaisedButton(
                        onPressed: ()async {
                          if (confirmPasswordController.text ==
                              newPasswordController.text) {
                       await loadWidget(context,     change(oldPasswordController.text,
                                confirmPasswordController.text));
                          } else {}
                        },
                        child: Text(
                          "$updatePassword",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0),
                        ),
                        color: DataProvider().primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future change(String oldPass, String newPass) async {
    await AuthProvider().changePassword(oldPass, newPass).then((res) {
      var data = json.decode(res);

      if (data["success"] == true) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) => OnlineShoppingHome()));
        Toast.show(data["data"].toString(), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else if (data["success"] == false) {
        Toast.show(data["errors"].toString(), context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      }
    });
  }

  Container buildTextForm(TextEditingController takeInput, String oldData,
      [String sideText,
      Icon sideIcon,
      TextInputType mytype,
      bool secret = false,
      int lines,
      bool Enabled = true]) {
    return new Container(
      decoration: BoxDecoration(
        border: Border.all(color: ColorProvider().primary),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: TextFormField(
        enabled: Enabled,
        decoration: InputDecoration(
          suffixText: sideText,
          hintText: oldData,
          suffixIcon: sideIcon,
          contentPadding: EdgeInsets.all(15.0),
        ),
        obscureText: secret,
        keyboardType: mytype,
        maxLines: lines,
        controller: takeInput,
        validator: (value) {
          if (value.length < 8) {
            return 'Please enter correct Password';
          }
          return null;
        },
        style: TextStyle(
            fontWeight: FontWeight.bold, color: ColorProvider().primary),
      ),
    );
  }
}
