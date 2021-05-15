import 'package:expense_tracker/model/expenseModel.dart';
import 'package:expense_tracker/pages/chart.dart';
import 'package:expense_tracker/provider/expenseProvider.dart';
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
                  builder: (context) => AlertDialog(
                    actions: [
                      TextButton(
                        child: Text('Save'),
                        onPressed: () {
                          Provider.of<ExpenseProvider>(context, listen: false)
                              .addExpense(limit: limit.text, title: title.text);
                          limit.clear();
                          title.clear();
                          Navigator.pop(context);
                        },
                      )
                    ],
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
                            title: Text('Limit'),
                            subtitle: TextField(
                              controller: limit,
                              keyboardType: TextInputType.number,
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
            )
          ],
        ),
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
              child: Text('Nothingg to Show'),
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
                                    return ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          index1 = index;
                                        });
                                      },
                                      onLongPress: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            actions: [
                                              TextButton(
                                                child: Text('Save'),
                                                onPressed: () {
                                                  if (_expense[index1].limit >
                                                      double.parse(
                                                          limit.text)) {
                                                    Provider.of<ExpenseProvider>(
                                                            context,
                                                            listen: false)
                                                        .addExpenseEntry(
                                                            index: index,
                                                            amount: limit.text,
                                                            title: title.text);
                                                    Navigator.pop(context);
                                                    limit.clear();
                                                    title.clear();
                                                  } else {
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(SnackBar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Text(
                                                          'Sorry, This can\'t be added. It\'s above your set Limit.'),
                                                    ));
                                                  }
                                                },
                                              )
                                            ],
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
                                                    subtitle: TextField(
                                                      controller: limit,
                                                      keyboardType:
                                                          TextInputType.number,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text(_expense[index].title),
                                      style: ButtonStyle(
                                        elevation: MaterialStateProperty.all(2),
                                        backgroundColor:
                                            MaterialStateProperty.all(index1 ==
                                                    index
                                                ? Theme.of(context).accentColor
                                                : Colors.grey),
                                        shape: MaterialStateProperty.all(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50))),
                                        alignment: Alignment.center,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              _expense[index1].entries.length == 0
                                  ? Expanded(
                                      child: Center(
                                        child: Text('Nothing to Show'),
                                      ),
                                    )
                                  : Container(
                                      padding: const EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width,
                                      child: Consumer<ExpenseProvider>(
                                        builder: (context, value, child) =>
                                            ListTile(
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Spend Limit',
                                                style: TextStyle(
                                                    fontSize: 25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text('Spent',
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold)),
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
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  'GHS ${value.computerMoney(index: index1)}',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                              _expense.length == 0
                                  ? Container()
                                  : _expense[index1].entries.length == 0
                                      ? Container()
                                      : Expanded(
                                          child: ListView.builder(
                                          itemCount:
                                              _expense[index1].entries.length,
                                          itemBuilder: (context, index) =>
                                              ListTile(
                                            leading: Icon(Icons.money),
                                            title: Text(_expense[index1]
                                                .entries[index]
                                                .title),
                                            trailing: Text(
                                                'GHS ${_expense[index1].entries[index].amount}'),
                                          ),
                                        ))
                            ],
                          ))
              ],
            ),
    );
  }
}
