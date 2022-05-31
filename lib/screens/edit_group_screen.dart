import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/components/edit_gr_form.dart';

class EditGroupScreen extends StatefulWidget {
  //const EditGroupScreen({Key? key}) : super(key: key);
  late final String documentId;
  late final String nameEvent;
  late final DateTime dateStart;
  late final DateTime dateEnd;

  EditGroupScreen({
    required this.documentId,
    required this.nameEvent,
    required this.dateStart,
    required this.dateEnd,
  });
  @override
  _EditGroupScreenState createState() => _EditGroupScreenState();
}

class _EditGroupScreenState extends State<EditGroupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //elevation: 0,
        // backgroundColor: CustomColors.backgroundDark,
        title: const Text("Modifier les groupes"),
        //AppBarTitle()
        centerTitle: true,
        leadingWidth: 100,
        leading: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.clear),
            label: const Text("",
                style: TextStyle(
                    // fontSize: 16,
                    // fontWeight: FontWeight.w700,
                    // color: CustomColors.textSecondary,
                    )),
            style: ElevatedButton.styleFrom(
                elevation: 0, primary: Colors.transparent)),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(25),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: EditGroupForm(
                documentId: widget.documentId,
                nameEvent: widget.nameEvent,
                dateStart: widget.dateStart,
                dateEnd: widget.dateEnd,
              ),
            )),
      ),
    );
  }
}
