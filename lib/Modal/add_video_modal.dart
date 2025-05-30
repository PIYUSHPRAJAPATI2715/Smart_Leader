class AddVideoModal {
  String? id;
  String? userId;
  String? videoId;
  String? message;

  AddVideoModal({this.id, this.userId, this.videoId, this.message});

  AddVideoModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    videoId = json['video_id'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['video_id'] = this.videoId;
    data['message'] = this.message;
    return data;
  }
}
