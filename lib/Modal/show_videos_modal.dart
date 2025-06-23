class ShowVideosModal {
  bool? status;
  dynamic message;
  List<ShowVideosModalData>? showVideosModalData;

  ShowVideosModal({this.status, this.message, this.showVideosModalData});

  ShowVideosModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      showVideosModalData = <ShowVideosModalData>[];
      json['data'].forEach((v) {
        showVideosModalData!.add(ShowVideosModalData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['message'] = message;
    if (showVideosModalData != null) {
      data['data'] = showVideosModalData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ShowVideosModalData {
  dynamic id;
  dynamic languageKey;
  dynamic tagId;
  dynamic videoName;
  dynamic video;
  dynamic videoLink;
  dynamic time;
  dynamic image;
  dynamic languageName;
  dynamic tagName;
  dynamic path;

  ShowVideosModalData({
    this.id,
    this.languageKey,
    this.tagId,
    this.videoName,
    this.video,
    this.videoLink,
    this.time,
    this.image,
    this.languageName,
    this.tagName,
    this.path,
  });

  factory ShowVideosModalData.fromJson(Map<String, dynamic> json) {
    return ShowVideosModalData(
      id: json['id'],
      languageKey: json['language_key'],
      tagId: json['tag_id'],
      videoName: json['video_name'],
      video: json['video'],
      videoLink: json['video_link'],
      time: json['time'],
      image: json['image'],
      languageName: json['language_name'],
      tagName: json['tag_name'] ?? 'No Tag',
      path: json['path'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['language_key'] = languageKey;
    data['tag_id'] = tagId;
    data['video_name'] = videoName;
    data['video'] = video;
    data['video_link'] = videoLink;
    data['time'] = time;
    data['image'] = image;
    data['language_name'] = languageName;
    data['tag_name'] = tagName;
    data['path'] = path;
    return data;
  }

  /// 🧠 Required for DropdownButton to compare objects
  @override
  String toString() => tagName ?? '';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ShowVideosModalData && tagName == other.tagName;

  @override
  int get hashCode => tagName.hashCode;
}

