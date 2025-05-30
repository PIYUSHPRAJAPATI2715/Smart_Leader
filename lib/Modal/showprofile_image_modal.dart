class ShowProfileImageModal {
  Data? data;
  String? message;

  ShowProfileImageModal({this.data, this.message});

  ShowProfileImageModal.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  String? id;
  String? authId;
  String? provider;
  String? username;
  String? email;
  String? file;
  String? path;

  Data(
      {this.id,
        this.authId,
        this.provider,
        this.username,
        this.email,
        this.file,
        this.path});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    authId = json['auth_id'];
    provider = json['provider'];
    username = json['username'];
    email = json['email'];
    file = json['file'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['auth_id'] = this.authId;
    data['provider'] = this.provider;
    data['username'] = this.username;
    data['email'] = this.email;
    data['file'] = this.file;
    data['path'] = this.path;
    return data;
  }
}
