import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/components/edit_lst_user_form.dart';

class EditListUserScreen extends StatefulWidget {
  //const EditListUserScreen({Key? key}) : super(key: key);

  late final String documentId;
  EditListUserScreen({
    required this.documentId,
  });
  @override
  _EditListUserScreenState createState() => _EditListUserScreenState();
}

class _EditListUserScreenState extends State<EditListUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //elevation: 0,
        //backgroundColor: CustomColors.backgroundDark,
        title: const Text("Modifier la liste"),
        //AppBarTitle()
        centerTitle: true,
        leadingWidth: 100,
        leading: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.clear),
            label: const Text("",
                style: TextStyle(
                  fontSize: 16,
                  // fontWeight: FontWeight.w700,
                  //color: CustomColors.secondaryText,
                )),
            style: ElevatedButton.styleFrom(
                elevation: 0, primary: Colors.transparent)),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: EditListUserForm(
                documentId: widget.documentId,
              ),
            )),
      ),
    );
  }
}
