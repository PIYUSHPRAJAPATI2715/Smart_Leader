class TermsConditionModal {
  String? id;
  String? description;
  String? message;

  TermsConditionModal({this.id, this.description, this.message});

  TermsConditionModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['message'] = this.message;
    return data;
  }
}
