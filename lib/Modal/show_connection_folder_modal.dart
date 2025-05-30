class ShowConnectionFolderModal {
  int? totalConnections;
  List<ShowConnectionFolderModalData>? data;
  String? message;

  ShowConnectionFolderModal({this.totalConnections, this.data, this.message});

  ShowConnectionFolderModal.fromJson(Map<String, dynamic> json) {
    totalConnections = json['total_connections'];
    if (json['data'] != null) {
      data = <ShowConnectionFolderModalData>[];
      json['data'].forEach((v) {
        data!.add(new ShowConnectionFolderModalData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_connections'] = this.totalConnections;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class ShowConnectionFolderModalData {
  dynamic id;
  String? name;
  int? connectionCount;
  String? path;

  ShowConnectionFolderModalData({this.id, this.name, this.connectionCount, this.path});

  ShowConnectionFolderModalData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    connectionCount = json['connection_count'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['connection_count'] = this.connectionCount;
    data['path'] = this.path;
    return data;
  }
}
