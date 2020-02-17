import 'dart:core' as prefix0;
import 'dart:core';

import 'package:flutter/foundation.dart';

List<String> status = ['normal','facebook','google'];
 class User with ChangeNotifier {
  String name;
  String email;
  String password;
  String phone;
  String phoneCountry;
  String type;
  String deviceId;
  String code;
  String image;

  User(
      {this.name,
      this.email,
      this.password,
      this.phoneCountry,
      this.phone,
      this.code,
      this.deviceId,
      this.type,
      this.image
      });

  getName() => name;

  void setnameuser(String newValue) {
    name = newValue;
    notifyListeners();
  }

 getImage() => image;

  void setuserImage(String newValue) {
    image = newValue;
    notifyListeners();
  }
  getEmail() => email;

  void setemailuser(String newValue) {
    email = newValue;
    notifyListeners();
  }

  getPassword() => password;
  void setpassworduser(String newPassword) {
    password = newPassword;
    notifyListeners();
  }

   getPhone() => phone;
  void setphoneuser(String newPhone) {
    phone = newPhone;
    notifyListeners();
  }

  getPhoneCountry() => phoneCountry;
  void setphoneCountryuser(String newPhoneCountry) {
    phoneCountry = newPhoneCountry;
    notifyListeners();
  }

  String getCode() => code;
  void setcodeuser(String newvalue) {
    code = newvalue;
    notifyListeners();
  }

  getType() => type;
 void settypeuser(String newvalue) {
    type = newvalue;
    notifyListeners();
  }

  getdeviceId() => deviceId;
  void setdeviceIduser(String newvalue) {
    deviceId = newvalue;
    notifyListeners();
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
      password: json['password'],
      phoneCountry: json['phone_country'],
      phone: json['phone'],
      type: json['type'],
      code: json['code'],
      deviceId: json['device_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'phone_country': phoneCountry,
        'phone': phone,
        'code':code,
        'type':type,
        'device_id':deviceId
      };
  notifyListeners();
}
