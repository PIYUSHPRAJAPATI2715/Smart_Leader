class EditTaskModal {
  String? id;
  String? userId;
  String? summary;
  String? date;
  String? time;
  String? color;
  String? type;
  String? strtotime;
  String? path;
  String? message;

  EditTaskModal(
      {this.id,
        this.userId,
        this.summary,
        this.date,
        this.time,
        this.color,
        this.type,
        this.strtotime,
        this.path,
        this.message});

  EditTaskModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    summary = json['summary'];
    date = json['date'];
    time = json['time'];
    color = json['color'];
    type = json['type'];
    strtotime = json['strtotime'];
    path = json['path'];
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
    data['strtotime'] = this.strtotime;
    data['path'] = this.path;
    data['message'] = this.message;
    return data;
  }
}
