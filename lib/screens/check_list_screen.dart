import 'package:flutter/material.dart';
import 'package:izibagde/components/table_list_user_form.dart';

import '../components/check_list_form.dart';

class CheckListUserScreen extends StatefulWidget {
  //const CheckListUserScreen({Key? key}) : super(key: key);
  late final String documentId;

  CheckListUserScreen({required this.documentId});

  @override
  _CheckListUserScreenState createState() => _CheckListUserScreenState();
}

class _CheckListUserScreenState extends State<CheckListUserScreen> {
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
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_left_sharp),
            label: const Text("Back"),
            style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: Colors.transparent,
                textStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold))),
      ),
      body:TableUserForm(documentId: widget.documentId)
      /*SingleChildScrollView(
        child:  TableUserForm(documentId: widget.documentId,)
      )*/

      /* CheckListForm(
          documentId:
              widget.documentId),*/ // Here the scanned result will be shown

    );
  }
}
