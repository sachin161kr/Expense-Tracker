import 'dart:math';

import 'package:expense/expense.dart';
import 'package:expense/expense_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //Directory appDocumentDirectory = await getApplicationDocumentsDirectory();
  runApp(MaterialApp(
    home: MyApp(),
    theme: ThemeData(
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.black),
      primaryColor: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      fontFamily: 'Ubuntu',
      accentColor: Colors.purple,
      primarySwatch: Colors.purple,
    ),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var amountController = TextEditingController();
  var descriptionController = TextEditingController();
  var formkey = GlobalKey();

  List<String> amount = [];
  List<String> description = [];

  List<Expense> expense = [];

  num sum = 0;

  @override
  void initState() {
    super.initState();
    refreshExpenses();
  }

  Future refreshExpenses() async {
    this.expense = await ExpenseDatabase.instance.readAllExpenses();
    sum = 0;
    for (int i = 0; i < expense.length; i++) {
      sum = sum + expense[i].money;
    }
    setState(() {});
  }

  Future addExpense(num money, String des, DateTime createdTime) async {
    final expense = Expense(money: money, des: des, createdTime: createdTime);

    await ExpenseDatabase.instance.create(expense);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.attach_money),
        title: Text('My Expense Tracker'),
      ),
      body: Column(
        children: [
          sum != 0
              ? Container(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Total Expense : ' + sum.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await ExpenseDatabase.instance.deleteAll();
                            refreshExpenses();
                            setState(() {});
                          },
                          // borderSide: BorderSide(
                          //   color: Colors.purple,
                          //   width: 2,
                          // ),
                          child: Text(
                            'Clear all Expenses',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                    ],
                  ),
                )
              : SizedBox(
                  height: 150,
                ),
          Container(
            height: MediaQuery.of(context).size.height * 0.73,
            child: Stack(
              children: [
                expense.length == 0
                    ? Center(
                        child: Text(
                        'No Expense Yet!',
                        style: TextStyle(fontSize: 40, color: Colors.white),
                        textAlign: TextAlign.center,
                      ))
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return InkWell(
                            onLongPress: () async {
                              await ExpenseDatabase.instance
                                  .delete(expense[index].id!);
                              refreshExpenses();
                              setState(() {});
                            },
                            child: Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                  top: 10, left: 20, right: 20, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.purple,
                                    width: 2,
                                  )),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 290,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Amount : ' +
                                                expense[index].money.toString(),
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            expense[index].des,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            DateFormat('dd-MM-yyyy')
                                                .add_jm()
                                                .format(
                                                    expense[index].createdTime),
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 35,
                                    ),
                                    InkWell(
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                      onTap: () async {
                                        await ExpenseDatabase.instance
                                            .delete(expense[index].id!);
                                        refreshExpenses();

                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: expense.length,
                      ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.62,
                      left: MediaQuery.of(context).size.width * 0.8),
                  child: FloatingActionButton(
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (builder) {
                            return Container(
                              key: formkey,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, left: 40, right: 40),
                                    child: TextFormField(
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                      controller: descriptionController,
                                      decoration: InputDecoration(
                                          hintText: 'Description',
                                          hintStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20.0, left: 40, right: 40),
                                    child: TextFormField(
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                      keyboardType: TextInputType.number,
                                      controller: amountController,
                                      decoration: InputDecoration(
                                          hintText: 'Enter Amount',
                                          hintStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18)),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                                RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ))),
                                        onPressed: () {
                                          // amount.add(amountController.text);
                                          // description.add(descriptionController.text);
                                          // amountController.text = '';
                                          // descriptionController.text = '';
                                          var money =
                                              num.parse(amountController.text);
                                          var des = descriptionController.text;
                                          addExpense(
                                              money, des, DateTime.now());
                                          amountController.text = '';
                                          descriptionController.text = '';
                                          refreshExpenses();

                                          setState(() {});
                                          Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Add Expense',
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
