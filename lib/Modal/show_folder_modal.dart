class ShowFolderModal {
  List<ShowFolderModalData>? data;
  String? message;

  ShowFolderModal({this.data, this.message});

  ShowFolderModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ShowFolderModalData>[];
      json['data'].forEach((v) {
        data!.add(new ShowFolderModalData.fromJson(v));
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

class ShowFolderModalData {
  String? id;
  String? userId;
  String? folderName;
  String? strtotime;
  int? noteCount;
  String? path;

  ShowFolderModalData(
      {this.id,
        this.userId,
        this.folderName,
        this.strtotime,
        this.noteCount,
        this.path});

  ShowFolderModalData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    folderName = json['folder_name'];
    strtotime = json['strtotime'];
    noteCount = json['note_count'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['folder_name'] = this.folderName;
    data['strtotime'] = this.strtotime;
    data['note_count'] = this.noteCount;
    data['path'] = this.path;
    return data;
  }
}
