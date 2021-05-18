import 'package:expense_tracker/model/expenseModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';

import '../main.dart';

// List<ExpenseModel> _expense = [];
List<ExpenseModel> _expenseN = [];

var box = Hive.openBox('storage');

class ExpenseProvider with ChangeNotifier {
  get returnExpense {
    // Returns saced expense tracks with their respective entries
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
    // Create a new expense track
    _expenseN.add(
        ExpenseModel(title: title, limit: double.parse(limit), entries: []));
    updateStorage();
    notifyListeners();
  }

  void addExpenseEntry({title, amount, index}) {
    // add an expense entry to an expense track
    _expenseN[index]
        .entries
        .add(ExpenseEntry(title: title, amount: double.parse(amount)));
    showNotification(index);
    updateStorage();
    notifyListeners();
  }

  double computerMoney({index}) {
    // compute the total money spent
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

  void removeExpenseTrack({int index}) {
    _expenseN.removeAt(index);
    updateStorage();
    notifyListeners();
  }

  void removeExpenseEntry({int index, subIndex}) {
    _expenseN[index].entries.removeAt(subIndex);
    updateStorage();
    notifyListeners();
  }

  void showNotification(int index) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails();
    double moneySpent = 0;
    _expenseN[index].entries.forEach((entry) {
      moneySpent += entry.amount;
    });
    if (moneySpent > (_expenseN[index].limit * .8)) {
      await flutterLocalNotificationsPlugin.show(
          DateTime.now().millisecond,
          'Expense Tracker',
          'Your are approaching your spending limit. You have spent GHS $moneySpent.',
          platformChannelSpecifics);
    }
    if (moneySpent == _expenseN[index].limit ||
        moneySpent >= _expenseN[index].limit) {
      await flutterLocalNotificationsPlugin.show(
          DateTime.now().millisecond,
          'Expense Tracker',
          'You have exceeded your spending limit. You have spent GHS $moneySpent. Your spending limit is ${_expenseN[index].limit}',
          platformChannelSpecifics);
    }
  }
}
