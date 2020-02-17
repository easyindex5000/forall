import 'bid.dart';
import 'category.dart';

class AuctionProduct {
  String startDate;
  String endDate;
  int id;
  String name;
  String description;
  int startPrice;
  int currentPrice;
  int numberOfBidders;
  String remaining_time;
  String country;
  int minIncrement;
  String cover;
  bool owner;
  bool subscribe;
  String city;
  String location;
  bool started;
  bool winner;
  List<Bid> bids = [];
  List<ImageURL> images = [];
  SubCategory subcategory;
  SubCategory parentCategory;

  AuctionProduct(
      {this.id,
      this.name,
      this.description,
      this.startPrice,
      this.location,
      this.currentPrice,
      this.numberOfBidders,
      this.remaining_time,
      this.subcategory,
      this.parentCategory,
      this.subscribe,
      this.started,
      this.country,
      this.city,
      this.minIncrement,
      this.winner,
      this.cover,
      this.bids,
      this.owner,
      this.startDate,
      this.endDate,
      this.images});

  AuctionProduct.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      name = json['name'] ?? "";
      description = json['description'] ?? "";
      startPrice = json['start_price'] ?? 0;
      currentPrice = json['current_price'] ?? 0;
      numberOfBidders = json['bidders'] ?? 0;
      remaining_time = json['remaining_time'] ?? "";
      country = json['country'] ?? "";
      minIncrement = json['min_increment'] ?? 0;
      cover = json['cover'] ?? "";
      owner = json['owner'] ?? false;
      started = json['started'] ?? false;
      subscribe = json['subscribe'] ?? false;
      endDate = json["end_date"];
      startDate = json["start_date"];
      city = json["city"];
      location = json["location"];
      winner = json["winner"];
      subcategory = SubCategory.fromJson(json["Category"]);
      parentCategory = SubCategory.fromJson(json["ParentCategory"]);

      if (json['Bids'] != null) {
        bids = new List<Bid>();
        json['Bids'].forEach((v) {
          bids.add(new Bid.fromJson(v));
        });
      }
      if (json['Images'] != null) {
        images = new List<ImageURL>();
        json['Images'].forEach((v) {
          images.add(new ImageURL.fromJson(v));
        });
      }
    } catch (e) {

    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['start_price'] = this.startPrice;
    data['current_price'] = this.currentPrice;
    data['bidders'] = this.numberOfBidders;
    data['remaining_time'] = this.remaining_time;
    data['country'] = this.country;
    data['min_increment'] = this.minIncrement;
    data['cover'] = this.cover;
    data['owner'] = this.owner;
    data['started'] = this.started;
    data['subscribe'] = this.subscribe;
    data['start_date'] = this.startDate;
    data["location"] = this.location;
    data["winner"] = winner;
    if (this.bids != null) {
      data['Bids'] = this.bids.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageURL {
  int id;
  String src;
  ImageURL.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    src = json["src"];
  }
}
