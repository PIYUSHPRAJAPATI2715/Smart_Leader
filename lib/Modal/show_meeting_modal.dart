class ShowMeetingModal {
  List<ShowMeetingModalData>? data;
  String? message;

  ShowMeetingModal({this.data, this.message});

  ShowMeetingModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ShowMeetingModalData>[];
      json['data'].forEach((v) {
        data!.add(new ShowMeetingModalData.fromJson(v));
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

class ShowMeetingModalData {
  String? date;
  List<DataMeeting>? data;
  String? path;

  ShowMeetingModalData({this.date, this.data, this.path});

  ShowMeetingModalData.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['data'] != null) {
      data = <DataMeeting>[];
      json['data'].forEach((v) {
        data!.add(new DataMeeting.fromJson(v));
      });
    }
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['path'] = this.path;
    return data;
  }
}

class DataMeeting {
  String? id;
  String? userId;
  String? selectType;
  String? date;
  String? leaderName;
  String? title;
  String? time;
  String? reminder;
  String? strtotime;
  bool? isSelected = false;

  DataMeeting(
      {this.id,
        this.userId,
        this.selectType,
        this.date,
        this.leaderName,
        this.title,
        this.time,
        this.reminder,
        this.strtotime,
        this.isSelected = false,
      });

  DataMeeting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    selectType = json['select_type'];
    date = json['date'];
    leaderName = json['leader_name'];
    title = json['title'];
    time = json['time'];
    reminder = json['reminder'];
    strtotime = json['strtotime'];
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
    return data;
  }
}
