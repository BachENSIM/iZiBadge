import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:izibagde/components/camera_form.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/screens/check_list_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScannerScreen extends StatefulWidget {
  late final String documentId;

  ScannerScreen({required this.documentId});

  @override
  _ScannerScreenState createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("QR Scanner"),
          leadingWidth: 100,
          leading: ElevatedButton.icon(
              onPressed: () {
                //await controller!.stopCamera();
                Navigator.of(context).pop();
              } ,
              icon: const Icon(Icons.arrow_left_sharp),
              label: const Text("Back"),
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  // primary: Colors.transparent,
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold))),
          actions: [
            ElevatedButton(
              // style: ButtonStyle(
              //     backgroundColor: MaterialStateProperty.all(
              //   CustomColors.backgroundColorDark,
              // )),
              onPressed: () async {
                await DatabaseTest.fetchListInvite(docId: widget.documentId);
                //await controller!.pauseCamera();
                /*sleep(const Duration(
                    milliseconds: 500));*/
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CheckListUserScreen(documentId: widget.documentId,),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const <Widget>[
                  Text("Liste",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        //color: CustomColors.textSecondary,
                      )),
                  Icon(Icons.arrow_right_sharp)
                ],
              ),
            )
          ]),
      body: CameraForm(
          documentId:
              widget.documentId), // Here the scanned result will be shown
    );
  }
}
