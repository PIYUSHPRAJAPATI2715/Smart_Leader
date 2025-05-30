class LoginModal {
  String? id;
  String? authId;
  String? provider;
  String? username;
  String? email;
  String? image;
  String? result;

  LoginModal(
      {this.id,
        this.authId,
        this.provider,
        this.username,
        this.email,
        this.image,
        this.result});

  LoginModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    authId = json['auth_id'];
    provider = json['provider'];
    username = json['username'];
    email = json['email'];
    image = json['image'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['auth_id'] = this.authId;
    data['provider'] = this.provider;
    data['username'] = this.username;
    data['email'] = this.email;
    data['image'] = this.image;
    data['result'] = this.result;
    return data;
  }
}
