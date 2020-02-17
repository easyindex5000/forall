class Store {
  int id;
  int mallID;
  String name;
  String openTime;
  String closeTime;
  String cover;
  String category;
  String location;
  String mobile;

  Store(
      {this.id,
      this.mallID,
      this.name,
      this.openTime,
      this.closeTime,
      this.cover,
      this.category,
      this.location,
      this.mobile});

  Store.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    openTime = json['open_time'];
    closeTime = json['close_time'];
    cover = json['cover'];
    category = json['category'];
    location = json['location'];
    mobile = json['mobile'];
    mallID = json['mall_id']??0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['open_time'] = this.openTime;
    data['close_time'] = this.closeTime;
    data['cover'] = this.cover;
    data['category'] = this.category;
    data['location'] = this.location;
    data['mobile'] = this.mobile;
    data['mall_id'] = this.mallID;

    return data;
  }
}
