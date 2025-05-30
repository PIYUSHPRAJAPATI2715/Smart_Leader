class UpdateProfileINameModal {
  String? id;
  String? authId;
  String? provider;
  String? username;
  String? email;
  String? file;
  String? path;
  String? message;

  UpdateProfileINameModal(
      {this.id,
        this.authId,
        this.provider,
        this.username,
        this.email,
        this.file,
        this.path,
        this.message});

  UpdateProfileINameModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    authId = json['auth_id'];
    provider = json['provider'];
    username = json['username'];
    email = json['email'];
    file = json['file'];
    path = json['path'];
    message = json['message'];
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
    data['message'] = this.message;
    return data;
  }
}
