class Job {
  String title, country, city, description, imageUrl, jobType;
  int id;
  Job(
      {this.id,
      this.title,
      this.description,
      this.country,
      this.city,
      this.imageUrl,
      this.jobType});

  Job.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    country = json['country'];
    city = json['city'];
    imageUrl = json['imageUrl'];
    jobType = json['jobType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['city'] = this.city;
    data['country'] = this.country;
    data['imageUrl'] = this.imageUrl;
    data['jobType'] = this.jobType;

    return data;
  }
}
