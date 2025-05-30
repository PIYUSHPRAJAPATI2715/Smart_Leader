class ShowTaskModal {
  List<ShowTaskModalData>? data;
  String? message;

  ShowTaskModal({this.data, this.message});

  ShowTaskModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ShowTaskModalData>[];
      json['data'].forEach((v) {
        data!.add(new ShowTaskModalData.fromJson(v));
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

class ShowTaskModalData {
  String? id;
  String? userId;
  String? summary;
  String? date;
  String? old_date;
  String? time;
  String? color;
  String? type;
  String? reminder;
  String? next_reminder;
  String? strtotime;
  String? path;
  bool isSelected = false;

  ShowTaskModalData(
      {this.id,
        this.userId,
        this.summary,
        this.date,
        this.old_date,
        this.time,
        this.color,
        this.type,
        this.reminder,
        this.next_reminder,
        this.strtotime,
        this.path,
        this.isSelected = false,

      });

  ShowTaskModalData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    summary = json['summary'];
    date = json['date'];
    old_date = json['old_date'];
    time = json['time'];
    color = json['color'];
    type = json['type'];
    reminder = json['reminder'];
    next_reminder = json['next_reminder'];
    strtotime = json['strtotime'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['summary'] = this.summary;
    data['date'] = this.date;
    data['old_date'] = this.old_date;
    data['time'] = this.time;
    data['color'] = this.color;
    data['type'] = this.type;
    data['reminder'] = this.reminder;
    data['next_reminder'] = this.next_reminder;
    data['strtotime'] = this.strtotime;
    data['path'] = this.path;
    return data;
  }
}
