class ShowConnectionModal {
  List<ShowConnectionModalData>? data;
  String? message;

  ShowConnectionModal({this.data, this.message});

  ShowConnectionModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ShowConnectionModalData>[];
      json['data'].forEach((v) {
        data!.add(ShowConnectionModalData.fromJson(v));
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

class ShowConnectionModalData {
  String? id;
  String? userId;
  String? name;
  String? mobile;
  String? occupation;
  String? connectionTypeId;
  String? time;
  String? date;
  String? remind;
  String? notes;
  String? meetingRequired;
  String? meetingCount;
  String? meetingHappen;
  String? path;

  ShowConnectionModalData(
      {this.id,
      this.userId,
      this.name,
      this.mobile,
      this.occupation,
      this.connectionTypeId,
      this.time,
      this.date,
      this.remind,
      this.notes,
      this.meetingRequired,
      this.meetingCount,
      this.meetingHappen,
      this.path});

  ShowConnectionModalData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    mobile = json['mobile'];
    occupation = json['occupation'];
    connectionTypeId = json['connection_type_id'];
    time = json['time'];
    date = json['date'];
    remind = json['remind'];
    notes = json['notes'];
    meetingRequired = json['meeting_required'];
    meetingCount = json['meeting_count'];
    meetingHappen = json['meeting_happen'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['mobile'] = mobile;
    data['occupation'] = occupation;
    data['connection_type_id'] = connectionTypeId;
    data['time'] = time;
    data['date'] = date;
    data['remind'] = remind;
    data['notes'] = notes;
    data['meeting_required'] = meetingRequired;
    data['path'] = path;
    data['meeting_count'] = meetingCount;
    data['meeting_happen'] = meetingHappen;
    return data;
  }
}
