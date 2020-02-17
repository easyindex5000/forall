class Bid {
  int id;
  String avatar;
  String name;
  String location;
  int amount;

  Bid({this.id, this.avatar, this.name, this.location, this.amount});

  Bid.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    avatar = json['avatar'];
    name = json['name'];
    location = json['location'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['avatar'] = this.avatar;
    data['name'] = this.name;
    data['location'] = this.location;
    data['amount'] = this.amount;
    return data;
  }
}
