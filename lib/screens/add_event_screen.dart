import 'package:flutter/material.dart';
import 'package:izibagde/components/add_item_form_v2.dart';


class AddScreen extends StatelessWidget {
  //const AddScreen({Key? key}) : super(key: key);
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descFocusNode = FocusNode();
  final FocusNode _addrFocusNode = FocusNode();
  //final FocusNode _startFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _titleFocusNode.unfocus();
        _descFocusNode.unfocus();
        _addrFocusNode.unfocus();
        //_startFocusNode.unfocus();
      },
      child: Scaffold(
        //backgroundColor: CustomColors.backgroundLight,
        appBar: AppBar(
          //elevation: 0,
          //backgroundColor: CustomColors.backgroundColorDark,
          title: const Text("Evénement"),
          //AppBarTitle()
          centerTitle: true,
          leadingWidth: 100,
          leading: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_left_sharp),
              label: const Text("Back",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    //color: CustomColors.textSecondary,
                  )),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                // primary: Colors.transparent
              )),
        ),
        //scrollView
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
              ),
              child: AddItemForm(
                titleFocusNode: _titleFocusNode,
                descFocusNode: _descFocusNode,
                addrFocusNode: _addrFocusNode,
                //startFocusNode: _startFocusNode,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
