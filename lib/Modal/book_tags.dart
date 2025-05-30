class BooksTags {
  List<BooksTagsData>? data;
  String? message;

  BooksTags({this.data, this.message});

  BooksTags.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BooksTagsData>[];
      json['data'].forEach((v) {
        data!.add(BooksTagsData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class BooksTagsData {
  String? id;
  String? tags;
  String? path;

  BooksTagsData({this.id, this.tags, this.path});

  BooksTagsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tags = json['tags'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['tags'] = this.tags;
    data['path'] = this.path;
    return data;
  }
}
