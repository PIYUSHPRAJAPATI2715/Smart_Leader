class ShowVideosModal {
  List<ShowVideosModalData>? data;
  String? message;

  ShowVideosModal({this.data, this.message});

  ShowVideosModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ShowVideosModalData>[];
      json['data'].forEach((v) {
        data!.add(new ShowVideosModalData.fromJson(v));
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

class ShowVideosModalData {
  String? id;
  String? languageKey;
  String? videoName;
  String? video;
  String? videoLink;
  String? image;
  String? path;
  String? time;

  ShowVideosModalData(
      {this.id,
        this.languageKey,
        this.videoName,
        this.video,
        this.videoLink,
        this.image,
        this.path,this.time});

  ShowVideosModalData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    languageKey = json['language_key'];
    videoName = json['video_name'];
    video = json['video'];
    videoLink = json['video_link'];
    image = json['image'];
    path = json['path'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['language_key'] = this.languageKey;
    data['video_name'] = this.videoName;
    data['video'] = this.video;
    data['video_link'] = this.videoLink;
    data['image'] = this.image;
    data['path'] = this.path;
    data['time'] = this.time;
    return data;
  }
}
