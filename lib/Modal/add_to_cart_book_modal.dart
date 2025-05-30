class AddToCartBookModal {
  String? id;
  String? userId;
  String? bookId;
  String? bookPrice;
  String? strtotime;
  String? status;
  String? result;

  AddToCartBookModal(
      {this.id,
        this.userId,
        this.bookId,
        this.bookPrice,
        this.strtotime,
        this.status,
        this.result});

  AddToCartBookModal.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bookId = json['book_id'];
    bookPrice = json['book_price'];
    strtotime = json['strtotime'];
    status = json['status'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['book_id'] = this.bookId;
    data['book_price'] = this.bookPrice;
    data['strtotime'] = this.strtotime;
    data['status'] = this.status;
    data['result'] = this.result;
    return data;
  }
}
