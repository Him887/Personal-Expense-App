import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTransaction;

  NewTransaction(this.addNewTransaction);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {

  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime selectedDate;

  void submitData() {
    final enteredTitle = titleController.text;
    final enteredamount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredamount <= 0 || selectedDate == null) {
      return;
    }

    widget.addNewTransaction(enteredTitle, enteredamount, selectedDate);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2019),
            lastDate: DateTime.now())
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
      selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.only(
              left: 10,
              top: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10
            ),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: "Title"),
                  controller: titleController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                ),
                TextField(
                  decoration: InputDecoration(labelText: "Amount"),
                  controller: amountController,
                  keyboardType: TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  onSubmitted: (_) => submitData(),
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: Text(selectedDate == null ? "No Date Chosen!!" :  "${DateFormat.yMMMd().format(selectedDate)}")),
                      FlatButton(
                          textColor: Theme.of(context).primaryColor,
                          onPressed: _presentDatePicker,
                          child: Text(
                            "Pick Date",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                    ],
                  ),
                ),
                RaisedButton(
                  child: Text("Add Transaction"),
                  onPressed: submitData,
                  textColor: Theme.of(context).textTheme.button.color,
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          )),
    );
  }
}
