import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:personal_expenses/models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;

  TransactionList(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(children: [
              Text(
                "No Item",
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 10),
              Container(
                  height: constraints.maxHeight * 0.5,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  )),
            ]);
          })
        : ListView.builder(
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                          padding: EdgeInsets.all(6),
                          child: FittedBox(
                              child: Text("\$${transactions[index].amount}")))),
                  title: Text(
                    "${transactions[index].title}",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle: Text(
                      "${DateFormat.yMMMd().format(transactions[index].date)}"),
                  trailing: MediaQuery.of(context).size.width > 460? 
                    FlatButton.icon(
                      onPressed: () {
                        deleteTransaction(transactions[index].id);
                      }, 
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).errorColor,
                        size: 35,
                      ), 
                      label: Text("Delete"))
                   : IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).errorColor,
                        size: 35,
                      ),
                      onPressed: () {
                        deleteTransaction(transactions[index].id);
                      }),
                ),
              );
            },
            itemCount: transactions.length,
          );
  }
}
