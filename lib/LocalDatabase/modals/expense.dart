
import 'package:flutter/material.dart';

class Expense {
  int? id;
  String? date;
  String? amount;
  String? category;
  String? note;
  String? type;
  String? readableDate;
  String? other;
  DateTime? dateTime;
  Color? color;

  Expense({
    this.id,
    this.date,
    this.amount,
    this.category,
    this.note,
    this.type,
    this.other,
    this.readableDate,
    this.dateTime,
    this.color
  });

  Expense.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    amount = json['amount'];
    category = json['category'];
    note = json['note'];
    type = json['type'];
    other = json['other'];
    readableDate = json['readableDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['amount'] = amount;
    data['category'] = category;
    data['note'] = note;
    data['type'] = type;
    data['other'] = other;
    data['readableDate'] = readableDate;
    return data;
  }
}
