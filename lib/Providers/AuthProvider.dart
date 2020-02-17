import 'dart:convert' as JSON;
import 'dart:convert';
import 'dart:io';
import 'package:big/Providers/languageProvider.dart';
import 'package:big/Screens/login.dart';
import 'package:big/model/User.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'MainProvider.dart';
import 'package:big/Providers/DataProvider.dart';

String customerAuth = "/auth/customer/";
String registerUrl = MainProvider().baseUrl + customerAuth + "register";
String phoneVerifyUrl = MainProvider().baseUrl + customerAuth + "message";
String loginUrl = MainProvider().baseUrl + customerAuth + "login";
String changePasswordUrl = MainProvider().baseUrl + "/customer/change_password";
String editAccountUrl = MainProvider().baseUrl + customerAuth + "update?Auth";
String customerDeviceURL = MainProvider().baseUrl + customerAuth + "device";
String intro = MainProvider().baseUrl + customerAuth + "intro";
String deviceRegister = MainProvider().baseUrl + customerAuth + "deviceReg";
String setFirstUrl = MainProvider().baseUrl + customerAuth + "setFirst";
String setLngUrl = MainProvider().baseUrl + customerAuth + "setLan";

class AuthProvider with ChangeNotifier {
  BuildContext context;

/////////////////////////////////Google Auth Login/////////////////////////////////////////////////
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email','https://www.googleapis.com/auth/contacts.readonly',]);
  Future googleLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await _googleSignIn.signIn();
      String googleUsermail = _googleSignIn.currentUser.email;
      String googleUserImage = _googleSignIn.currentUser.photoUrl;
      String googleUserName = _googleSignIn.currentUser.displayName;
      await prefs.setString('userName', googleUserName);
      await prefs.setString('userEmail', googleUsermail);
      await prefs.setString('userImage', googleUserImage);
      notifyListeners();
    } catch (err) {
      prefs.clear();
      print(err);
    }
  }

  googleLogout() {
    _googleSignIn.signOut();
  }

///////////////////////////////Facebook Auth Login/////////////////////////////////////////
  Map userProfile;
  final facebookLogin = FacebookLogin();

  Future loginWithFB() async {
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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userName', fBUsrName);
        await prefs.setString('userEmail', fBUesrMail);
        await prefs.setString('userImage', fBUserImage);

        break;
      case FacebookLoginStatus.cancelledByUser:
        BuildContext context;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
        break;
      case FacebookLoginStatus.error:
        break;
    }
  }

  logoutFace() {
    facebookLogin.logOut();
    notifyListeners();
  }

  ///////////////////////////////////////////Device token//////////////////////////////////////////////////////
  //get device token
  Future<List<String>> getDeviceDetails() async {
    String deviceName;
    String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceName = build.model;
      deviceVersion = build.version.toString();
      identifier = build.androidId; //UUID for Android
    } else if (Platform.isIOS) {
      var data = await deviceInfoPlugin.iosInfo;
      deviceName = data.name;
      deviceVersion = data.systemVersion;
      identifier = data.identifierForVendor; //UUID for iOS
    }
//if (!mounted) return;
//    return [deviceName, deviceVersion, identifier];
    return [identifier];
  }

////////////////////////////////////////////Normal Login & Register////////////////////////////////////////////////////////////
  Future register(User user) async {
   var mybody= {
      'name': user.getName(),
      'email': user.getEmail(),
      'type': user.getType(),
      'device_id': user.getdeviceId(),
    };
     if(user.type=="normal"){
        mybody['password'] = user.getPassword();
        mybody["phone"]= user.getPhone();
        mybody['code']= user.getCode();
        mybody["phone_country"]= user.getPhoneCountry();
       }
      else
      {
        if(user.getPhone() != null)
        {
          mybody["phone"]= user.getPhone();
          mybody['code']= user.getCode();
          mybody["phone_country"]= user.getPhoneCountry();
        }
      }
    //  print(mybody);
    Response response = await post(registerUrl,body: mybody);
    int statusCode = response.statusCode;
    String body = response.body;
    print("regist $body");
    return body;
  }
//
//  Future registerFG(User user) async {
//    Response response = await post(registerUrl, body: {
//      'name': user.getName(),
//      'email': user.getEmail(),
//      'code': user.getCode(),
//      'type': user.getType(),
//      'device_id': user.getdeviceId(),
//      "phone": user.getPhone(),
//      "phone_country": user.getPhoneCountry()
//    });
//    int statusCode = response.statusCode;
//    String body = response.body;
//    return body;
//  }

  Future phoneVerify(User user) async {
    Response response = await post(phoneVerifyUrl, body: {
      "phone": user.getPhone(),
      "phone_country": user.getPhoneCountry()
    });
    int statusCode = response.statusCode;
    String body = response.body;
  }

  Future<String> login(String type, String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response response = await http.post(loginUrl, body: {
      'email': email,
      'password': password,
      'type': type,
    });
    // await prefs.setString('cookie', response.headers["set-cookie"]);
    int statusCode = response.statusCode;
//save in local storge for take all data from user
    var body = json.decode(response.body);

    return response.body;
  }

  Future<String> loginfb(String type, String email) async {
    Response response = await http.post(loginUrl, body: {
      'email': email,
      'type': type,
    });
    int statusCode = response.statusCode;
//save in local storge for take all data from user
    var body = json.decode(response.body);

    return response.body;
  }

  //////////////////////////////edit Profile/////////////////////////////////////////
  Future<String> changePassword(
      String currentPassword, String newPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    Map<String, String> body = {
      'current_password': currentPassword,
      'new_password': newPassword
    };
    String jsonBody = json.encode(body);
    Response response =
        await http.post(changePasswordUrl, body: jsonBody, headers: headers);
    int statusCode = response.statusCode;
    var s = json.decode(response.body);
    return response.body;
  }

  Future<String> editAccount(String name, String email, [File image]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');
    var request = http.MultipartRequest("POST", Uri.parse(editAccountUrl));
    request.headers['Authorization'] = 'Bearer $UserToken';
    request.fields["name"] = name;
    request.fields["email"] = email;
    //create multipart using filepath, string or bytes
    if (image != null) {
      var pic = await http.MultipartFile.fromPath("avatar", image.path);
      //add multipart to request
      request.files.add(pic);
    }
    var response = await request.send();
    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    return responseString;
  }

  Future customerDevice(String firebaseToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    var x = await getDeviceDetails();
    Response response = await post(customerDeviceURL,
        body:
            json.encode({"device_id": x[0], "registration_id": firebaseToken}),
        headers: headers);
  }

  Future<bool> introduction(LanguageProvider model,DataProvider dataProvider) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'device': (await AuthProvider().getDeviceDetails())[0],
            'Content-Type': 'application/json',

    };
    if (prefs.containsKey('userToken')) {
      var UserToken = await prefs.getString('userToken');
      headers['Authorization'] = "Bearer $UserToken";
    }
    var response = await http.get(
      intro,
      headers: headers,
    );
        print(headers);
    print(intro);
    print(response.body);

    var body = json.decode(response.body);
    print(body);
    if (body['data']["user"] != null) {
      await prefs.setString('userName', body['data']["user"]["name"]);
      await prefs.setString('userEmail', body['data']["user"]["email"]);
      await prefs.setString('userImage', body['data']["user"]["avatar"]);
      await prefs.setString('phone', body['data']["user"]["phone"]);
      await prefs.setString(
          'country_code', body["data"]["user"]["country_code"]);
          dataProvider.cartCounter=body["data"]["qty"];
    }
    if (body['data']["language"] != null) {
      await model.setLang(body['data']["language"]);
    }

    if(!(body['data']['isFirst'])&&body['data']["language"] == null){
      await model.setLang("en");
    }
    
    return body['data']['isFirst'];
  }

  Future deviceReg() async {
    Map<String, String> headers = {
      'device': (await AuthProvider().getDeviceDetails())[0],
            'Content-Type': 'application/json',

    };
    var res = await http.post(
      deviceRegister,
      headers: headers,
    );
    print(res.body);
    print("lllllllll");
  }

  Future setFirst() async {
    Map<String, String> headers = {
      'device': (await AuthProvider().getDeviceDetails())[0],
            'Content-Type': 'application/json',

    };
    await http.post(
      setFirstUrl,
      headers: headers,
    );
  }

  Future setLanguage(String language) async {
    Map<String, String> headers = {
      'device': (await AuthProvider().getDeviceDetails())[0],
            'Content-Type': 'application/json',

    };
    await http.post(setLngUrl,
        headers: headers, body: json.encode({'language': language}));

  }
 Future sendPhone(String countryCode,String phone) async {
    var response = await http.post(MainProvider().baseUrl +'/auth/customer/message',
        body: {"phone_country": countryCode, "phone": phone});
    print("myphone_country is $countryCode and phone is $phone ");
    print(response.body);
    return response.body;
  }
}
