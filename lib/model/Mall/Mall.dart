class MallData {
  int id;
  String name;
  String image;
  String location;
  String openTime;
  String closeTime;
  String map;
  String cover;
  String city;
double rating;
  MallData({
    this.id,
    this.name,
    this.image,
    this.location,
    this.openTime,
    this.closeTime,
    this.map,
    this.cover,
    this.city,
    this.rating
  });

  factory MallData.fromJson(Map<String, dynamic> json) {
    return MallData(
      id: json['id'],
      name: json['name'] as String,
      image: json['cover'] as String,
      openTime: json['open_time']["date"] as String,
      closeTime: json['close_time']["date"] as String,
      map: json['map'] as String,
      cover: json['cover'] as String,
      city: json['city'] as String,
      location: json['location'] as String,
            rating: json['rating'] *1.0
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['location'] = this.location;
    data['open_time'] = this.openTime;
    data['close_time'] = this.closeTime;
    data['map'] = this.map;
    data['cover'] = this.cover;
    data['city'] = this.city;
        data['rating'] = this.rating;

    return data;
  }
}
