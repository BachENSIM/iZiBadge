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
  Barcode? result;
  QRViewController? controller;
  late bool verify;
  bool flash = false;
  bool touch = false;
  int nbTotal = 0;
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
    debugPrint("nbTotal = $nbTotal");
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
                Text(
                  //"Nombre de personnes entrées: \n ${DatabaseTest.lstPersonScanned.length} / ${DatabaseTest.nbPersonTotal}",
                  "Nombre de personnes entrées: \n ${DatabaseTest.lstPersonScanned.length} / $nbTotal",
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
                    nbTotal = DatabaseTest.nbPersonTotal;
                  });
                },
                child: _buildQrView(context),
                minWidth: MediaQuery.of(context).size.width,
              ),
              //_buildQrView(context),
              /* Positioned(
                  left: 350.0,
                  width: 10.0,
                  top: 10.0,
                  child: IconButton(
                      icon: flash
                          ? Icon(
                              Icons.flash_on,
                              color: Colors.white,
                            )
                          : Icon(Icons.flash_off, color: Colors.white),
                      onPressed: () async {
                        debugPrint("light");
                        await controller!.toggleFlash();
                        flash = !flash;
                        setState(() {});
                      })),
              Positioned(
                  left: 15.0,
                  child: Container(
                      */ /*decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border.all(
                          color: Colors.red,
                          width: 1.0,
                          style: BorderStyle.solid,
                        )),*/ /*
                      // width: 250,
                      // height: 50,
                      child: Text(
                    "Nombre de personnes entrées: \n ${DatabaseTest.lstPersonScanned.length} / ${DatabaseTest.nbPersonTotal}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ))),*/
              /*SizedBox(
                width: 250,
              ),*/

              /* Row(
                //mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Positioned(
                      left: 0.0,
                      right: 10.0,
                      top: 0.0,
                      child: Container(
                          // width: 250,
                          // height: 50,
                          child: Text(
                        "Nombre de personnes entrées: \n ${DatabaseTest.lstPersonScanned.length} / ${DatabaseTest.nbPersonTotal}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ))),
                  SizedBox(
                    width: 90,
                  ),
                  Positioned(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      child: Container(
                          // width: 50,
                          // height: 50,
                          child: IconButton(
                              icon: flash
                                  ? Icon(
                                      Icons.flash_on,
                                      color: Colors.white,
                                    )
                                  : Icon(Icons.flash_off, color: Colors.white),
                              onPressed: () async {
                                await controller!.toggleFlash();
                                flash = !flash;
                                setState(() {});
                              }))),
                ],
              ),*/
            ])),
        /*Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Text('Data: ${result!.code}')
                    //Text('Email: ' + DatabaseTest.emailClient)
                  else
                    Text('Scan a code'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const <Widget>[
                      if(verify) Icon(Icons.check_circle_outline,color: Colors.green,size: 40,)
                      else Icon(Icons.cancel_outlined,color: Colors.red,size: 40)
                    ],
                  ),
                ],
              ),
            ),
          )*/
      ],
    );
  }

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

      //DatabaseTest.fetchDataCheck(widget.documentId, result!.code.toString());
      verify = await DatabaseTest.fetchDataCheck(
          widget.documentId, result!.code.toString().split('//').last);
      debugPrint("Status: " +
          verify.toString() +
          "\nemail:" +
          DatabaseTest.emailClient +
          " nb d'entrée: " +
          DatabaseTest.countPersonScanned.toString());
      //verify = DatabaseTest.status;

      if (verify) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Icon(Icons.check_circle_outline,
                    color: Colors.green, size: 40),
                Text(result!.code.toString().split('//').last),
                Text("Nombre d'entrées: ${DatabaseTest.countPersonEnter}")
              ],
            ),
            //duration: Duration(seconds: 365),
            padding: const EdgeInsets.all(15.0),
            /*action: SnackBarAction(
              label: "Validé",
              onPressed: () async {
                await controller.resumeCamera();
              },
            ),*/
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Icon(Icons.cancel_outlined, color: Colors.red, size: 40),
                Text("Code non valide...")
              ],
            ),
            //duration: Duration(seconds: 365),
            padding: const EdgeInsets.all(15.0),
            /*action: SnackBarAction(
              label: "Rescannez",
              onPressed: () async {
                await controller.resumeCamera();
              },
            ),*/
          ),
        );
      }
      setState(() {});
    });
  }

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
