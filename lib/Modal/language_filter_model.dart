class LanguageFilterModel {
  bool? status;
  List<LanguagesData>? languages;

  LanguageFilterModel({this.status, this.languages});

  LanguageFilterModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['languages'] != null) {
      languages = <LanguagesData>[];
      json['languages'].forEach((v) {
        languages!.add(new LanguagesData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (languages != null) {
      data['languages'] = languages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LanguagesData {
  String? id;
  String? value;

  LanguagesData({this.id, this.value});

  LanguagesData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['value'] = value;
    return data;
  }
}
