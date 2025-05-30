class DownloadEbooksModal {
  List<DownloadEbooksModalData>? data;
  String? message;

  DownloadEbooksModal({this.data, this.message});

  DownloadEbooksModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <DownloadEbooksModalData>[];
      json['data'].forEach((v) {
        data!.add(new DownloadEbooksModalData.fromJson(v));
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

class DownloadEbooksModalData {
  int? id;
  String? userId;
  String? orderId;
  String? bookId;
  String? grandTotal;
  String? paymentStatus;
  String? type;
  String? strtotime;
  Book? book;
  String? path;

  DownloadEbooksModalData(
      {this.id,
        this.userId,
        this.orderId,
        this.bookId,
        this.grandTotal,
        this.paymentStatus,
        this.type,
        this.strtotime,
        this.book,
        this.path});

  DownloadEbooksModalData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderId = json['order_id'];
    bookId = json['book_id'];
    grandTotal = json['grand_total'];
    paymentStatus = json['payment_status'];
    type = json['type'];
    strtotime = json['strtotime'];
    book = json['book'] != null ? new Book.fromJson(json['book']) : null;
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['order_id'] = this.orderId;
    data['book_id'] = this.bookId;
    data['grand_total'] = this.grandTotal;
    data['payment_status'] = this.paymentStatus;
    data['type'] = this.type;
    data['strtotime'] = this.strtotime;
    if (this.book != null) {
      data['book'] = this.book!.toJson();
    }
    data['path'] = this.path;
    return data;
  }
}

class Book {
  int? id;
  String? tagId;
  String? bookName;
  String? writerName;
  String? description;
  String? image;
  String? bookPrice;
  String? amazonLink;
  String? amazonPrice;
  String? flipkartLink;
  String? flipkartPrice;
  String? bookAudio;
  String? file;
  String? eBookPrice;
  String? audioFile;
  String? audioPrice;

  Book(
      {this.id,
        this.tagId,
        this.bookName,
        this.writerName,
        this.description,
        this.image,
        this.bookPrice,
        this.amazonLink,
        this.amazonPrice,
        this.flipkartLink,
        this.flipkartPrice,
        this.bookAudio,
        this.file,
        this.eBookPrice,
        this.audioFile,
        this.audioPrice});

  Book.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tagId = json['tag_id'];
    bookName = json['book_name'];
    writerName = json['writer_name'];
    description = json['description'];
    image = json['image'];
    bookPrice = json['book_price'];
    amazonLink = json['amazon_link'];
    amazonPrice = json['amazon_price'];
    flipkartLink = json['flipkart_link'];
    flipkartPrice = json['flipkart_price'];
    bookAudio = json['book_audio'];
    file = json['file'];
    eBookPrice = json['e_book_price'];
    audioFile = json['audio_file'];
    audioPrice = json['audio_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tag_id'] = this.tagId;
    data['book_name'] = this.bookName;
    data['writer_name'] = this.writerName;
    data['description'] = this.description;
    data['image'] = this.image;
    data['book_price'] = this.bookPrice;
    data['amazon_link'] = this.amazonLink;
    data['amazon_price'] = this.amazonPrice;
    data['flipkart_link'] = this.flipkartLink;
    data['flipkart_price'] = this.flipkartPrice;
    data['book_audio'] = this.bookAudio;
    data['file'] = this.file;
    data['e_book_price'] = this.eBookPrice;
    data['audio_file'] = this.audioFile;
    data['audio_price'] = this.audioPrice;
    return data;
  }
}
