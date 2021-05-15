import 'package:flutter/material.dart';

class ExpenseModel {
  String title;
  double limit;
  List entries = [];
  ExpenseModel({@required this.title, @required this.limit, this.entries});
}

class ExpenseEntry {
  String title;
  double amount;

  ExpenseEntry({@required this.title, @required this.amount});
}
