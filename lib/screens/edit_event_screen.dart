import 'package:flutter/material.dart';
import 'package:izibagde/components/edit_item_form.dart';

class EditScreen extends StatefulWidget {
  //const EditScreen({Key? key}) : super(key: key);
  late final String currTitle;
  late final String currDesc;
  late final String currAddr;
  late final DateTime currStartDate;
  late final String documentId;

  //construction
  EditScreen({
    required this.currTitle,
    required this.currDesc,
    required this.currAddr,
    //required this.currStartDate,
    required this.documentId,
  });

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descFocusNode = FocusNode();
  final FocusNode _addrFocusNode = FocusNode();
  //Cette page pour le but de modifier un événement(modifier le titre, l'adresse, la description)
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _titleFocusNode.unfocus();
        _descFocusNode.unfocus();
        _addrFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            title: const Text("Modfier l'événement"),
            leadingWidth: 100,
            leading: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.clear),
                label: const Text("",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      // color: CustomColors.textSecondary,
                    )),
                style: ElevatedButton.styleFrom(
                    elevation: 0, primary: Colors.transparent))
            ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: EditItemForm(
                documentId: widget.documentId,
                titleFocusNode: _titleFocusNode,
                descFocusNode: _descFocusNode,
                addrFocusNode: _addrFocusNode,
                currTitle: widget.currTitle,
                currDesc: widget.currDesc,
                currAddr: widget.currAddr,
                //currStartDate: widget.currStartDate,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
