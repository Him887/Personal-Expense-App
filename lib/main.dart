import 'package:flutter/material.dart';
import 'package:personal_expenses/widgets/chart.dart';
import 'package:personal_expenses/widgets/new_transaction.dart';
import 'package:personal_expenses/widgets/transactionList.dart';
import './models/transaction.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          fontFamily: "Quicksand",
          errorColor: Colors.red,
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                    fontFamily: "OpenSans",
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                button: TextStyle(
                  color: Colors.white,
                ),
              ),
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                    fontFamily: "OpenSans",
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showChart = false;

  final List<Transaction> _userTransactions = [
    Transaction(id: "t1", title: "Shoes", amount: 342, date: DateTime.now()),
    Transaction(id: "t2", title: "Laptop", amount: 233, date: DateTime.now()),
    Transaction(
        id: "t3", title: "Cellphone", amount: 412, date: DateTime.now()),
    Transaction(id: "t4", title: "Watch", amount: 233, date: DateTime.now()),
    Transaction(id: "t5", title: "Clothes", amount: 213, date: DateTime.now()),
    Transaction(id: "t1", title: "Shoes", amount: 342, date: DateTime.now()),
    Transaction(id: "t2", title: "Laptop", amount: 233, date: DateTime.now()),
    Transaction(
        id: "t3", title: "Cellphone", amount: 412, date: DateTime.now()),
    Transaction(id: "t4", title: "Watch", amount: 233, date: DateTime.now()),
    Transaction(id: "t5", title: "Clothes", amount: 213, date: DateTime.now()),
  ];

  void _addNewTransaction(String title, double amount, DateTime dateTime) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: title,
        amount: amount,
        date: dateTime);

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) {
        return element.id == id;
      });
    });
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(
            _addNewTransaction,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text("Flutter App"),
      actions: [
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _startAddNewTransaction(context);
            })
      ],
    );
    final txListWidget = Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTransaction)
        );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Show Chart"),
                  Switch(
                    value: showChart,
                    onChanged: (val) {
                      setState(() {
                        showChart = val;
                      });
                    },
                  ),
                ],
              ),
              if(!isLandscape) Container(
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.3,
                  child: Chart(_recentTransactions)
                  ),
              if(!isLandscape) txListWidget,
              if(isLandscape) showChart ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7,
                      width: (MediaQuery.of(context).size.width * 0.5),
                      child: Chart(_recentTransactions)
                      ),
                ],
              ) : txListWidget,
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            _startAddNewTransaction(context);
          }),
    );
  }
}
