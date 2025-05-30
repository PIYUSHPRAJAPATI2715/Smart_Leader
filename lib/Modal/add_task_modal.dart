class AddTaskModal {
  String? id;
  String? userId;
  String? summary;
  String? date;
  String? time;
  String? color;
  String? type;
  String? reminder;
  String? strtotime;
  String? message;

  AddTaskModal(
      {this.id,
        this.userId,
        this.summary,
        this.date,
        this.time,
        this.color,
        this.type,
        this.reminder,
        this.strtotime,
        this.message});

  AddTaskModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    summary = json['summary'];
    date = json['date'];
    time = json['time'];
    color = json['color'];
    type = json['type'];
    reminder = json['reminder'];
    strtotime = json['strtotime'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['summary'] = this.summary;
    data['date'] = this.date;
    data['time'] = this.time;
    data['color'] = this.color;
    data['type'] = this.type;
    data['reminder'] = this.reminder;
    data['strtotime'] = this.strtotime;
    data['message'] = this.message;
    return data;
  }
}
