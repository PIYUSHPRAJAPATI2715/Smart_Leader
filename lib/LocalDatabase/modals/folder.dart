class Folder {
  int? id;
  String? folderName;
  String? createdOn;

  Folder({this.id, this.folderName, this.createdOn});

  Folder.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    folderName = json['folderName'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['folderName'] = folderName;
    data['createdOn'] = createdOn;
    return data;
  }
}
