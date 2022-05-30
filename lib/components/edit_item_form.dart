import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/components/custom_form_field.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/model/validator.dart';

class EditItemForm extends StatefulWidget {
  //const EditItemForm({Key? key}) : super(key: key);

  late final FocusNode titleFocusNode;
  late final FocusNode descFocusNode;
  late final FocusNode addrFocusNode;
  late final String currTitle;
  late final String currDesc;
  late final String currAddr;
  late final String documentId;

  EditItemForm({
    required this.titleFocusNode,
    required this.descFocusNode,
    required this.addrFocusNode,
    required this.currTitle,
    required this.currDesc,
    required this.currAddr,
    required this.documentId,
  });

  @override
  _EditItemFormState createState() => _EditItemFormState();
}

class _EditItemFormState extends State<EditItemForm> {
  final _editItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;

  late TextEditingController _titleCtl;
  late TextEditingController _descCtl;
  late TextEditingController _addrCtl;

  @override
  void initState() {
    // TODO: implement initState
    _titleCtl = TextEditingController(text: widget.currTitle);
    _descCtl = TextEditingController(text: widget.currDesc);
    _addrCtl = TextEditingController(text: widget.currAddr);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _editItemFormKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                bottom: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 12.0), //invisible box
                  const Text(
                    'Titre',
                    style: TextStyle(
                      //color: CustomColors.textPrimary,
                      fontSize: 22.0,
                      // letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  CustomFormField(
                    isLabelEnabled: false,
                    controller: _titleCtl,
                    focusNode: widget.titleFocusNode,
                    inputType: TextInputType.text,
                    inputAction: TextInputAction.done,
                    validator: (value) => Validator.validateField(
                      value: value,
                    ),
                    label: 'Titre',
                    hint: "Saisir le titre de l'événement",
                  ),
                  const SizedBox(height: 24.0),
                  const Text(
                    'Description',
                    style: TextStyle(
                      //color: CustomColors.textPrimary,
                      fontSize: 22.0,
                      // letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  CustomFormField(
                    maxLines: 5,
                    isLabelEnabled: false,
                    controller: _descCtl,
                    focusNode: widget.descFocusNode,
                    inputType: TextInputType.text,
                    inputAction: TextInputAction.done,
                    validator: (value) => Validator.validateField(
                      value: value,
                    ),
                    label: 'Description',
                    hint: "Saisir la description de l'événement",
                  ),
                  const SizedBox(height: 24.0),
                  const Text(
                    'Adresse',
                    style: TextStyle(
                      //color: CustomColors.textPrimary,
                      fontSize: 22.0,
                      // letterSpacing: 1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  CustomFormField(
                    maxLines: 3,
                    isLabelEnabled: false,
                    controller: _addrCtl,
                    focusNode: widget.addrFocusNode,
                    inputType: TextInputType.text,
                    inputAction: TextInputAction.done,
                    validator: (value) => Validator.validateField(
                      value: value,
                    ),
                    label: 'Adresse',
                    hint: "Saisir l'adresse de l'événement",
                  ),
                ],
              ),
            ),
            _isProcessing
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                        // valueColor: AlwaysStoppedAnimation<Color>(
                        //   CustomColors.accentLight,
                        // ),
                        ),
                  )
                : Container(
                    width: double.maxFinite,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        // backgroundColor: MaterialStateProperty.all(
                        //   CustomColors.accentLight,
                        // ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        widget.titleFocusNode.unfocus();
                        widget.descFocusNode.unfocus();
                        widget.addrFocusNode.unfocus();

                        if (_editItemFormKey.currentState!.validate()) {
                          setState(() {
                            //print("1" + _isProcessing.toString());
                            print("ID: " + widget.documentId.toString());

                            _isProcessing = true;
                          });

                          await DatabaseTest.updateItem(
                            docId: widget.documentId,
                            title: _titleCtl.text,
                            description: _descCtl.text,
                            address: _addrCtl.text,
                          );

                          setState(() {
                            //print("2" + _isProcessing.toString());
                            _isProcessing = false;
                          });

                          Navigator.of(context).pop();
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 16),
                        child: Text(
                          "Sauvegarder",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            //color: CustomColors.textPrimary,
                            // letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                  )
          ],
        ));
  }
}
