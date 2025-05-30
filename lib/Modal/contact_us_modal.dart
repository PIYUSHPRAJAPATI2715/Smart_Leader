class ContactUsModal {
  String? id;
  String? userId;
  String? name;
  String? email;
  String? mobile;
  String? subject;
  String? message;
  String? massage;

  ContactUsModal(
      {this.id,
        this.userId,
        this.name,
        this.email,
        this.mobile,
        this.subject,
        this.message,
        this.massage});

  ContactUsModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    subject = json['subject'];
    message = json['message'];
    massage = json['massage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['subject'] = this.subject;
    data['message'] = this.message;
    data['massage'] = this.massage;
    return data;
  }
}
