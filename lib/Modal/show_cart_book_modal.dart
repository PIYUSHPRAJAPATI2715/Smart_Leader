class ShowCartBookModal {
  List<ShowCartBookModalData>? data;
  int? totalPrice;
  String? message;

  ShowCartBookModal({this.data, this.totalPrice, this.message});

  ShowCartBookModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ShowCartBookModalData>[];
      json['data'].forEach((v) {
        data!.add(new ShowCartBookModalData.fromJson(v));
      });
    }
    totalPrice = json['total_price'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total_price'] = this.totalPrice;
    data['message'] = this.message;
    return data;
  }
}

class ShowCartBookModalData {
  String? id;
  String? userId;
  String? bookId;
  String? bookPrice;
  String? strtotime;
  String? status;
  String? bookName;
  String? image;
  String? writerName;
  String? path;

  ShowCartBookModalData(
      {this.id,
        this.userId,
        this.bookId,
        this.bookPrice,
        this.strtotime,
        this.status,
        this.bookName,
        this.image,
        this.writerName,
        this.path});

  ShowCartBookModalData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bookId = json['book_id'];
    bookPrice = json['book_price'];
    strtotime = json['strtotime'];
    status = json['status'];
    bookName = json['book_name'];
    image = json['image'];
    writerName = json['writer_name'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['book_id'] = this.bookId;
    data['book_price'] = this.bookPrice;
    data['strtotime'] = this.strtotime;
    data['status'] = this.status;
    data['book_name'] = this.bookName;
    data['image'] = this.image;
    data['writer_name'] = this.writerName;
    data['path'] = this.path;
    return data;
  }
}
