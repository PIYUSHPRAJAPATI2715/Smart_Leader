class EditConnectionModal {
  String? id;
  String? userId;
  String? name;
  String? mobile;
  String? email;
  String? occupation;
  String? category;
  String? description;
  String? path;
  String? message;
  String? meetingCount;
  String? meetingRequired;

  EditConnectionModal(
      {this.id,
      this.userId,
      this.name,
      this.mobile,
      this.email,
      this.occupation,
      this.category,
      this.description,
      this.path,
      this.message,
      this.meetingRequired,
      this.meetingCount});

  EditConnectionModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    mobile = json['mobile'];
    email = json['email'];
    occupation = json['occupation'];
    category = json['category'];
    description = json['description'];
    meetingRequired = json['meeting_required'];
    meetingCount = json['meeting_count'];
    path = json['path'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['mobile'] = mobile;
    data['email'] = email;
    data['occupation'] = occupation;
    data['category'] = category;
    data['description'] = description;
    data['meeting_required'] = meetingRequired;
    data['meeting_count'] = meetingCount;
    data['path'] = path;
    data['message'] = message;
    return data;
  }
}
