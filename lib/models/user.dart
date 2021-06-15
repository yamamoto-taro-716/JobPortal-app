class User {
  String id;
  String email;
  String fullName;
  String birthday;
  String address;
  String phoneNumber;
  String photoUrl;
  int type;

  User({
    this.id,
    this.email,
    this.fullName,
    this.birthday,
    this.address,
    this.phoneNumber,
    this.photoUrl,
  });
  fromJson(Map<String, dynamic> json) {
    this.id = json['_id'];
    this.email = json['email'];
    this.fullName = json['full_name'];
    this.birthday = json['birthday'];
    this.address = json['address'];
    this.phoneNumber = json['phone_number'];
    this.photoUrl = json['photo_url'];
  }

  toJson() {
    Map<String, dynamic> json;
    json['_id'] = this.id;
    json['email'] = this.email;
    json['full_name'] = this.fullName;
    json['birthday'] = this.birthday;
    json['address'] = this.address;
    json['phone_number'] = this.phoneNumber;
    json['photo_url'] = this.photoUrl;
    return json;
  }
}
