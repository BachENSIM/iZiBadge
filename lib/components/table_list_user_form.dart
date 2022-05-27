import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/model/database_test.dart';

class TableUserForm extends StatefulWidget {
  //const TableUserForm({Key? key}) : super(key: key);
  late final String documentId;

  TableUserForm({required this.documentId});

  @override
  _TableUserFormState createState() => _TableUserFormState();
}

class _TableUserFormState extends State<TableUserForm> {
  int? sortColumnIndex; //pour mettre en orde (sorting)
  bool isAscending = false;
  int no = 0;
  final columns = ["Invités", "États", "Nb d'entrée"];
  late List<String> lstEmail = [];
  late List<bool> lstStatus = [];
  late List<String> lstCombine = [];
  late List<int> lstEnter = [];

  @override
  void initState() {
    lstEmail = DatabaseTest.lstInviteChecked.keys.toList(growable: false);
    lstStatus = DatabaseTest.lstInviteChecked.values.toList(growable: false);
    lstEnter = DatabaseTest.lstSizeInvite;
    for (int i = 0; i < lstStatus.length; i++) {
      String mess = lstEmail[i] +
          "-" +
          lstStatus[i].toString() +
          "-" +
          lstEnter[i].toString();
      lstCombine.add(mess);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Flexible(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        //Text("[Nombre d'entrée/Nombre Total] / "),

        //Flutter RefreshIndicator => Pull to refresh (swipe to refresh)
        RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 1));
              await DatabaseTest.fetchListInvite(docId: widget.documentId);

              setState(() {});
            },
            color: Colors.purple,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  sortAscending: isAscending,
                  sortColumnIndex: sortColumnIndex,
                  //columns: getColumns(columns),
                  columns: [
                    DataColumn(
                        label: Container(
                          width: width * .2,
                          child: Center(child: Text(columns[0])),
                        ),
                        onSort: onSort),
                    DataColumn(
                        label: Container(
                          width: width * .25,
                          child: Center(child: Text(columns[1])),
                        ),
                        onSort: onSort),
                    DataColumn(
                        label: Container(
                          width: width * .25,
                          child: Center(child: Text(columns[2])),
                        ),
                        onSort: onSort),
                  ],
                  rows: getRows(lstCombine),
                  //headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blueGrey),
                  headingTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 18),
                  //horizontalMargin: 40,
                  columnSpacing: 36,
                )))
      ],
    ));
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
          /*label: Center(
            child: Text(column),
          ),*/
          label: Text(column),
          onSort: onSort))
      .toList();

  List<DataRow> getRows(List<String> combines) {
    return combines.map((String combineItem) {
      final cells = [
        combineItem.split("-").first,
        combineItem.split("-")[1],
        combineItem.split("-").last
      ];
      return DataRow(cells: getCells(cells));
    }).toList();
  }

  List<DataCell> getCells(List<dynamic> cells) => cells
      .map((data) => DataCell(
            Container(
                //width: MediaQuery.of(context).size.width/3,
                width: 125,
                child: Center(child: Text('$data'))),
            /* child: Text(
                  '$data',
                  maxLines: 2,
                )),*/
          ))
      .toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      lstCombine.sort((user1, user2) => compareString(
          ascending, user1.split("-").first, user2.split("-").first));
    } else if (columnIndex == 2) {
      lstCombine.sort((user1, user2) => compareString(
          ascending, user1.split("-").last, user2.split("-").last));
    } else {
      lstCombine.sort((user1, user2) =>
          compareString(ascending, user1.split("-")[1], user2.split("-")[1]));
    }

    setState(() {
      sortColumnIndex = columnIndex;
      isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
