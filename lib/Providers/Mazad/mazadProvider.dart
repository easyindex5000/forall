import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:big/model/mazad/auctionProduct.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../MainProvider.dart';

String mazadApi = "/auction";
String ProductsUrl = MainProvider().baseUrl + mazadApi + "/product";
String ProductsuserUrl = MainProvider().baseUrl + mazadApi + "/products";
String productDetailsUrl = MainProvider().baseUrl + mazadApi + "/product/";
String productEditUrl = MainProvider().baseUrl + mazadApi + "/product/";
String deleteProductUrl = MainProvider().baseUrl + mazadApi + "/product/";
String getUserAuctionUrl = MainProvider().baseUrl + mazadApi + "/bids";
String createUserURL = MainProvider().baseUrl + mazadApi + "/user";
String filterValuesUrl = MainProvider().baseUrl + mazadApi + "/products/filter";
String filterProductUrl = MainProvider().baseUrl + mazadApi + "/product";
String sortProductUrl = MainProvider().baseUrl + mazadApi + "/product";
String renewProductUrl = MainProvider().baseUrl + mazadApi + "/product/";
String searchProductUrl =
    MainProvider().baseUrl + mazadApi + "/products/search";
String subscribeProductUrl = MainProvider().baseUrl + mazadApi + "/product/";
String deleteImageUrl = MainProvider().baseUrl + mazadApi + "/product/";
String notificationUrl = MainProvider().baseUrl + mazadApi + "/notifications";
String seenUrl = MainProvider().baseUrl + mazadApi + "/notification/";
String categoriesUrl = MainProvider().baseUrl + "/list/categories";
String notificationLengthUrl =
    MainProvider().baseUrl + mazadApi + "/notifications/count";

class MazadProvider with ChangeNotifier {
  Future<String> getproducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    print(headers);
    Response response;
    response = await http.get(ProductsUrl, headers: headers);
    return response.body;
  }

  Future<String> productDetails(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    Response response =
        await http.get(productDetailsUrl + id.toString(), headers: headers);
    var body = json.decode(response.body);
    return response.body;
  }

  Future createAuction(
      String name,
      String description,
      String startprice,
      String minumtprice,
      String startDate,
      String location,
      String city,
      int category_id,
      File cover,
      [List<File> images]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');
    var request = http.MultipartRequest("POST", Uri.parse(ProductsUrl));
    request.headers['Authorization'] = 'Bearer $UserToken';
    request.fields["name"] = name;
    request.fields["description"] = description;
    request.fields["start_price"] = startprice;
    request.fields["min_increment"] = minumtprice;
    request.fields["start_date"] = startDate;
    request.fields["country"] = location;
    request.fields["city"] = city;
    request.fields["category_id"] = category_id.toString();

    //create multipart using filepath, string or bytes
    if (cover != null) {
      var pic = await http.MultipartFile.fromPath("cover", cover.path);

      //add multipart to request
      request.files.add(pic);
    }
    if (images != null) {
      for (int i = 0; i < images.length; i++) {
        var pic = await http.MultipartFile.fromPath("src[$i]", images[i].path);

        //add multipart to request
        request.files.add(pic);
      }
    }
    var response = await request.send();
    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    return jsonDecode(responseString);
  }

  Future createBid(int id, String amount) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    Map<String, String> body = {'amount': amount};
    String jsonBody = json.encode(body);

    Response response = await http.post(
        productDetailsUrl + id.toString() + "/bid",
        body: jsonBody,
        headers: headers);
    var s = json.decode(response.body);
    return s;
  }

  Future<String> getUserSelles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    Response response = await http.get(ProductsuserUrl, headers: headers);

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      print(body);
      print(headers);
      return response.body;
    }
  }

  Future<String> getUserAuctions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    Response response = await http.get(getUserAuctionUrl, headers: headers);
    int statusCode = response.statusCode;
    var body = json.decode(response.body);
    return response.body;
  }

  Future subscribeAuctions(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    print(headers);
    Response response = await http.post(
        subscribeProductUrl + id.toString() + "/subscribe",
        headers: headers);

    return json.decode(response.body);
  }

  Future unsubscribeAuctions(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    Response response = await http.delete(
        subscribeProductUrl + id.toString() + "/subscribe",
        headers: headers);
    return json.decode(response.body);
  }

  Future<String> deleteImages(int productID, List<int> ids) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    var body = {"images": ids};
    Response response = await http.post(
        deleteImageUrl + productID.toString() + "/image/delete",
        headers: headers,
        body: json.encode(body));

    return response.body;
  }

  Future createUser(String nationalID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    Response response = await http.post(createUserURL,
        headers: headers, body: json.encode({"national_id": nationalID}));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future deleteProduct(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    Response response =
        await http.delete(deleteProductUrl + "$id", headers: headers);
    return response.body;
  }

  Future filterValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    Response response = await http.get(filterValuesUrl, headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return false;
    }
  }

  Future filterProducts({String category, int minPrice, int maxPrice}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    String params = "?min_price=$minPrice&max_price=$maxPrice";
    if (category != "") {
      params += "&category=$category";
    }
    Response response =
        await http.post(filterValuesUrl + params, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return false;
    }
  }

  Future sortProducts({String sortBy, String orderBy}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    String params = "?sortBy=$sortBy&orderBy=$orderBy";
    Response response =
        await http.get(sortProductUrl + params, headers: headers);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return false;
    }
  }

  Future seachProduct(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    Response response =
        await http.get(searchProductUrl + "?name=$name", headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return false;
    }
  }

  Future renewProduct(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    Response response =
        await http.post(renewProductUrl + id + "/renew", headers: headers);
    return response.body;
  }

  Future getCategories() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    Response response = await http.get(categoriesUrl, headers: headers);
    return response.body;
  }

  Future getNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    Response response = await http.get(notificationUrl, headers: headers);
    return response.body;
  }

  Future seen(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var UserToken = await prefs.getString('userToken');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    Response response =
        await http.post(seenUrl + id.toString() + "/seen", headers: headers);
    return response.body;
  }

  Future editProduct(
      int id,
      String name,
      String description,
      String startprice,
      String minIncremente,
      String startDate,
      String location,
      String city,
      int category_id,
      File cover,
      [List<File> images]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String UserToken = prefs.getString('userToken');
    var request = http.MultipartRequest(
        "POST", Uri.parse(productEditUrl + id.toString() + "/edit"));
    request.headers['Authorization'] = 'Bearer $UserToken';
    request.headers['Content-Type'] = 'application/x-www-form-urlencoded';

    request.fields["name"] = name;
    request.fields["description"] = description;
    request.fields["start_price"] = startprice;
    request.fields["min_increment"] = minIncremente;
    //request.fields["start_date"] = startDate;
    request.fields["country"] = location;
    request.fields["city"] = city;
    request.fields["category_id"] = category_id.toString();

    //create multipart using filepath, string or bytes
    if (cover != null) {
      var pic = await http.MultipartFile.fromPath("cover", cover.path);

      //add multipart to request
      request.files.add(pic);
    }

    if (images != null) {
      for (int i = 0; i < images.length; i++) {
        var pic = await http.MultipartFile.fromPath("src[$i]", images[i].path);

        //add multipart to request
        request.files.add(pic);
      }
    }

    var response = await request.send();
    //Get the response from the server

    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);

    return true;
  }

  Future<int> notificationLength() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var UserToken = await prefs.getString('userToken');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': "Bearer $UserToken"
    };
    var res = await http.get(notificationLengthUrl, headers: headers);
    return json.decode(res.body)["data"];
  }
}
