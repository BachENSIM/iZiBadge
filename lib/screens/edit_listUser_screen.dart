import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/components/edit_lst_user_form.dart';

class EditListUserScreen extends StatefulWidget {
  //const EditListUserScreen({Key? key}) : super(key: key);

  late final String documentId;
  late final String nameEvent;
  EditListUserScreen({
    required this.documentId,
    required this.nameEvent,
  });
  @override
  _EditListUserScreenState createState() => _EditListUserScreenState();
}

class _EditListUserScreenState extends State<EditListUserScreen> {
  //Cette page pour modifier la liste d'invitation (changer rôle, groupe ou en ajouter autres)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier la liste"),
        centerTitle: true,
        leadingWidth: 100,
        leading: ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.clear),
            label: const Text("",
                style: TextStyle(
                  fontSize: 16,
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
                nameEvent: widget.nameEvent,
              ),
            )),
      ),
    );
  }
}
