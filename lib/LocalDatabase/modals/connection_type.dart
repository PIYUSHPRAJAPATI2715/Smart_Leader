class ConnectionType {
  int? id;
  String? name;
  String? connectionCount;

  ConnectionType({this.id, this.name, this.connectionCount});

  ConnectionType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    connectionCount = json['connectionCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['connectionCount'] = connectionCount;
    return data;
  }
}
