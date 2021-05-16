import 'package:expense_tracker/model/expenseModel.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// List<ExpenseModel> _expense = [];
List<ExpenseModel> _expenseN = [];

var box = Hive.openBox('storage');

class ExpenseProvider with ChangeNotifier {
  get returnExpense {
    List data = Hive.box('storage').get('data');
    _expenseN.clear();
    data.forEach((element) {
      _expenseN.add(ExpenseModel(
          title: element['title'],
          limit: element['limit'],
          entries: element['entries']
              .map((e) => ExpenseEntry(title: e['title'], amount: e['amount']))
              .toList()));
    });
    return [..._expenseN];
  }

  void addExpense({title, limit}) {
    _expenseN.add(
        ExpenseModel(title: title, limit: double.parse(limit), entries: []));
    updateStorage();
    notifyListeners();
  }

  void addExpenseEntry({title, amount, index}) {
    _expenseN[index]
        .entries
        .add(ExpenseEntry(title: title, amount: double.parse(amount)));
    updateStorage();
    notifyListeners();
  }

  double computerMoney({index}) {
    double amount = 0;
    _expenseN[index].entries.forEach((element) {
      amount += (element.amount);
    });
    return amount;
  }

  void updateStorage() async {
    List data = [];
    _expenseN.forEach((element) {
      data.add({
        'title': element.title,
        'limit': element.limit,
        'entries': element.entries
            .map((e) => {'amount': e.amount, 'title': e.title})
            .toList()
      });
    });
    await Hive.box('storage').put('data', data);
  }
}
