class Items {
  bool suceess;
  List<Category> cat;

  Items({this.suceess, this.cat});
  factory Items.fromJson(Map<String, dynamic> json) {
    return Items(
      suceess: json["success"],
      cat: Category.fromJson(json["data"]) as List,
    );
  }
}

class Category {
  int id;
  String name;
  String fColor;
  String lColor;
  String iconCode;
  String iconFont;
  String imageCover;

  Category(
      {this.id,
      this.name,
      this.fColor,
      this.lColor,
      this.iconCode,
      this.iconFont,
      this.imageCover});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int,
      name: json['name'] as String,
      fColor: json['f_color'] as String,
      lColor: json['l_color'] as String,
      iconCode: json['icon_code'] as String,
      iconFont: json['icon_font'] as String,
      imageCover: json['cover'] as String,
    );
  }
}
