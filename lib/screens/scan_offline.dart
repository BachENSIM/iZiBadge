import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:izibagde/components/camera_form.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/screens/check_list_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanOffline extends StatefulWidget {
  Device connected_device;
  NearbyService nearbyService;
  String documentId;

  ScanOffline({ required this.connected_device, required this.nearbyService, required this.documentId});

  @override
  _ScanOfflineState createState() => _ScanOfflineState();
}

class _ScanOfflineState extends State<ScanOffline> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          title: Text("QR Scanner"),
          leadingWidth: 100,
          leading: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
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
                sleep(const Duration(
                    milliseconds: 500));
                log(widget.documentId);
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
