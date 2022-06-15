import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CameraForm extends StatefulWidget {
  // const CameraForm({Key? key}) : super(key: key);
  late final String documentId;

  CameraForm({required this.documentId});

  @override
  _CameraFormState createState() => _CameraFormState();
}

class _CameraFormState extends State<CameraForm> {
  //Cette page pour la partie scanner en ligne
  Barcode? result;
  QRViewController? controller;
  late bool verify;
  bool flash = false;
  bool touch = false;
  int nbTotal = 0;
  int nbStatusTrue = 0;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getSize();
    super.initState();
  }

  void getSize() async {
    nbTotal = await DatabaseTest.fetchListSize(docId: widget.documentId);
    await DatabaseTest.fetchListInvite(docId: widget.documentId);
    DatabaseTest.lstInviteChecked.values.toList().forEach((element) {
      if(element == true) nbStatusTrue++;
    });
    setState(() {
      debugPrint("nbTotal = $nbTotal");
    });

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            color: Colors.black,
            width: MediaQuery.of(context).size.width,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //afficher un Text et un bouton le flash
                Text(
                  "Nombre de personnes entrées: \n $nbStatusTrue / $nbTotal",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                    icon: flash
                        ? const Icon(
                            Icons.flash_on,
                            color: Colors.white,
                          )
                        : const Icon(Icons.flash_off, color: Colors.white),
                    onPressed: () async {
                      debugPrint("light");
                      await controller!.toggleFlash();
                      flash = !flash;
                      setState(() {});
                    }),
              ],
            )),
        Expanded(
            flex: 4,
            child: Stack(children: <Widget>[
              MaterialButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  debugPrint("touche");
                  await controller!.resumeCamera();

                  setState(() {

                  });
                },
                child: _buildQrView(context),
                minWidth: MediaQuery.of(context).size.width,
              ),
            ])),
      ],
    );
  }
  //Widget pour construire la caméra
  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          // borderColor: Colors.orangeAccent,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      await controller.pauseCamera();
      result = scanData;
      debugPrint("QRCode ${result!.code}");
      verify = await DatabaseTest.fetchDataCheckUpdateDB(
          widget.documentId, result!.code.toString());
      //mettre à jour nb personne qui entre
      await DatabaseTest.fetchListInvite(docId: widget.documentId);
      nbStatusTrue = 0;
      DatabaseTest.lstInviteChecked.values.toList().forEach((element) {
        if(element == true) nbStatusTrue++;
      });
      debugPrint(DatabaseTest.lstSizeInvite.toString());
      String attention = "";
      DatabaseTest.lstSizeInvite[DatabaseTest.emailClient]! > 1 ?  attention = "Personne déjà scannée !" :  attention = "";
      if (verify) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:Container(
              height: 100,
              child:  Column(
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Icon(Icons.check_circle_outline,
                            color: Colors.green, size: 40),
                        Text(DatabaseTest.emailClient),
                        Text(
                            "Nombre d'entrées: ${DatabaseTest.lstSizeInvite[DatabaseTest.emailClient]}"),
                      ]),
                  Text("\n$attention")
                ],
              ),
            ),
            //duration: Duration(seconds: 365),
            padding: const EdgeInsets.all(15.0),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Icon(Icons.cancel_outlined, color: Colors.red, size: 40),
                Text("Code non validé...")
              ],
            ),
            padding: const EdgeInsets.all(15.0),
          ),
        );
      }
      setState(() {
        verify = false;
      });
    });
  }
  //demander la permission
  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pas de permission")),
      );
      Navigator.of(context).pop();
    }
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      const SnackBar(
        content: Text('Go'),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
