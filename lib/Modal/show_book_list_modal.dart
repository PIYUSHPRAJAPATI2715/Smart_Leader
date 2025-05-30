class ShowBookListModal {
  List<ShowBookListModalData>? data;
  String? message;

  ShowBookListModal({this.data, this.message});

  ShowBookListModal.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ShowBookListModalData>[];
      json['data'].forEach((v) {
        data!.add(new ShowBookListModalData.fromJson(v));
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

class ShowBookListModalData {
  String? id;
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
  String? path;

  ShowBookListModalData(
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
        this.audioPrice,
        this.path});

  ShowBookListModalData.fromJson(Map<String, dynamic> json) {
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

    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tag_id'] = tagId;
    data['book_name'] = bookName;
    data['writer_name'] = writerName;
    data['description'] = description;
    data['image'] = image;
    data['book_price'] = bookPrice;
    data['amazon_link'] = amazonLink;
    data['amazon_price'] = amazonPrice;
    data['flipkart_link'] = flipkartLink;
    data['flipkart_price'] = flipkartPrice;
    data['book_audio'] = bookAudio;
    data['file'] = file;
    data['e_book_price'] = eBookPrice;
    data['audio_file'] = audioFile;
    data['audio_price'] = audioPrice;

    data['path'] = path;
    return data;
  }
}
