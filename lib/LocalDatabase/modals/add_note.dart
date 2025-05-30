class AddNote {
  int? id;
  String? title;
  String? description;
  String? folderName;
  String? createdDate;

  AddNote(
      {this.id,
      this.title,
      this.description,
      this.folderName,
      this.createdDate});

  AddNote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    folderName = json['folderName'];
    createdDate = json['createdDate'];
  }

//
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['folderName'] = folderName;
    data['createdDate'] = createdDate;
    return data;
  }
}
