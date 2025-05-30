class VideosName {
  bool? status;
  List<VideosNameData>? data;
  String? message;

  VideosName({this.status, this.data, this.message});

  VideosName.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <VideosNameData>[];
      json['data'].forEach((v) {
        data!.add(new VideosNameData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class VideosNameData {
  String? id;
  String? videoName;

  VideosNameData({this.id, this.videoName});

  VideosNameData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    videoName = json['video_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['video_name'] = this.videoName;
    return data;
  }
}
