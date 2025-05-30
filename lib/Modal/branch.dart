class Branch {
  List<BranchData>? data;
  String? message;

  Branch({this.data, this.message});

  Branch.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BranchData>[];
      json['data'].forEach((v) {
        data!.add(BranchData.fromJson(v));
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

class BranchData {
  String? id;
  String? userId;
  String? btanchName;
  String? path;

  BranchData({this.id, this.userId, this.btanchName, this.path});

  BranchData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    btanchName = json['btanch_name'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['btanch_name'] = btanchName;
    data['path'] = path;
    return data;
  }
}
