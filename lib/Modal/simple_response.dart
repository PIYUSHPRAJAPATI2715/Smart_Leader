class SimpleResponse {
  String? status;
  String? massage;

  SimpleResponse({this.status, this.massage});

  SimpleResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    massage = json['massage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['massage'] = massage;
    return data;
  }
}
