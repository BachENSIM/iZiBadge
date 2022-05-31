import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/screens/check_list_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanOffline extends StatefulWidget {
  NearbyService nearbyService;
  String documentId;
  List<Device> connectedDevices = [];

  var chat_state;

  ScanOffline(
      {required this.connectedDevices,
      required this.nearbyService,
      required this.documentId});

  @override
  _ScanOfflineState createState() => _ScanOfflineState();
}

class _ScanOfflineState extends State<ScanOffline> {
  late StreamSubscription subscription;
  late StreamSubscription receivedDataSubscription;
  List<ChatMessage> messages = [];
  void addMessgeToList(ChatMessage obj) {
    setState(() {
      messages.insert(0, obj);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    receivedDataSubscription.cancel();
  }

  void init() {
    receivedDataSubscription = this
        .widget
        .nearbyService
        .dataReceivedSubscription(callback: (data) async {
      //Réception du contenu du QR Code
      var obj =
          ChatMessage(messageContent: data["message"], messageType: "receiver");
      log(obj.messageContent);
      await DatabaseTest.fetchDataCheck(
          widget.documentId, obj.messageContent.toString().split('//').last);
    });
  }

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
                sleep(const Duration(milliseconds: 500));
                log(widget.documentId);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CheckListUserScreen(
                      documentId: widget.documentId,
                    ),
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
      body: CameraFormOffline(
          documentId: widget.documentId,
          connectedDevices: widget.connectedDevices,
          nearbyService:
              widget.nearbyService), // Here the scanned result will be shown
    );
  }
}

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}

class CameraFormOffline extends StatefulWidget {
  // const CameraForm({Key? key}) : super(key: key);
  late final String documentId;
  List<Device> connectedDevices = [];
  NearbyService nearbyService;
  CameraFormOffline(
      {required this.documentId,
      required this.connectedDevices,
      required this.nearbyService});

  @override
  _CameraFormOfflineState createState() => _CameraFormOfflineState();
}

class _CameraFormOfflineState extends State<CameraFormOffline> {
  Barcode? result;
  QRViewController? controller;
  late bool verify;
  bool flash = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  late String myControllerText;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Expanded(flex: 4, child: _buildQrView(context)),
        Expanded(
            flex: 4,
            child: Stack(children: <Widget>[
              _buildQrView(context),
              Row(
                //mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Positioned(
                      left: 0.0,
                      right: 0.0,
                      top: 0.0,
                      child: Container(
                          width: 250,
                          height: 50,
                          child: Text(
                            "Nombre de persons entrées: \n ${DatabaseTest.lstPersonScanned.length} / ${DatabaseTest.nbPersonTotal}",
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
                          width: 50,
                          height: 50,
                          child: IconButton(
                              icon: flash
                                  ? Icon(
                                      Icons.flash_on,
                                      //color: Colors.white,
                                    )
                                  : Icon(Icons.flash_off, color: Colors.white),
                              onPressed: () async {
                                await controller!.toggleFlash();
                                flash = !flash;
                                setState(() {});
                              }))),
                ],
              ),
            ])),
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
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      await controller.pauseCamera();
      result = scanData;
      debugPrint(result!.code);

      //DatabaseTest.fetchDataCheck(widget.documentId, result!.code.toString());
      myControllerText = result!.code.toString();
      verify = await DatabaseTest.fetchDataCheck(
          widget.documentId, result!.code.toString());
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
                Icon(Icons.check_circle_outline, color: Colors.green, size: 40),
                Text("Numbre d'entrées: ${DatabaseTest.countPersonEnter}")
              ],
            ),
            duration: Duration(seconds: 365),
            padding: const EdgeInsets.all(15.0),
            action: SnackBarAction(
              label: "Validé",
              onPressed: () async {
                for (int i = 0; i < widget.connectedDevices.length; i++) {
                  if (this.widget.connectedDevices[i].state ==
                      SessionState.notConnected) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("disconnected"),
                      backgroundColor: Colors.red,
                    ));
                    return;
                  }

                  this.widget.nearbyService.sendMessage(
                      this.widget.connectedDevices[i].deviceId,
                      myControllerText);
                }

                myControllerText = "";
                await controller.resumeCamera();
              },
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const <Widget>[
                Icon(Icons.cancel_outlined, color: Colors.red, size: 40),
                Text('Invalidé.....Veuillez rescanner')
              ],
            ),
            duration: Duration(seconds: 365),
            padding: const EdgeInsets.all(15.0),
            action: SnackBarAction(
              label: "Rescannez",
              onPressed: () async {
                for (int i = 0; i < widget.connectedDevices.length; i++) {
                  if (this.widget.connectedDevices[i].state ==
                      SessionState.notConnected) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text("disconnected"),
                      backgroundColor: Colors.red,
                    ));
                    return;
                  }

                  this.widget.nearbyService.sendMessage(
                      this.widget.connectedDevices[i].deviceId,
                      myControllerText);
                }
                myControllerText = "";
                await controller.resumeCamera();
              },
            ),
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
        const SnackBar(content: Text('no Permission')),
      );
      Navigator.of(context).pop();
    }
  }

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Go'),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
