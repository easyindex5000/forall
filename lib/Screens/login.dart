import 'dart:convert';
import 'dart:io';
import 'package:big/Screens/OnlineStoreHomeScreen.dart';
import 'package:big/assets/fonts/wuzzef_icons.dart';
import 'package:big/componets/Loading.dart';
import 'package:big/localization/all_translations.dart';
import 'package:big/model/User.dart';
import 'package:big/verifyMobile/Verify.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:toast/toast.dart';
import 'package:big/Providers/AuthProvider.dart';
import 'package:big/Screens/forget.dart';
import 'package:big/componets/appBar.dart';
import 'package:big/componets/shopping_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Providers/DataProvider.dart';
import './register.dart';
import './forget.dart';
import 'package:big/Screens/ForAllHome.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:convert' as JSON;
import 'package:http/http.dart' as http;

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

class LoginPage extends StatefulWidget {
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String title = "${allTranslations.text('sign_in')}";
  Color danger = Colors.black;
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  Map userProfile;
  final facebookLogin = FacebookLogin();
  String deviceId;
  var data;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    
    if(Platform.isIOS){     
   //check for ios if developing for both android & ios
  AppleSignIn.onCredentialRevoked.listen((_) {
    print("Credentials revoked");
  });
}
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => User(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: Mybar(title, false),
        body: SafeArea(
          minimum: EdgeInsets.all(DataProvider().paddingApp),
          child: SingleChildScrollView(
            child: Container(
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Consumer<DataProvider>(
                          builder: (context, stateManager, _) => emailInput()),
                      SizedBox(height: 10),
                      Consumer<DataProvider>(
                        builder: (context, dataProvider, _) => TextFormField(
                          obscureText: dataProvider.securePassword,
                          controller: passwordController,
                          maxLength: 32,
                          validator: (value) {
                            if (value.length < 8) {
                              return 'Please enter Password more than 7 ';
                            }
                            return null;
                          },
//                          validator: (value),
                          decoration: InputDecoration(
                            counterText: "",
//                              enabledBorder: OutlineInputBorder(
//                                borderSide:
//                                    BorderSide(color: DataProvider().primary),
//                              ),
//                              border: OutlineInputBorder(
//                                borderRadius: new BorderRadius.circular(5.0),
//                              ),
                            // border: OutlineInputBorder(),
                            labelText: '${allTranslations.text('password')}',
                            // icon: new Icon(Icons.lock_outline),
                            suffixIcon: new IconButton(
                              icon:
                                  new Icon(Icons.remove_red_eye, color: danger),
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
                        ),
                      ),
                      SizedBox(height: 30),
                      ButtonTheme(
                        minWidth: double.infinity,
                        height: 50.0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            color: DataProvider().primary,
                          ),
                          child: Consumer<DataProvider>(
                            builder: (context, model,_) {
                              return RaisedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      //auth in api
                                 var res=await  loadWidget(context,  AuthProvider()
                                          .login(
                                              'normal',
                                              emailController.text.trim(),
                                              passwordController.text));
                                            print(res);
                                            data = json.decode(res);
                                        model.cartCounter=data['data']['qty'];
                                        if (data["success"] == true) {
                                          //save name & email & image & token and navigate to home page

                                          goHome();
                                        } //handling errors
                                        else if (data["success"] == false) {
                                          Toast.show(
                                              allTranslations.text(
                                                  "Email and Password do not match"),
                                              context,
                                              duration: Toast.LENGTH_LONG,
                                              gravity: Toast.BOTTOM);
                                        }
                                      
                                    }
                                  },
                                  child: Text(
                                    allTranslations.text("sign_in"),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  color: Colors.transparent);
                            }
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FlatButton(
                            child: Text(
                              "${allTranslations.text('forgetpasword')}",
                              style: TextStyle(
                                  color: DataProvider().primary,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgetPassword()),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text('${allTranslations.text("orsignin")}',
                          style: TextStyle(
                             fontSize: 18),textAlign: TextAlign.center,),
                      SizedBox(height: 35),
                   
                      Consumer<User>(builder: (context, snapshot, _) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                                Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(50.0)),
                                  border: new Border.all(
                                    color: DataProvider().primary,
                                    width: 2.0,
                                  ),
                                ),
                                child: Consumer<DataProvider>(
                                  builder: (context, model,_) {
                                    return IconButton(
                                      padding: EdgeInsets.all(0.0),
                                      alignment: Alignment.center, iconSize: 20,
                                      icon: Icon(Shopping.facebook,
                                          color: Colors.blueAccent),
                                      onPressed: () async {
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
                                        final result = await facebookLogin.logIn(['email']);
                                        switch (result.status) {
                                          case FacebookLoginStatus.loggedIn:
                                            final token = result.accessToken.token;
                                            final graphResponse = await http.get('https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
                                            final profile = JSON.jsonDecode(graphResponse.body);
                                            String fBUsrName = profile['name'];
                                            String fBUesrMail = profile['email'];
                                            String fBUserImage = profile['picture']['data']['url'];
                                           
                                            // await prefs.setString('userName', fBUsrName);
                                            // await prefs.setString('userEmail', fBUesrMail);
                                            // await prefs.setString('userImage', fBUserImage);
                                            await AuthProvider().getDeviceDetails().then((res){
                                              deviceId=res[0];
                                            });
                                            var myuser=snapshot;
                                            myuser.setnameuser(fBUsrName);
                                            myuser.setemailuser(fBUesrMail);
                                            myuser.settypeuser('facebook');
                                            myuser.setdeviceIduser(deviceId);
                                            myuser.setuserImage(fBUserImage);
                                          var res=await loadWidget(context, AuthProvider().register(myuser));
                                          res=json.decode(res);
                                          print("KKKKKK$res");
                                          model.cartCounter=res['data']['qty']??0;
                                          if(res['data']['register']==false){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>Verify(newuser: myuser)));
                                          }
                                          else{
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>OnlineShoppingHome()));
                                             await prefs.setString("userToken", res["data"]["token"]);

                                          }
                                            break;
                                          case FacebookLoginStatus.cancelledByUser:
                                            BuildContext context;
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                                           
                                            break;
                                          case FacebookLoginStatus.error:
                                            break;
                                        }
                                        
                                      },
                                    );
                                  }
                                )),
                         if(Platform.isIOS)  SizedBox(width: 30),
                          if(Platform.isIOS) Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(50.0)),
                                  border: new Border.all(
                                    color: DataProvider().primary,
                                    width: 2.0,
                                  ),
                                ),
                                child: Consumer<DataProvider>(
                                  builder: (context, model,_) {
                                    return IconButton(
                                      padding: EdgeInsets.all(0.0),
                                      alignment: Alignment.center, iconSize: 20,
                                      icon: Icon(Wuzzef.brands_and_logotypes,
                                          color: Colors.black,size: 26,),
                                      onPressed:(){
                                        appleLogIn(model);},
                                    );
                                  }
                                )),
                            SizedBox(width: 30),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
                                border: new Border.all(color: DataProvider().primary, width: 2.0),
                              ),
                              child: Consumer<DataProvider>(
                                builder: (context, model,_) {
                                  return IconButton(
                                    padding: EdgeInsets.all(0.0),
                                    alignment: Alignment.center,
                                    iconSize: 20,
                                    icon: Icon(Shopping.google, color: Colors.red,),
                                    onPressed: () async {
                                      //call google model
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      AuthProvider().googleLogin().then((res) async {
                                        if (prefs.containsKey('userEmail')) {
                                          // call storage to get data has been set before
                                          var googleName = prefs.getString('userName');
                                          var googleEmail = prefs.getString('userEmail');
                                          //get device Id
                                          String deviceId;
                                          await AuthProvider().getDeviceDetails().then((res) {
                                            deviceId = res[0];
                                          });
                                          var myuser = snapshot;
                                          myuser.setnameuser(googleName);
                                          myuser.setemailuser(googleEmail);
                                          myuser.settypeuser('google');
                                          myuser.setdeviceIduser(deviceId);
                                         var res= await AuthProvider().register(myuser);
                                           
                                              res = json.decode(res);
                                              if(res["data"]["register"]==false){
                                             Navigator.push(context, MaterialPageRoute(builder: (context) => Verify(newuser: myuser)));
                                              }
                                              else{
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => OnlineShoppingHome()));
                                            var t= await prefs.setString("userToken", res["data"]["token"]);
                                            model.cartCounter=res['data']['qty']??0;
                                            print(t);
                                              }
                                              print("regist ${res}");
                                        } else {
                                          AuthProvider().googleLogout();
                                          prefs.clear();
                                        }
                                      });
                                    },
                                  );
                                }
                              ),
                            ),
                          ],
                        );
                      }),
                      new LoginScondButton()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
Future appleLogIn(model)async{
  if(await AppleSignIn.isAvailable()) {
      //Check if Apple SignIn isn available for the device or not
       final AuthorizationResult result = await                                             
     AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])]);
      String s = new String.fromCharCodes(result.credential.identityToken);
      print("my email ${result.credential.email} my name ${result.credential.fullName.givenName+' '+result.credential.fullName.familyName} my userId ${result.credential.user}");
      User myuser=User();
      await AuthProvider().getDeviceDetails().then((res){deviceId=res[0];});
      myuser.setnameuser('${result.credential.fullName.givenName}+' '+${result.credential.fullName.familyName}');
      myuser.setemailuser("${result.credential.email}");
      myuser.settypeuser("apple");
      myuser.setdeviceIduser(deviceId);
   await loadWidget(context, AuthProvider().register(myuser));
   var res=    await AuthProvider().register(myuser);
                                           SharedPreferences prefs = await SharedPreferences.getInstance();

       switch (result.status) {
    case AuthorizationStatus.authorized:                                     
      print(result.credential.user);//All the required credentials
      print(res);
      print("&****");
        res = json.decode(res);
      if(res["success"]==false){
      Navigator.push(context, MaterialPageRoute(builder: (context) => Verify(newuser: myuser)));
      }
      else{
    Navigator.push(context, MaterialPageRoute(builder: (context) => OnlineShoppingHome()));
    var t= await prefs.setString("userToken", res["data"]["token"]);
    model.cartCounter=res['data']['qty']??0;
    print(t);
      }
       break;
    case AuthorizationStatus.error:
      print("Sign in failed: ${result.error.localizedDescription}");
      break;
    case AuthorizationStatus.cancelled:
      print('User cancelled');
      break;
  }
     print("my email ");
}else{
    print('Apple SignIn is not available for your device');
}
}
  String _validateEmail(String value) {
    if (value.isEmpty) {
      // The form is empty
      return null;
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

  Future goHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', data["data"]["token"]);
    await prefs.setString('userName', data["data"]["user"]["name"]);
    await prefs.setString('userEmail', data["data"]["user"]["email"]);
    await prefs.setString('userImage', data["data"]["user"]["avatar"]);
    await prefs.setString('phone', data["data"]["user"]["phone"]);
    await prefs.setString('country_code', data["data"]["user"]["country_code"]);

    await _firebaseMessaging.getToken().then((token) {
      AuthProvider().customerDevice(token);
    });
    // await Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => new HomePage()));
    Navigator.pop(context);
  }

  Future savetoken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userToken', data["data"]["token"]);
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => OnlineShoppingHome()));
  }

  TextFormField emailInput() {
    return TextFormField(
      decoration: InputDecoration(
//        enabledBorder: OutlineInputBorder(
//          borderSide: BorderSide(color: DataProvider().primary),
//        ),
//        border: OutlineInputBorder(
//          borderRadius: new BorderRadius.circular(5.0),
//        ),
        labelText: '${allTranslations.text('email')}',
        // icon: new Icon(Icons.email),
      ),
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      validator: _validateEmail,
      autovalidate: true,
    );
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
                "${allTranslations.text("dont_account")} ${allTranslations.text("sign_up")}",
            style: TextStyle(
                color: DataProvider().primary,
                decoration: TextDecoration.underline),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterPage()),
          );
        },
      ),
    );
  }
}
