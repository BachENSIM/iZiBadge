import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/components/edit_gr_form.dart';

class EditGroupScreen extends StatefulWidget {
  //const EditGroupScreen({Key? key}) : super(key: key);
  late final String documentId;
  EditGroupScreen({
    required this.documentId,
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
        leadingWidth: 150,
        leading: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_left_sharp),
            label: const Text("Back",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  // color: CustomColors.textSecondary,
                )),
            style: ElevatedButton.styleFrom(
                elevation: 0, primary: Colors.transparent)),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(25),
            child: EditGroupForm(
              documentId: widget.documentId,
            )),
      ),
    );
  }
}
