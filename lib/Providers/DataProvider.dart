import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MainProvider.dart';

String productApi = "/product/";
String cartGetApi = "/cart";
String ProductDetailsUrl = MainProvider().baseUrl + productApi;
String CartUrl = MainProvider().baseUrl + cartGetApi;
String GetSldIMGS = MainProvider().baseUrl + "/banners";
String GrtMallURL = MainProvider().baseUrl + "/mall/mall";
String Search = MainProvider().baseUrl + "/products?search=";
String promotionsUrl = MainProvider().baseUrl + "/promotions";
String bannersUrl = MainProvider().baseUrl + "/banners";
String faqUrl = MainProvider().baseUrl + "/question_answer";
String filterValuesUrl = MainProvider().baseUrl + "/categories";
String CombinationPostUrl = MainProvider().baseUrl + productApi;

class DataProvider with ChangeNotifier {
  Color primary = Color(0xff00ae8e);
  Color secondry = Color(0xff333335);
  double paddingApp = 32.0;
  Color pperrywinkle = Color(0XFF7a90d6);
  int cartCounter = 0;
  bool securePassword = true;
  bool securePassword2 = true;
  set setCatCounter(int increment) {
    cartCounter = increment;
    notifyListeners();
  }

  get getCartCounter => cartCounter;
  set setPassword(bool check) {
    securePassword = check;
    notifyListeners();
  }

  bool get getPassword => securePassword;
  bool get getPassword2 => securePassword2;
/////////////////////////////////////////////////////////////////////////////////////////
  Future<String> productDetails(int Id) async {
    Response response = await http.get(ProductDetailsUrl + Id.toString());
    int statusCode = response.statusCode;
    var body = json.decode(response.body);
    return response.body;
  }

////////////////////////cart///////////////////////////////////////////////////////////////
  Future<String> CartDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    Response response;
      response = await http.get(CartUrl, headers: headers);


    return response.body;
  }

  Future<String> CartPost(
      int product, int quantity, int productAttribute) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    Map<String, int> body = {
      'product': product,
      'quantity': quantity,
      'productAttribute': productAttribute
    };
   
    String jsonBody = json.encode(body);
    Response response =
        await http.post(CartUrl, body: jsonBody, headers: headers);
    int statusCode = response.statusCode;

    return response.body;
  }

  Future<String> CartDelete(dynamic rowID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    Response response =
        await http.delete(CartUrl + '/$rowID', headers: headers);
    int statusCode = response.statusCode;
    var s = json.decode(response.body);
    return response.body;
  }

  Future<String> CartEdite(dynamic rowId, int quantity) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    Map<String, int> body = {'quantity': quantity};
    String jsonBody = json.encode(body);

    Response response =
        await http.put(CartUrl + '/$rowId', body: jsonBody, headers: headers);
    int statusCode = response.statusCode;
    var s = json.decode(response.body);

    return response.body;
  }

  ///////////////////////////////////////Home promotions/////////////////////////////////
  Future<String> getPromotions() async {
    Response response = await http.get(promotionsUrl);
    var body = json.decode(response.body);
    return response.body;
  }

  Future<String> getFAQ() async {
    Response response = await http.get(faqUrl);
    var body = json.decode(response.body);
    return response.body;
  }

  Future<String> getsliderImages() async {
    Response response = await http.get(GetSldIMGS);
    return response.body;
  }

  Future<String> getSreach(String context) async {
    Response response = await http.get(Search + '$context');

    return response.body;
  }

  Future filterValues(int catID) async {
    Response response =
        await http.get(filterValuesUrl + "/$catID" + "/filtervalues");

    return response.body;
  }

  Future filterProduct(int catID,
      {int minPrice,
      int maxPrice,
      String brand,
      String attribudes,
}) async {

    String param = "";
    if (brand != "") {
      param += "&brand=$brand";
    }
    if (attribudes != "") {
      param += "&attribute=$attribudes";
    }

    Response response = await http.get(filterValuesUrl +
        "/$catID" +
        "/filter?min_price=$minPrice&max_price=$maxPrice" +
        param);

    return response.body;
  }

  ///////////////////////////////////combination///////////////////////////////////////////////////
  Future combinationProduct(
      int productID, int attributeId, Map<String, int> combinationId) async {
    final headers = {
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> body = {
      'attribute_id': attributeId,
      'data': combinationId
    };
    String jsonBody = json.encode(body);
    Response response = await http.post(
        CombinationPostUrl + "$productID" + "/combination",
        body: jsonBody,
        headers: headers);
    return response.body;
  }
}
