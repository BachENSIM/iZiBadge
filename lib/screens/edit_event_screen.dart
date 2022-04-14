import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/components/edit_item_form.dart';
import 'package:izibagde/model/database.dart';

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

  bool _isDel = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _titleFocusNode.unfocus();
        _descFocusNode.unfocus();
        _addrFocusNode.unfocus();
      },
      child: Scaffold(
        backgroundColor: CustomColors.backgroundDark,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: CustomColors.backgroundDark,
          title: Text("Edit An Event"),
          actions: [
            _isDel
                ? const Padding(
                    padding: EdgeInsets.only(
                      top: 10.0,
                      bottom: 10.0,
                      right: 16.0,
                    ),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        CustomColors.accentDark,
                      ),
                      strokeWidth: 3,
                    ),
                  )
                : IconButton(
                    onPressed: () async {
                      setState(() {
                        _isDel = true;
                      });
                      await Database.deleteItem(docId: widget.documentId);
                      setState(() {
                        _isDel = true;
                      });
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                      size: 32,
                    ))
          ],
        ),
        /*body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: EditItemForm(
              documentId: widget.documentId,
              titleFocusNode: _titleFocusNode,
              descFocusNode: _descFocusNode,
              addrFocusNode: _addrFocusNode,
              currTitle: widget.currTitle,
              currDesc: widget.currDesc,
              currAddr: widget.currAddr,
            ),
          ),
        ),*/
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
