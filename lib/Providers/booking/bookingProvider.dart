import 'dart:convert';
import 'dart:core';
import 'package:big/Providers/DataProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MainProvider.dart';
String productApi = "/product/";
String cartGetApi="/cart";
String ProductDetailsUrl = MainProvider().baseUrl + productApi ;
String CartUrl= MainProvider().baseUrl + cartGetApi;
String promotionsUrl=MainProvider().baseUrl+"/promotions";
String faqUrl=MainProvider().baseUrl+"/questionAnswer";
class BookingProvider with ChangeNotifier {
 Color primary = DataProvider().primary;
 double paddingApp = 32.0;
 Color pperrywinkle = Color(0XFF7a90d6);
 bool securePassword = true;

 set setPassword(bool check) {
  securePassword = check;
  notifyListeners();
 }
 bool get getPassword => securePassword;
/////////////////////////////////////////////////////////////////////////////////////////
  Future<String> productDetails(int Id) async {
    Response response = await http.get(ProductDetailsUrl+ Id.toString());
    int statusCode = response.statusCode;
    var body = json.decode(response.body);
    return response.body;
  }
////////////////////////cart///////////////////////////////////////////////////////////////
  Future<String> CartDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');
    final headers = {'Content-Type': 'application/json','Authorization': "Bearer $UserToken" };
    Response response = await http.get(CartUrl,headers: headers);
    int statusCode = response.statusCode;
    var body = json.decode(response.body);
    return response.body;
  }
  Future<String> CartPost(int product,int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');
    final headers = {'Content-Type': 'application/json','Authorization':"Bearer $UserToken"};
    Map<String, int> body = {'product': product, 'quantity': quantity};
    String jsonBody = json.encode(body);
    Response response = await http.post(CartUrl,body: jsonBody,headers: headers);
    int statusCode = response.statusCode;
    var s = json.decode(response.body);
    return response.body;
  }

  Future<String> CartDelete(dynamic rowID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');
    final headers = {'Content-Type': 'application/json','Authorization':"Bearer $UserToken"};
    Response response = await http.delete(CartUrl + '/$rowID',headers: headers);
    int statusCode = response.statusCode;
    var s = json.decode(response.body);
    return response.body;
  }
  Future<String> CartEdite(dynamic rowId,int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');
    final headers = {'Content-Type': 'application/json','Authorization':"Bearer $UserToken"};
    Map<String, int> body = { 'quantity': quantity};
    String jsonBody = json.encode(body);
    Response response = await http.put(CartUrl+'/$rowId'+'?quantity=$quantity',headers: headers);
    int statusCode = response.statusCode;
    var s = json.decode(response.body);
    return response.body;
  }
  ///////////////////////////////////////Home promotions/////////////////////////////////
Future<String>getPromotions()async{
  Response response =await http.get(promotionsUrl);
  var body=json.decode(response.body);
    return response.body;
}
  Future<String>getFAQ()async{
    Response response =await http.get(faqUrl);
    var body=json.decode(response.body);
    return response.body;
  }
}
