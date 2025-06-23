class ShowBookListModal {
  List<Data>? data;
  String? message;

  ShowBookListModal({this.data, this.message});

  ShowBookListModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? id;
  String? languageKey;
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
  String? eBookPrice;
  String? audioPrice;
  String? path;

  Data(
      {this.id,
        this.languageKey,
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
        this.eBookPrice,
        this.audioPrice,
        this.path});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    languageKey = json['language_key'];
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
    eBookPrice = json['e_book_price'];
    audioPrice = json['audio_price'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['language_key'] = this.languageKey;
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
    data['e_book_price'] = this.eBookPrice;
    data['audio_price'] = this.audioPrice;
    data['path'] = this.path;
    return data;
  }
}
