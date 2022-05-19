import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/model/database_test.dart';

class TableUserForm extends StatefulWidget {
  //const TableUserForm({Key? key}) : super(key: key);

  @override
  _TableUserFormState createState() => _TableUserFormState();
}

class _TableUserFormState extends State<TableUserForm> {
  int? sortColumnIndex; //pour mettre en orde (sorting)
  bool isAscending = false;
  int no = 0;
  final columns = ["Email d'invités", "État d'entrée"];
  late List<String> lstEmail = [];
  late List<bool> lstStatus = [];
  late List<String> lstCombine = [];

  @override
  void initState() {
    lstEmail = DatabaseTest.lstInviteChecked.keys.toList(growable: false);
    lstStatus = DatabaseTest.lstInviteChecked.values.toList(growable: false);
    for (int i = 0; i < lstStatus.length; i++) {
      String mess = lstEmail[i] + "-" + lstStatus[i].toString();
      lstCombine.add(mess);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: DataTable(
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(columns),
      rows: getRows(lstCombine),
      //headingRowColor: MaterialStateColor.resolveWith((states) => Colors.lightBlueAccent),
      headingTextStyle: const TextStyle(
          fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
      //horizontalMargin: 40,
    ));
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
          label: Center(
            child: Text(column),
          ),
          onSort: onSort))
      .toList();

  List<DataRow> getRows(List<String> combines) {
    return combines.map((String combineItem) {
      final cells = [combineItem.split("-").first, combineItem.split("-").last];
      return DataRow(cells: getCells(cells));
    }).toList();
  }

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Center(child: Text('$data')))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      lstCombine.sort((user1, user2) => compareString(
          ascending, user1.split("-").first, user2.split("-").first));
    } else if (columnIndex == 1) {
      lstCombine.sort((user1, user2) => compareString(
          ascending, user1.split("-").last, user2.split("-").last));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
