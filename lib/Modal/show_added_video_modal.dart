class ShowVideoModal {
  List<ShowVideoModalData>? data;
  String? message;

  ShowVideoModal({this.data, this.message});

  ShowVideoModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ShowVideoModalData>[];
      json['data'].forEach((v) {
        data!.add(new ShowVideoModalData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class ShowVideoModalData {
  String? id;
  String? userId;
  String? videoId;
  Video? video;
  String? path;

  ShowVideoModalData({this.id, this.userId, this.videoId, this.video, this.path});

  ShowVideoModalData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    videoId = json['video_id'];
    video = json['video'] != null ? new Video.fromJson(json['video']) : null;
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['video_id'] = this.videoId;
    if (this.video != null) {
      data['video'] = this.video!.toJson();
    }
    data['path'] = this.path;
    return data;
  }
}

class Video {
  String? id;
  String? videoName;
  String? video;
  String? videoLink;
  String? time;
  String? image;

  Video(
      {this.id,
        this.videoName,
        this.video,
        this.videoLink,
        this.time,
        this.image});

  Video.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoName = json['video_name'];
    video = json['video'];
    videoLink = json['video_link'];
    time = json['time'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['video_name'] = this.videoName;
    data['video'] = this.video;
    data['video_link'] = this.videoLink;
    data['time'] = this.time;
    data['image'] = this.image;
    return data;
  }
}
