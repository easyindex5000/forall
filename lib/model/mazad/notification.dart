class MazadNotification {
  int id;
  int type;
  bool seen;
  int amount;
  int auctionId;
  String auctionName;
  String cover;
  String time;

  MazadNotification(
      {this.id,
      this.type,
      this.seen,
      this.amount,
      this.auctionId,
      this.auctionName,
      this.cover,
      this.time});

  MazadNotification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    seen = json['seen'];
    amount = json['amount'];
    auctionId = json['auction_id'];
    auctionName = json['auction_name'];
    cover = json['cover'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['seen'] = this.seen;
    data['amount'] = this.amount;
    data['auction_id'] = this.auctionId;
    data['auction_name'] = this.auctionName;
    data['cover'] = this.cover;
    data['time'] = this.time;
    return data;
  }
}
