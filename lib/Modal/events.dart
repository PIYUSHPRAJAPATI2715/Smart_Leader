class Events {
  List<EventDate>? data;
  String? message;

  Events({this.data, this.message});

  Events.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <EventDate>[];
      json['data'].forEach((v) {
        data!.add(EventDate.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class EventDate {
  String? date;
  List<EventsData>? data;
  String? path;

  EventDate({this.date, this.data, this.path});

  EventDate.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['data'] != null) {
      data = <EventsData>[];
      json['data'].forEach((v) {
        data!.add(EventsData.fromJson(v));
      });
    }
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['path'] = path;
    return data;
  }
}

class EventsData {
  String? id;
  String? userId;
  String? title;
  String? description;
  String? date;
  String? time;
  String? type;
  String? meetingType;
  String? meetingPlace;
  String? birthdayParson;
  String? place;
  String? remindMe;
  String?connectionType;

  EventsData(
      {this.id,
        this.userId,
        this.title,
        this.description,
        this.date,
        this.time,
        this.type,
        this.meetingType,
        this.meetingPlace,
        this.birthdayParson,
        this.place,
        this.remindMe,this.connectionType});

  EventsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    time = json['time'];
    type = json['type'];
    meetingType = json['meeting_type'];
    meetingPlace = json['meeting_place'];
    birthdayParson = json['birthday_parson'];
    place = json['place'];
    remindMe = json['remind_me'];
    connectionType = json['connecion_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['title'] = title;
    data['description'] = description;
    data['date'] = date;
    data['time'] = time;
    data['type'] = type;
    data['meeting_type'] = meetingType;
    data['meeting_place'] = meetingPlace;
    data['birthday_parson'] = birthdayParson;
    data['place'] = place;
    data['remind_me'] = remindMe;
    data['connecion_type'] = connectionType;
    return data;
  }
}
