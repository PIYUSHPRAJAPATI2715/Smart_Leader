class Task {
  int? id;
  String? summary;
  String? date;
  String? time;
  String? color;
  String? type;
  String? reminder;
  int? isCompleted;

  Task(
      {this.id,
      this.summary,
      this.date,
      this.time,
      this.color,
      this.type,
      this.reminder,
      this.isCompleted});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    summary = json['summary'];
    date = json['date'];
    time = json['time'];
    color = json['color'];
    type = json['type'];
    reminder = json['reminder'];
    isCompleted = json["isCompleted"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['summary'] = summary;
    data['date'] = date;
    data['time'] = time;
    data['color'] = color;
    data['type'] = type;
    data['reminder'] = reminder;
    data["isCompleted"] = isCompleted;

    return data;
  }
}
