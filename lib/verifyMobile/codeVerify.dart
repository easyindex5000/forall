import 'dart:async';
import 'dart:convert';

import 'package:big/Providers/AuthProvider.dart';
import 'package:big/Screens/register.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/localization/all_translations.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../componets/shopping_icons.dart';
import '../Providers/DataProvider.dart';
import './details.dart';
import 'package:big/model/User.dart';
import 'package:provider/provider.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class CodeVerifity extends StatefulWidget {
  final User userdata;

  CodeVerifityState createState() => CodeVerifityState(userdata: userdata);
  CodeVerifity({Key key, @required this.userdata}) : super(key: key);
}

class CodeVerifityState extends State<CodeVerifity> {
  final _formKey = GlobalKey<FormState>();

  bool hasError = false;
  User userdata;
  var data;
  CodeVerifityState({Key key, @required this.userdata});
  TextEditingController number1 = new TextEditingController();
  TextEditingController number2 = new TextEditingController();
  TextEditingController number3 = new TextEditingController();
  TextEditingController number4 = new TextEditingController();
  TextEditingController codeController = new TextEditingController();
bool resend=false;
  var counter = 60;
  @override
  void initState() {
    print(userdata.toJson());
    TimerResend();
    super.initState();
  }
@override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => User(),
        child: Consumer<User>(
          builder: (context, user, _) {
            return Material(
                child: Scaffold(
                    appBar: AppBar(
                      title: Text(allTranslations.text("Sign up"),
                          style: TextStyle(color: DataProvider().primary)),
                    ),
                    body: Container(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                allTranslations.text(
                                    "Confirmation code has been sent to you"),
                                style: TextStyle(color: DataProvider().primary),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Form(
                                  key: _formKey,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      buildContainer(number1),
                                      buildContainer(number2),
                                      buildContainer(number3),
                                      buildContainer(number4),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width * .8,
                                  height: MediaQuery.of(context).size.height * .08,
                                  child: RaisedButton(
                                      color: DataProvider().primary,
                                      child: Text(allTranslations.text('Submit'),
                                          style: TextStyle(color: Colors.white)),
                                      onPressed: () async {
//                                        if(!_formKey.currentState.validate()){
//                                          Toast.show(allTranslations.text("put valid input"), context);
//                                          return ;
//                                        }
                                        userdata.setcodeuser(number1.text+number2.text+number3.text+number4.text);
                                        print("mycode ${number1.text+number2.text+number3.text+number4.text}");
                                        print("a7a ${userdata.toJson()}");
                                        await AuthProvider().register(userdata).then((res) async {
                                          data = json.decode(res);
                                       
;                                          if (data["success"] == true) {
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            await prefs.setString('userToken', data["data"]["token"]);
                                            await prefs.setString('userName', data["data"]["user"]["name"]);
                                            await prefs.setString('userEmail', data["data"]["user"]["email"]);
                                            await prefs.setString('phone', data["data"]["user"]["phone"]);
                                            await prefs.setString('country_code', data["data"]["user"]["country_code"]);
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => CodeTrue()),
                                            );
                                          } //handling errors
                                          else if (data["success"] == false) {
                                            String error = data["errors"].toString();
                                            Toast.show(error, context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            prefs.clear();
                                          //   Navigator.pop(context, MaterialPageRoute(builder: (context) => RegisterPage()),);
                                          }
                                        });
                                      })),
                              if(resend)
                              Container(
                                child: OutlineButton(
                                  child: Text("Resend"),
                                  onPressed: (){
                                    AuthProvider().sendPhone(userdata.getPhoneCountry(), userdata.getPhone());
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )));
          },
        ));
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
        keyboardType: TextInputType.text,
      ),
    );
  }
  TimerResend()  {
    Timer.periodic(Duration(seconds: 20), (Timer timer){
      setState(() {
      resend=true;
      });
      timer.cancel();
    });
    return true;
  }
}
