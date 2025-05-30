class MessageResponse {
  String? message;

  MessageResponse({this.message});

  MessageResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    return data;
  }
}
class ResultResponse{

  String?result;

  ResultResponse({this.result});

  ResultResponse.fromJson(Map<String, dynamic> json){
    result = json['result'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    return data;
  }
}
