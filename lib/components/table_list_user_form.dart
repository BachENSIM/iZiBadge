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
  final columns = ["Invité", "Entré", "Entrées"];
  late List<String> lstEmail =
      DatabaseTest.lstInviteChecked.keys.toList(growable: false);
  late List<bool> lstStatus =
      DatabaseTest.lstInviteChecked.values.toList(growable: false);
  late List<String> lstCombine = [];
  late List<int> lstEnter =
      DatabaseTest.lstSizeInvite.values.toList(growable: false);

  @override
  void initState() {
    /*lstEmail = DatabaseTest.lstInviteChecked.keys.toList(growable: false);
    lstStatus = DatabaseTest.lstInviteChecked.values.toList(growable: false);
    lstEnter = DatabaseTest.lstSizeInvite;*/
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
    // final double width = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(milliseconds: 500));
        await DatabaseTest.fetchListInvite(docId: widget.documentId);
        //debugPrint(lstEnter.toString());
        lstEmail = DatabaseTest.lstInviteChecked.keys.toList(growable: false);
        lstStatus =
            DatabaseTest.lstInviteChecked.values.toList(growable: false);
        lstEnter = DatabaseTest.lstSizeInvite.values.toList(growable: false);
        if (lstCombine.isNotEmpty) lstCombine.clear();
        for (int i = 0; i < lstStatus.length; i++) {
          String mess = lstEmail[i] +
              "-" +
              lstStatus[i].toString() +
              "-" +
              lstEnter[i].toString();
          lstCombine.add(mess);
        }
        setState(() {});
      },
      color: Colors.purple,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            sortAscending: isAscending,
            sortColumnIndex: sortColumnIndex,
            //columns: getColumns(columns),
            columns: [
              DataColumn(
                  label: SizedBox(
                    // width: width * .2,
                    child: Center(
                      child: Text(
                        columns[0],
                      ),
                    ),
                  ),
                  onSort: onSort),
              DataColumn(
                  label: Center(
                    child: Text(
                      columns[1],
                    ),
                  ),
                  onSort: onSort),
              DataColumn(
                  label: Center(
                    child: Text(
                      columns[2],
                    ),
                  ),
                  onSort: onSort),
            ],
            rows: getRows(lstCombine),
            //headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blueGrey),
            headingTextStyle: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
            //horizontalMargin: 40,
            columnSpacing: 36,
          ),
        ),
      ),
    )

        /*Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        //Text("[Nombre d'entrée/Nombre Total] / "),
        SingleChildScrollView(
            scrollDirection: Axis.vertical,
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
              ),
            ))
      ],
    )*/
        ;
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
      .map(
        (data) => DataCell(
          // SizedBox(
          //   //width: MediaQuery.of(context).size.width/3,
          //   // width: 125,
          //   child: Center(
          //     child: Text(
          //       '$data',
          //     ),
          //   ),
          // ),
          Center(
            child: Text(
              '$data',
            ),
          ),
        ),
      )
      .toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      lstCombine.sort((user1, user2) => compareString(
          ascending, user1.split("-").first, user2.split("-").first));
    } else if (columnIndex == 2) {
      lstCombine.sort((user1, user2) => compareInt(ascending,
          int.parse(user1.split("-").last), int.parse(user2.split("-").last)));
      /* lstCombine.sort((user1, user2) => Comparable.compare(
          int.parse(user1.split("-").last), int.parse(user2.split("-").last)));*/
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

  int compareInt(bool ascending, int value1, int value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}
