class ShowExpense {
  List<ShowExpenseData>? data;
  String? message;

  ShowExpense({this.data, this.message});

  ShowExpense.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <ShowExpenseData>[];
      json['data'].forEach((v) {
        data!.add(ShowExpenseData.fromJson(v));
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

class ShowExpenseData {
  String? id;
  String? userId;
  String? amount;
  String? reason;
  String? date;
  String? priority;
  String? path;

  ShowExpenseData(
      {this.id,
      this.userId,
      this.amount,
      this.reason,
      this.date,
      this.priority,
      this.path});

  ShowExpenseData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    amount = json['amount'];
    reason = json['reason'];
    date = json['date'];
    priority = json['priority'];
    path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['amount'] = this.amount;
    data['reason'] = this.reason;
    data['date'] = this.date;
    data['priority'] = this.priority;
    data['path'] = this.path;
    return data;
  }
}
