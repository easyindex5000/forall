import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  String title;
  String description;
  String imageUrl;
  String price;
  String offer;
  int isNew;
  int productID;
  int id;
  Product(
    this.title,
    this.description,
    this.imageUrl,
    this.price,
    this.offer,
    this.isNew,
    this.productID,
  );

  Product.map(dynamic obj) {
    this.title = obj['title'];
    this.description = obj['description'];
    this.imageUrl = obj['imageUrl'];
    this.price = obj['price'];
    this.offer = obj['offer'];
    this.isNew = obj['isNew'];
    this.productID = obj['productID'];
    this.id = obj['id'];
  }

  String get _getTitle => title;
  String get _getDescription => description;
  String get _getImage => imageUrl;
  String get _getPrice => price;
  String get _getOffer => offer;
  int get _getIsNew => isNew;
  int get _getISFavorite => productID;
  int get _getId => id;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['title'] = _getTitle;
    map['description'] = _getDescription;
    map['imageUrl'] = _getImage;
    map['price'] = _getPrice;
    map['offer'] = _getOffer;
    map['isNew'] = _getIsNew;
    map['productID'] = _getISFavorite;
    if (id != null) {
      map['id'] = _getId;
    }
    return map;
  }

  Product.fromMap(Map<String, dynamic> map) {
    this.title = map['title'];
    this.description = map['description'];
    this.imageUrl = map['imageUrl'];
    this.price = map['price'];
    this.offer = map['offer'];
    this.isNew = map['IsNew'];
    this.productID = map['productID'];
    this.id = map['id'];
  }
  notifyListeners();
}

class Myproduct {
  bool success;
  List<Data> data;

  Myproduct({this.success, this.data});

  Myproduct.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int id;
  String name;
  String description;
  String price;
  String cover;
  String offer;
  String offerPercent;
  double rating;
  bool isNew;
  List<Images> images;
  Brand brand;
  Company company;
  _Category category;
  int rateCount;
  List<CategoryAttributes> categoryAttributes;
  List<Values> values;

  Data(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.cover,
      this.offer,
      this.offerPercent,
      this.images,
      this.brand,
      this.company,
      this.rating,
      this.isNew,
      this.rateCount,
      this.category,
      this.values});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    offer = json['sale_price'];
    offerPercent = json['offer'];
    cover = json['cover'];
    rating = double.parse(json['rating'].toString());
    isNew = json['new'];
    rateCount = json['rate_count'];
    if (json['category_attributes'] != null) {
      categoryAttributes = new List<CategoryAttributes>();
      json['category_attributes'].forEach((v) {
        categoryAttributes.add(new CategoryAttributes.fromJson(v));
      });
    }
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
    brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
    company =
        json['comapny'] != null ? new Company.fromJson(json['comapny']) : null;
    category = json['category'] != null
        ? new _Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }

    if (this.brand != null) {
      data['brand'] = this.brand.toJson();
    }
    if (this.company != null) {
      data['comapny'] = this.brand.toJson();
    }
    return data;
  }
}

class Images {
  int id;
  String src;

  Images({this.id, this.src});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    src = json['src'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['src'] = this.src;
    return data;
  }
}

class Brand {
  int id;
  String name;

  Brand({this.id, this.name});

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Company {
  int id;
  String name;

  Company({this.id, this.name});

  Company.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class _Category {
  int id;
  String name;

  _Category({this.id, this.name});

  _Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class CategoryAttributes {
  int id;
  String name;
  List<Values> values;

  CategoryAttributes({this.id, this.name, this.values});

  CategoryAttributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['values'] != null) {
      values = new List<Values>();
      json['values'].forEach((v) {
        values.add(new Values.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    if (this.values != null) {
      data['values'] = this.values.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Values {
  int id;
  String value;

  Values({this.id, this.value});

  Values.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['value'] = this.value;
    return data;
  }
}
