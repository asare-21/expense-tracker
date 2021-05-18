import 'dart:io';

import 'package:expense_tracker/model/expenseModel.dart';
import 'package:expense_tracker/pages/chart.dart';
import 'package:expense_tracker/pages/instructionpage.dart';
import 'package:expense_tracker/provider/expenseProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

int index1 = 0;
TextEditingController title = TextEditingController();
TextEditingController limit = TextEditingController();

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    List<ExpenseModel> _expense =
        Provider.of<ExpenseProvider>(context).returnExpense;
    return Scaffold(
      drawer: Drawer(
        elevation: 1,
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => Platform.isIOS
                      ? CupertinoAlertDialog(
                          title: Text('New Expnese Entry'),
                          content: Container(
                            height: 100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: CupertinoTextField(
                                    enableSuggestions: true,
                                    controller: title,
                                    placeholder: 'Name this Expense track',
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  child: CupertinoTextField(
                                    enableSuggestions: true,
                                    controller: limit,
                                    keyboardType:
                                        TextInputType.numberWithOptions(
                                            decimal: true, signed: true),
                                    placeholder: 'What\'s your spending limit?',
                                  ),
                                )
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text('Save'),
                              onPressed: () {
                                var pattern = RegExp(r'^[0-9]\d*(\.\d+)?$');
                                if (!pattern.hasMatch(limit.text)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor:
                                              Theme.of(context).errorColor,
                                          content: Text(
                                              'Only numerical values allowed')));
                                } else {
                                  Provider.of<ExpenseProvider>(context,
                                          listen: false)
                                      .addExpense(
                                          limit: limit.text, title: title.text);
                                  limit.clear();
                                  title.clear();
                                  Navigator.pop(context);
                                }
                              },
                            )
                          ],
                        )
                      : AlertDialog(
                          actions: [
                            TextButton(
                              child: Text('Save'),
                              onPressed: () {
                                Provider.of<ExpenseProvider>(context,
                                        listen: false)
                                    .addExpense(
                                        limit: limit.text, title: title.text);
                                limit.clear();
                                title.clear();
                                Navigator.pop(context);
                              },
                            )
                          ],
                          title: Text('New Expense Track'),
                          content: Container(
                            height: 200,
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text('Title'),
                                  subtitle: TextField(
                                    controller: title,
                                  ),
                                ),
                                ListTile(
                                  title: Text('Shopping Limit'),
                                  subtitle: TextField(
                                    controller: limit,
                                    keyboardType: Platform.isAndroid
                                        ? TextInputType.number
                                        : TextInputType.numberWithOptions(
                                            decimal: true, signed: true),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                );
              },
              title: Text('New Track'),
              leading: Icon(Icons.add),
              subtitle: Text('Start a new expense track'),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => InstructionPage(),
                ));
              },
              title: Text('Instructions'),
              subtitle: Text('Learn how to the Expense Tracker'),
              leading: Icon(Icons.directions),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.black,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Platform.isIOS
                ? CupertinoAlertDialog(
                    title: Text('New Entry'),
                    content: Container(
                      height: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: CupertinoTextField(
                              enableSuggestions: true,
                              controller: title,
                              placeholder: 'What did you buy?',
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: CupertinoTextField(
                              enableSuggestions: true,
                              controller: limit,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true, signed: true),
                              placeholder: 'Amount Spent',
                            ),
                          )
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text('Save'),
                        onPressed: () {
                          var pattern = RegExp(r'^[0-9]\d*(\.\d+)?$');
                          if (!pattern.hasMatch(limit.text)) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Theme.of(context).errorColor,
                                content:
                                    Text('Only numerical values allowed')));
                          } else {
                            if (_expense[index1].limit >
                                double.parse(limit.text)) {
                              Provider.of<ExpenseProvider>(context,
                                      listen: false)
                                  .addExpenseEntry(
                                      index: index1,
                                      amount: limit.text,
                                      title: title.text);
                              Navigator.pop(context);
                              limit.clear();
                              title.clear();
                            } else {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                    'Sorry, This can\'t be added. It\'s above your set Limit.'),
                              ));
                            }
                          }
                        },
                      )
                    ],
                  )
                : AlertDialog(
                    actions: [
                      TextButton(
                        child: Text('Save'),
                        onPressed: () {
                          var pattern = RegExp(r'^[0-9]\d*(\.\d+)?$');
                          if (!pattern.hasMatch(limit.text)) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                backgroundColor: Theme.of(context).errorColor,
                                content:
                                    Text('Only numerical values allowed')));
                          } else {
                            if (_expense[index1].limit >
                                double.parse(limit.text)) {
                              Provider.of<ExpenseProvider>(context,
                                      listen: false)
                                  .addExpenseEntry(
                                      index: index1,
                                      amount: limit.text,
                                      title: title.text);
                              Navigator.pop(context);
                              limit.clear();
                              title.clear();
                            } else {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                    'Sorry, This can\'t be added. It\'s above your set Limit.'),
                              ));
                            }
                          }
                        },
                      )
                    ],
                    title: Text('New Entry'),
                    content: Container(
                      height: 200,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text('Title'),
                            subtitle: TextField(
                              controller: title,
                            ),
                          ),
                          ListTile(
                            title: Text('Amount Spent'),
                            subtitle: TextFormField(
                              controller: limit,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true, signed: true),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
          );
        }),
        title: Text('Expenses'),
      ),
      body: _expense.length == 0
          ? Center(
              child: Text('Nothing to Show'),
            )
          : Column(
              children: [
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(10),
                  child: Chart(
                    expenseModel: _expense[index1],
                  ),
                ),
                Expanded(
                    child: _expense.length == 0
                        ? Container(
                            child: Center(
                              child: Text('No Entries'),
                            ),
                          )
                        : Column(
                            children: [
                              Container(
                                height: 60,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.all(10),
                                  itemCount: _expense.length,
                                  itemBuilder: (context, index) {
                                    // index1 += 1;
                                    return Container(
                                      margin: const EdgeInsets.all(5),
                                      child: ElevatedButton(
                                        onLongPress: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => Platform.isIOS
                                                ? CupertinoAlertDialog(
                                                    actions: [
                                                      CupertinoButton(
                                                          child: Text('Cancel'),
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context)),
                                                      CupertinoButton(
                                                        child: Text(
                                                          'Proceed',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.red),
                                                        ),
                                                        onPressed: () {
                                                          Provider.of<ExpenseProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .removeExpenseTrack(
                                                                  index: index);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                      )
                                                    ],
                                                    content: Text(
                                                      'You are deleting an expense track',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )
                                                : AlertDialog(
                                                    content: Text(
                                                        'You are deleting an expense track'),
                                                  ),
                                          );
                                        },
                                        onPressed: () {
                                          setState(() {
                                            index1 = index;
                                          });
                                        },
                                        child: Text(_expense[index].title),
                                        style: ButtonStyle(
                                          elevation:
                                              MaterialStateProperty.all(2),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  index1 == index
                                                      ? Theme.of(context)
                                                          .accentColor
                                                      : Colors.grey),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50))),
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                width: MediaQuery.of(context).size.width,
                                child: Consumer<ExpenseProvider>(
                                  builder: (context, value, child) => ListTile(
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Spend Limit',
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text('Spent',
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    subtitle: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            'GHS ${value.returnExpense[index1].limit}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                            'GHS ${value.computerMoney(index: index1)}',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: value.computerMoney(
                                                            index: index1) >=
                                                        value
                                                            .returnExpense[
                                                                index1]
                                                            .limit
                                                    ? Colors.red
                                                    : Colors.grey)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              _expense.length == 0
                                  ? Container()
                                  : _expense[index1].entries.length == 0
                                      ? Expanded(
                                          child: Center(
                                            child: Text('No Entries'),
                                          ),
                                        )
                                      : Expanded(
                                          child: ListView.builder(
                                          itemCount:
                                              _expense[index1].entries.length,
                                          itemBuilder: (context, index) =>
                                              Dismissible(
                                            direction:
                                                DismissDirection.startToEnd,
                                            background: Container(
                                              alignment: Alignment.centerLeft,
                                              padding: const EdgeInsets.all(10),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.delete_forever,
                                                    size: 30,
                                                    color: Theme.of(context)
                                                        .errorColor,
                                                  ),
                                                  Text(
                                                    'Delete Forever',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                ],
                                              ),
                                            ),
                                            key: Key(DateTime.now().toString()),
                                            onDismissed: (direction) =>
                                                Provider.of<ExpenseProvider>(
                                                        context,
                                                        listen: false)
                                                    .removeExpenseTrack(
                                              index: index,
                                            ),
                                            child: ListTile(
                                              leading: Icon(Icons.money),
                                              title: Text(_expense[index1]
                                                  .entries[index]
                                                  .title),
                                              trailing: Text(
                                                  'GHS ${_expense[index1].entries[index].amount}'),
                                            ),
                                          ),
                                        ))
                            ],
                          ))
              ],
            ),
    );
  }
}
