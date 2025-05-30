class AddConnectionFolderModal {
  String? id;
  String? name;
  String? message;

  AddConnectionFolderModal({this.id, this.name, this.message});

  AddConnectionFolderModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['message'] = this.message;
    return data;
  }
}
