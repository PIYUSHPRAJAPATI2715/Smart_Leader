class AddFolderModal {
  String? id;
  String? userId;
  String? folderName;
  String? strtotime;
  String? message;

  AddFolderModal(
      {this.id, this.userId, this.folderName, this.strtotime, this.message});

  AddFolderModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    folderName = json['folder_name'];
    strtotime = json['strtotime'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['folder_name'] = this.folderName;
    data['strtotime'] = this.strtotime;
    data['message'] = this.message;
    return data;
  }
}
