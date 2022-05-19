import 'dart:core';

import 'package:flutter/material.dart';
import 'package:izibagde/model/database_test.dart';

class CheckListForm extends StatefulWidget {
  //const CheckListForm({Key? key}) : super(key: key);
  late final String documentId;

  CheckListForm({required this.documentId});

  @override
  _CheckListFormState createState() => _CheckListFormState();
}

class _CheckListFormState extends State<CheckListForm> {
  bool _isProcessing = false;
  late List<String> lstEmail = [];
  late List<bool> lstStatus = [];


  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(20),
        child: /*_isProcessing
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                    // valueColor: AlwaysStoppedAnimation<Color>(
                    //   CustomColors.accentLight,
                    // ),
                    ),
              ),
            )
          :*/
            createTable()
        /*Table(
        border: TableBorder.all(
            color: Colors.black, style: BorderStyle.solid, width: 2),
        children:  [
          TableRow(children: [
            Column(children: [Text('No', style: TextStyle(fontSize: 20.0))]),
            Column(children: [
              Text("Email d'invités", style: TextStyle(fontSize: 20.0))
            ]),
            Column(children: [Text('État', style: TextStyle(fontSize: 20.0))]),
          ]),
          createTable(lstEmail,lstStatus)
          ]*/
        );
  }

  Widget createTable() {
    debugPrint("1");

    setState(() {
      lstEmail = DatabaseTest.lstInviteChecked.keys.toList(growable: false);
      lstStatus = DatabaseTest.lstInviteChecked.values.toList(growable: false);
      debugPrint("size: ${lstStatus.length}");
      debugPrint(lstEmail[0]);
      debugPrint(lstStatus[0].toString());
      debugPrint("2");
    });
    debugPrint("3");
    List<TableRow> rows = [];
    rows.add(const TableRow(
      children: [
        Center(
            child: Text(
          "No ",
        )),
        Center(
            child: Text(
          "Email d'invités ",
        )),
        Center(
            child: Text(
          "État ",
        )),
      ],
    ));
    for (int i = 0; i < lstEmail.length; i++) {
      debugPrint("size: ${lstEmail.length}");
      rows.add(TableRow(children: [
        Center(child: Text((i+1).toString())),
        Center(
            child: Text(
          lstEmail[i],
        )),
        Center(
            child: Text(
          lstStatus[i].toString(),
        )),
      ]));
    }
    debugPrint("4");
    if (_isProcessing) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(
              // valueColor: AlwaysStoppedAnimation<Color>(
              //   CustomColors.accentLight,
              // ),
              ),
        ),
      );
    } else {
      setState(() {
        _isProcessing = true;
      });
      return Table(
          border: const TableBorder(
            bottom: BorderSide(color: Colors.red, width: 2),
            horizontalInside: BorderSide(color: Colors.red, width: 2),
            ),
          children: rows,
      columnWidths: const <int, TableColumnWidth> {
        0: FixedColumnWidth(20),
        1: FlexColumnWidth(30),
        2: MaxColumnWidth(FlexColumnWidth(2), FractionColumnWidth(0.3)),
      },
      );
    }
  }
}
