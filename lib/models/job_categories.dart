class JobCategory {
  String id;
  String name;
  int type;
  JobCategory({this.id, this.name, this.type});
  fromJson(Map<String, dynamic> json) {
    this.id = json['_id'];
    this.name = json['name'];
    this.type = json['type'];
  }

  toJson() {
    Map<String, dynamic> json;
    json['_id'] = this.id;
    json['name'] = this.name;
    json['type'] = this.type;
    return json;
  }
}
