class Connections {
  int? id;
  String? name;
  String? number;
  String? occupation;
  String? date;
  String? time;
  String? remind;
  String?connectionId;
  String?meetingRequired;
  String?meetingCount;

  Connections({
    this.id,
    this.name,
    this.occupation,
    this.number,
    this.date,
    this.time,
    this.remind,
    this.connectionId,
    this.meetingCount,
    this.meetingRequired
  });

  Connections.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    number = json['number'];
    occupation = json['occupation'];
    date = json['date'];
    time = json['time'];
    remind = json['remind'];
    connectionId = json['connectionTypeId'];
    meetingRequired = json['meetingReq'];
    meetingCount = json['meetingCount'];
  }

//
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['number'] = number;
    data['occupation'] = occupation;
    data['date'] = date;
    data['time'] = time;
    data['remind'] = remind;
    data['connectionTypeId'] = connectionId;
    data['meetingReq'] = meetingRequired;
    data['meetingCount'] = meetingCount;
    return data;
  }
}
