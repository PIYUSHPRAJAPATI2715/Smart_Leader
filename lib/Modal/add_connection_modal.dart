class AddConnectionModal {
  String? id;
  String? userId;
  String? name;
  String? mobile;
  String? email;
  String? occupation;
  String? connectionTypeId;
  String? description;
  String? message;

  AddConnectionModal(
      {this.id,
        this.userId,
        this.name,
        this.mobile,
        this.email,
        this.occupation,
        this.connectionTypeId,
        this.description,
        this.message});

  AddConnectionModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    occupation = json['occupation'];
    connectionTypeId = json['connection_type_id'];
    description = json['description'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['occupation'] = this.occupation;
    data['connection_type_id'] = this.connectionTypeId;
    data['description'] = this.description;
    data['message'] = this.message;
    return data;
  }
}
