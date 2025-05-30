class ShowStaticFolderModal {
  List<ShowStaticFolderModalData>? data;
  String? message;

  ShowStaticFolderModal({this.data, this.message});

  ShowStaticFolderModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ShowStaticFolderModalData>[];
      json['data'].forEach((v) {
        data!.add(new ShowStaticFolderModalData.fromJson(v));
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

class ShowStaticFolderModalData {
  String? id;
  String? foderName;
  int? noteCount;
  String? path;

  ShowStaticFolderModalData({this.id, this.foderName, this.noteCount, this.path});

  ShowStaticFolderModalData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    foderName = json['foder_name'];
    noteCount = json['note_count'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['foder_name'] = this.foderName;
    data['note_count'] = this.noteCount;
    data['path'] = this.path;
    return data;
  }
}
