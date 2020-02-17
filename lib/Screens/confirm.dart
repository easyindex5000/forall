import 'package:big/Providers/DataProvider.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/localization/all_translations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import './set_NewPassword.dart';
import 'register.dart';
import 'package:big/Screens/login.dart' as login;

class ConfirmPassword extends StatefulWidget {
  ConfirmPasswordState createState() => ConfirmPasswordState();
}

class ConfirmPasswordState extends State<ConfirmPassword> {
    final _formKey = GlobalKey<FormState>();

  TextEditingController number1 = new TextEditingController();
  TextEditingController number2 = new TextEditingController();
  TextEditingController number3 = new TextEditingController();
  TextEditingController number4 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Mybar(allTranslations.text("Forgot password ?"), false),
      body: SafeArea(
        minimum: EdgeInsets.all(32.0),
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 40),
                Text(
                  allTranslations
                      .text("Confirmation code has been sent to you"),
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                SizedBox(height: 40),
                Form(
                                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      buildContainer(number1),
                      buildContainer(number2),
                      buildContainer(number3),
                      buildContainer(number4),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                ButtonTheme(
                  height: 50,
                  minWidth: MediaQuery.of(context).size.width / 1.2,
                  child: RaisedButton(
                    onPressed: () {
                        //  if(!_formKey.currentState.validate()){
                        //                   Toast.show(allTranslations.text("put valid input"), context);
                        //                   return ;
                        //                 }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SetNewPassword()));
                    },
                    child: Text(
                      allTranslations.text("Submit"),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    color: DataProvider().primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildContainer(TextEditingController CustomController) {
    return Container(
      height: 50,
      width: 50,
      decoration: new BoxDecoration(
        borderRadius: new BorderRadius.circular(50),
      ),
      child: TextFormField(
        validator: (value) {
          return value == null ||
                  value == "" ||
                  !RegExp("^[0-9]").hasMatch(value)
              ? ""
              : null;
        },
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(
            borderRadius: new BorderRadius.circular(50),
          ),
        ),
        maxLength: 1,
        controller: CustomController,
        keyboardType: TextInputType.phone,
      ),
    );
  }
}
