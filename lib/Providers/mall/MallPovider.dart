import 'package:big/Providers/MainProvider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MallProvider extends ChangeNotifier {
  final String _allMallsURl = MainProvider().baseUrl + "/mall/mall";
  final String _mallDetailsURl = MainProvider().baseUrl + "/mall/mall/";
  final String _allStoresURl = MainProvider().baseUrl + "/mall/mall/";
  final String _storeProductsURl = MainProvider().baseUrl + "/mall/mall/";
  Future getAllMalls() async {
    var response = await http.get(_allMallsURl);
    return response.body;
  }

  Future getMallDetails(int id) async {
    var response = await http.get(_mallDetailsURl + id.toString());
    print(response.body);
    print("&&&&&&&&&&");
    return response.body;
  }

  Future getMallStores(int id) async {
    var response = await http.get(_allStoresURl + id.toString() + "/store");

    return response.body;
  }

  Future getStoreProducts(int mallID, int storeID) async {
    var response = await http.get(_storeProductsURl +
        mallID.toString() +
        "/store/" +
        storeID.toString() +
        "/product");
        
    return response.body;
  }
}
