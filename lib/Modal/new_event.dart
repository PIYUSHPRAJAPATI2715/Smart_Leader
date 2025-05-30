class NewEvent {
  String? status;
  String? massage;
  List<NewEventData>? result;

  NewEvent({this.status, this.massage, this.result});

  NewEvent.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    massage = json['massage'];
    if (json['result'] != null) {
      result = <NewEventData>[];
      json['result'].forEach((v) {
        result!.add(NewEventData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['massage'] = massage;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NewEventData {
  String? id;
  String? userId;
  String? name;
  String? mobile;
  String? occupation;
  String? time;
  String? date;
  String? remind;
  String? meetingRequired;
  String? meetingCount;
  String? meetingHappen;
  String? notes;
  String? connectionId;
  String? title;
  String? description;
  String? meetingType;
  String? meetingPlace;
  String? birthdayParson;
  String? place;
  String? addedType;
  String? list_type;

  NewEventData(
      {this.id,
      this.userId,
      this.name,
      this.mobile,
      this.occupation,
      this.time,
      this.date,
      this.remind,
      this.meetingRequired,
      this.meetingCount,
      this.meetingHappen,
      this.notes,
      this.connectionId,
      this.title,
      this.description,
      this.meetingType,
      this.meetingPlace,
      this.birthdayParson,
      this.place,
      this.list_type,
      this.addedType});

  NewEventData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    mobile = json['mobile'];
    occupation = json['occupation'];
    time = json['time'];
    date = json['date'];
    remind = json['remind'];
    meetingRequired = json['meeting_required'];
    meetingCount = json['meeting_count'];
    meetingHappen = json['meeting_happen'];
    notes = json['notes'];
    connectionId = json['connection_id'];
    title = json['title'];
    description = json['description'];
    meetingType = json['meeting_type'];
    meetingPlace = json['meeting_place'];
    birthdayParson = json['birthday_parson'];
    place = json['place'];
    list_type = json['list_type'];
    addedType = json['added_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['mobile'] = mobile;
    data['occupation'] = occupation;
    data['time'] = time;
    data['date'] = date;
    data['remind'] = remind;
    data['meeting_required'] = meetingRequired;
    data['meeting_count'] = meetingCount;
    data['meeting_happen'] = meetingHappen;
    data['notes'] = notes;
    data['connection_id'] = connectionId;
    data['title'] = title;
    data['description'] = description;
    data['meeting_type'] = meetingType;
    data['meeting_place'] = meetingPlace;
    data['birthday_parson'] = birthdayParson;
    data['place'] = place;
    data['added_type'] = addedType;
    data['list_type'] = list_type;
    return data;
  }
}
