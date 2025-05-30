class ShowSearchMeetingModal {
  List<ShowSearchMeetingModalData>? data;
  String? message;

  ShowSearchMeetingModal({this.data, this.message});

  ShowSearchMeetingModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ShowSearchMeetingModalData>[];
      json['data'].forEach((v) {
        data!.add(new ShowSearchMeetingModalData.fromJson(v));
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

class ShowSearchMeetingModalData {
  String? id;
  String? userId;
  String? selectType;
  String? date;
  String? leaderName;
  String? title;
  String? time;
  String? reminder;
  String? strtotime;
  String? path;

  ShowSearchMeetingModalData(
      {this.id,
        this.userId,
        this.selectType,
        this.date,
        this.leaderName,
        this.title,
        this.time,
        this.reminder,
        this.strtotime,
        this.path});

  ShowSearchMeetingModalData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    selectType = json['select_type'];
    date = json['date'];
    leaderName = json['leader_name'];
    title = json['title'];
    time = json['time'];
    reminder = json['reminder'];
    strtotime = json['strtotime'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['select_type'] = this.selectType;
    data['date'] = this.date;
    data['leader_name'] = this.leaderName;
    data['title'] = this.title;
    data['time'] = this.time;
    data['reminder'] = this.reminder;
    data['strtotime'] = this.strtotime;
    data['path'] = this.path;
    return data;
  }
}
