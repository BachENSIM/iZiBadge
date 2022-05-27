import 'package:flutter/material.dart';
import 'package:izibagde/components/table_list_user_form.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../components/check_list_form.dart';

class CheckListUserScreen extends StatefulWidget {
  //const CheckListUserScreen({Key? key}) : super(key: key);
  late final String documentId;

  CheckListUserScreen({required this.documentId});

  @override
  _CheckListUserScreenState createState() => _CheckListUserScreenState();
}

class _CheckListUserScreenState extends State<CheckListUserScreen> {
  QRViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Liste d'invitation"),
          leadingWidth: 100,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.blue],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
          leading: ElevatedButton.icon(
              onPressed: () {
                //controller!.resumeCamera();
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_left_sharp),
              label: const Text("Back"),
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  primary: Colors.transparent,
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold))),
        ),
        body:TableUserForm(documentId: widget.documentId)
        //Flutter RefreshIndicator => Pull to refresh (swipe to refresh)
       /* RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 1));
              await DatabaseTest.fetchListInvite(docId: widget.documentId);

              setState(() {});
            },
            color: Colors.purple,
            child: TableUserForm(documentId: widget.documentId))*/

        /*SingleChildScrollView(
        child:  TableUserForm(documentId: widget.documentId,)
      )*/

        /* CheckListForm(
          documentId:
              widget.documentId),*/ // Here the scanned result will be shown

        );
  }
}
