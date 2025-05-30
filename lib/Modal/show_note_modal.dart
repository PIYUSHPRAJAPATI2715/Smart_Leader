class ShowNoteModal {
  List<ShowNoteModalData>? data;
  String? message;

  ShowNoteModal({this.data, this.message});

  ShowNoteModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ShowNoteModalData>[];
      json['data'].forEach((v) {
        data!.add(new ShowNoteModalData.fromJson(v));
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

class ShowNoteModalData {
  String? id;
  String? folderId;
  String? userId;
  String? title;
  String? description;
  String? date;
  String? time;
  String? strtotime;
  String? path;
  bool isSelected =false;

  ShowNoteModalData(
      {this.id,
        this.folderId,
        this.userId,
        this.title,
        this.description,
        this.date,
        this.time,
        this.strtotime,
        this.path,
        this.isSelected=false
      });

  ShowNoteModalData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    folderId = json['folder_id'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    date = json['date'];
    time = json['time'];
    strtotime = json['strtotime'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['folder_id'] = this.folderId;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['date'] = this.date;
    data['time'] = this.time;
    data['strtotime'] = this.strtotime;
    data['path'] = this.path;
    return data;
  }
}
