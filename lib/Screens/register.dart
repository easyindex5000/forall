import 'package:big/Providers/AuthProvider.dart';
import 'package:big/Providers/MainProvider.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/componets/shopping_icons.dart';
import 'package:big/localization/all_translations.dart';
import 'package:big/verifyMobile/Verify.dart';
import 'package:big/verifyMobile/codeVerify.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import '../Providers/DataProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './login.dart';
import 'dart:convert';
import 'package:big/model/User.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String title = '${allTranslations.text('sign_up')}';
  Color danger = Colors.black;
  Color danger2 = Colors.black;
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController ConfirmPasswordController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  bool botton = true;
  String phoneCountry = "EG";
  void _onCountryChange(CountryCode countryCode) {
    setState(() {
      phoneCountry = countryCode.code.toString();
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => User(),
          )
        ],
        child: Consumer<User>(builder: (context, user, _) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: Text(
                title,
                style: TextStyle(color: Colors.black),
              ),
              leading: SizedBox(),
            ),
            body: SafeArea(
              minimum: EdgeInsets.all(DataProvider().paddingApp),
              child: SingleChildScrollView(
                child: Container(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Consumer<DataProvider>(
                              builder: (context, stateManager, _) =>
                                  new Nameinput(nameController: nameController),
                            ),
                            Consumer<DataProvider>(
                              builder: (context, stateManager, _) =>
                                  new EmailInput(
                                      emailController: emailController),
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 3,
                                  child: new CountryCodePicker(
                                    onChanged: _onCountryChange,
                                    initialSelection: 'SA',
                                    favorite: ['+966','SA','+20', 'EG'],
                                    showCountryOnly: false,
                                    alignLeft: false,
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: TextFormField(
                                    controller: phoneController,
                                    maxLength: 20,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        // The form is empty
                                        return "Please Enter valid phone";
                                      } else
                                        return null;
                                    },
                                    decoration: InputDecoration(
                                      counterText: "",
                                      hintText: "",
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Consumer<DataProvider>(
                              builder: (context, dataProvider, _) =>
                                  TextFormField(
                                obscureText: dataProvider.securePassword,
                                controller: passwordController,
                                maxLength: 32,
                                decoration: InputDecoration(
                                  counterText: "",
                                  hintText: "Password",
//                                    labelText: '${allTranslations.text('password')}',
//                            labelStyle: TextStyle(fontSize: 23),
                                  suffixIcon: new IconButton(
                                    icon: new Icon(Icons.remove_red_eye,
                                        color: danger),
                                    onPressed: () {
                                      if (danger == Colors.black) {
                                        setState(() {
                                          danger = Colors.red;
                                        });
                                      } else if (danger == Colors.red) {
                                        setState(() {
                                          danger = Colors.black;
                                        });
                                      }
                                      bool viewHide =
                                          dataProvider.securePassword == true
                                              ? false
                                              : true;
                                      dataProvider.securePassword = viewHide;
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value.length < 8) {
                                    return 'Please enter Password more than 8 ';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Consumer<DataProvider>(
                              builder: (context, dataProvider, _) =>
                                  TextFormField(
                                obscureText: dataProvider.securePassword2,
                                controller: ConfirmPasswordController,
                                maxLength: 32,
                                autovalidate: false,
                                decoration: InputDecoration(
                                  counterText: "",
                                  hintText: "Confirm Password",
//                                    labelText: '${allTranslations.text('password')}',
//                            labelStyle: TextStyle(fontSize: 23),
                                  suffixIcon: new IconButton(
                                    icon: new Icon(Icons.remove_red_eye,
                                        color: danger2),
                                    onPressed: () {
                                      if (danger2 == Colors.black) {
                                        setState(() {
                                          danger2 = Colors.red;
                                        });
                                      } else if (danger2 == Colors.red) {
                                        setState(() {
                                          danger2 = Colors.black;
                                        });
                                      }
                                      bool viewHide =
                                          dataProvider.securePassword2 == true
                                              ? false
                                              : true;
                                      dataProvider.securePassword2 = viewHide;
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value.length < 8) {
                                    return 'Please enter Password more than 8 ';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 20),
                            new SignUPButton(
                              nameController: nameController,
                              title: title,
                              navigate: () async {
                                if (_formKey.currentState.validate() &&
                                    passwordController.text ==
                                        ConfirmPasswordController.text) {
                                  String deviceId;
                                  await AuthProvider()
                                      .getDeviceDetails()
                                      .then((res) {
                                    deviceId = res[0];
                                  });
                                  var myuser = Provider.of<User>(context);
                                  myuser
                                      .setnameuser(nameController.text.trim());
                                  myuser.setemailuser(
                                      emailController.text.trim());
                                  myuser.setpassworduser(
                                      passwordController.text.trim());
                                  myuser.setphoneuser(
                                      phoneController.text.trim());
                                  myuser.setphoneCountryuser(phoneCountry);
                                  myuser.settypeuser('normal');
                                  myuser.setdeviceIduser(deviceId);
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString('userImage',
                                      "https://cdn0.iconfinder.com/data/icons/avatar-78/128/12-512.png");
                                  await AuthProvider().sendPhone(
                                      phoneCountry, phoneController.text);
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CodeVerifity(userdata: myuser)));
                                }
                              },
                            ),
//                            SizedBox(height: 20),
//                            Text('${allTranslations.text('orsignup')}',
//                                style: TextStyle(
//                                    color: DataProvider().primary,
//                                    fontSize: 18)),
                            SizedBox(height: 25),
//                            Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                Container(
//                                    width: 50,
//                                    height: 50,
//                                    decoration: BoxDecoration(
//                                      borderRadius: new BorderRadius.all(
//                                          new Radius.circular(50.0)),
//                                      border: new Border.all(
//                                        color: DataProvider().primary,
//                                        width: 2.0,
//                                      ),
//                                    ),
//                                    child: IconButton(
//                                      padding: EdgeInsets.all(0.0),
//                                      alignment: Alignment.center, iconSize: 20,
//                                      icon: Icon(Shopping.facebook, color: DataProvider().primary),
////                                    onPressed: ()async {
////                                      AuthProvider().loginWithFB();
////                                    }
//                                      onPressed: () async {
//                                        SharedPreferences prefs = await SharedPreferences.getInstance();
//                                        AuthProvider().loginWithFB().then((res) async {
//                                          if (prefs.containsKey('userEmail')) {
//                                            // call storage to get data has been set before
//                                            var facebookName = prefs.getString('userName');
//                                            var facebookEmail = prefs.getString('userEmail');
//                                            //get device Id
//                                            String deviceId;
//                                            await AuthProvider().getDeviceDetails().then((res) {
//                                              deviceId = res[0];
//                                            });
//                                            var myuser = Provider.of<User>(context);
//                                            myuser.setnameuser(facebookName);
//                                            myuser.setemailuser(facebookEmail);
//                                            myuser.settypeuser('facebook');
//                                            myuser.setdeviceIduser(deviceId);
//                                            await Navigator.push(context,
//                                             MaterialPageRoute(builder: (context) => Verify(newuser: myuser)));
//                                          } else {
//                                            AuthProvider().logoutFace();

//                                        });
//                                      },
//                                    )),
//                                SizedBox(width: 30),
//                                Container(
//                                  width: 50,
//                                  height: 50,
//                                  decoration: BoxDecoration(
//                                    borderRadius: new BorderRadius.all(
//                                        new Radius.circular(50.0)),
//                                    border: new Border.all(
//                                        color: DataProvider().primary,
//                                        width: 2.0),
//                                  ),
//                                  child: IconButton(
//                                    padding: EdgeInsets.all(0.0),
//                                    alignment: Alignment.center,
//                                    iconSize: 20,
//                                    icon: Icon(Shopping.google,
//                                        color: DataProvider().primary),
//                                    //onPressed: //() async{
//                                    //await   AuthProvider().googleLogin();
//                                    //await  Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
//                                    //}
//                                    onPressed: () async {
//                                      //call google model
//                                      SharedPreferences prefs =
//                                          await SharedPreferences.getInstance();
//                                      AuthProvider()
//                                          .googleLogin()
//                                          .then((res) async {
//                                        if (prefs.containsKey('userEmail')) {
//                                          // call storage to get data has been set before
//                                          var googleName =
//                                              prefs.getString('userName');
//                                          var googleEmail =
//                                              prefs.getString('userEmail');
//                                          //get device Id
//                                          String deviceId;
//                                          await AuthProvider().getDeviceDetails().then((res) {
//                                            deviceId = res[0];
//                                          });
//                                          var myuser = Provider.of<User>(context);
//                                          myuser.setnameuser(googleName);
//                                          myuser.setemailuser(googleEmail);
//                                          myuser.settypeuser('google');
//                                          myuser.setdeviceIduser(deviceId);
//                                          await Navigator.push(context, MaterialPageRoute(builder: (context) =>
//                                                      Verify(newuser: myuser)));
//                                        } else {
//                                          AuthProvider().googleLogout();

//                                      });
//                                    },
//                                  ),
//                                ),
//                              ],
//                            ),
                            new LoginScondButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }));
  }
}

class LoginScondButton extends StatelessWidget {
  const LoginScondButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      child: FlatButton(
        child: Text.rich(
          TextSpan(
            text:
                "${allTranslations.text('already_account')} ${allTranslations.text('sign_in')}",
            style: TextStyle(
                color: DataProvider().primary,
                decoration: TextDecoration.underline),
          ),
        ),
        onPressed: () {
          Navigator.pop(context);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => LoginPage()),
          // );
        },
      ),
    );
  }
}

class SignUPButton extends StatelessWidget {
  SignUPButton({
    Key key,
    @required this.nameController,
    @required this.title,
    @required this.navigate,
  }) : super(key: key);
  String title;
  Function navigate;
  final TextEditingController nameController;
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: double.infinity,
      height: 50.0,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            color: DataProvider().primary),
        child: RaisedButton(
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          onPressed: navigate,
          color: Colors.transparent,
        ),
      ),
    );
  }
}

class EmailInput extends StatelessWidget {
  // final String addBag = allTranslations.text('add_bag');
  const EmailInput({
    Key key,
    @required this.emailController,
  }) : super(key: key);
  final TextEditingController emailController;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
//        enabledBorder: OutlineInputBorder(
//          borderSide: BorderSide(color: DataProvider().primary),
//        ),
//        border: OutlineInputBorder(
//          borderRadius: new BorderRadius.circular(5.0),
//        ),
        labelText: '${allTranslations.text('email')}',
//        labelStyle: TextStyle(fontSize: 23),
      ),
      validator: _validateEmail,
      autovalidate: false,
      onSaved: (value) {},
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
    );
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      // The form is empty
      return "Please Enter valid email address";
    }
    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      // So, the email is valid
      return null;
    }

    // The pattern of the email didn't match the regex above.
    return 'Email is not valid';
  }
}

class Nameinput extends StatelessWidget {
  const Nameinput({
    Key key,
    @required this.nameController,
  }) : super(key: key);

  final TextEditingController nameController;
  //final String fullName ;

  //const fullName = allTranslations.text('fullName');

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
//        enabledBorder: OutlineInputBorder(
//          borderSide: BorderSide(color: DataProvider().primary),
//        ),
//        border: OutlineInputBorder(
//          borderRadius: new BorderRadius.circular(5.0),
//        ),
        labelText: '${allTranslations.text('fullName')}',
//        labelStyle: TextStyle(fontSize: 23),
      ),
      validator: (value) {
        if (value.length < 5) {
          return allTranslations.text('Please enter correct name');
        }
        return null;
      },
      onSaved: (value) {},
      controller: nameController,
      autovalidate: false,
      keyboardType: TextInputType.text,
    );
  }
}
