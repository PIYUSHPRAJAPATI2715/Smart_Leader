class AddMeetingModal {
  String? id;
  String? userId;
  String? selectType;
  String? date;
  String? leaderName;
  String? title;
  String? time;
  String? reminder;
  String? strtotime;
  String? message;

  AddMeetingModal(
      {this.id,
        this.userId,
        this.selectType,
        this.date,
        this.leaderName,
        this.title,
        this.time,
        this.reminder,
        this.strtotime,
        this.message});

  AddMeetingModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    selectType = json['select_type'];
    date = json['date'];
    leaderName = json['leader_name'];
    title = json['title'];
    time = json['time'];
    reminder = json['reminder'];
    strtotime = json['strtotime'];
    message = json['message'];
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
    data['message'] = this.message;
    return data;
  }
}
