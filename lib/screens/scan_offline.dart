import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_nearby_connections/flutter_nearby_connections.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/screens/check_list_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

/* cette page est faite pour la communication entre les dispositifs */

class ScanOffline extends StatefulWidget {
  NearbyService nearbyService;
  String documentId;
  Device connectedDevices;

  var chat_state;

  ScanOffline(
      {required this.connectedDevices,
        required this.nearbyService,
        required this.documentId});

  @override
  _ScanOfflineState createState() => _ScanOfflineState();
}

class _ScanOfflineState extends State<ScanOffline>{
  late StreamSubscription subscription;
  late StreamSubscription receivedDataSubscription;
  List<ChatMessage> messages = [];
  final myController = TextEditingController();
  void addMessgeToList(ChatMessage  obj){

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
  void init(){
    //recevoir le message, elle est toujours en écoute
    receivedDataSubscription =
        this.widget.nearbyService.dataReceivedSubscription(callback: (data) {
          var obj = ChatMessage(messageContent: data["message"], messageType: "receiver");
          log("message reçu");
          log(obj.messageContent);
          //modification directe sur la base de données locale
          DatabaseTest.fetchDataCheckUpdateDB(
              widget.documentId, obj.messageContent);
        });

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
              //Pour afficher la liste des invités et leurs nombres d'entrés
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
      //interface de scan
      body: CameraFormOffline(
          documentId: widget.documentId,
          connectedDevices: widget.connectedDevices,
          nearbyService:
          widget.nearbyService),
    );
  }


}

class ChatMessage{
  String messageContent;
  String messageType;
  ChatMessage({ required this.messageContent,  required this.messageType});
}

class CameraFormOffline extends StatefulWidget {
  // const CameraForm({Key? key}) : super(key: key);
  late final String documentId;
  Device connectedDevices ;
  NearbyService nearbyService;
  CameraFormOffline(
      {required this.documentId,
        required this.connectedDevices,
        required this.nearbyService});

  @override
  _CameraFormOfflineState createState() => _CameraFormOfflineState();
}

class _CameraFormOfflineState extends State<CameraFormOffline> {
  //Cette page pour le mode scanner offline

  Barcode? result;
  QRViewController? controller;
  late bool verify;
  bool flash = false;
  bool touch = false;
  int nbTotal = 0;
  int nbStatusTrue = 0;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  late String myControllerText;
  int j = 0;

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
  //revoyer le nombre de cette personne pour cet événement
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
                  /* setState(() {
                    nbTotal = DatabaseTest.nbPersonTotal;
                  });*/
                },
                child: _buildQrView(context),
                minWidth: MediaQuery.of(context).size.width,
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
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      await controller.pauseCamera();
      result = scanData;
      debugPrint("QRCode ${result!.code}");

      myControllerText = result!.code.toString();

      log(myControllerText);
      if (this.widget.connectedDevices.state ==
          SessionState.notConnected) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("disconnected"),
          backgroundColor: Colors.red,
        ));
        return;
      }
      this.widget.nearbyService.sendMessage(
          this.widget.connectedDevices.deviceId,
          myControllerText);

      log("code envoyé");
      myControllerText = "";
      verify = await DatabaseTest.fetchDataCheckUpdateDB(
          widget.documentId, result!.code.toString());
      debugPrint("Status: " +
          verify.toString() +
          "\nemail:" +
          DatabaseTest.emailClient +
          " nb d'entrée: " +
          DatabaseTest.countPersonScanned.toString());
      //verify = DatabaseTest.status;
      await DatabaseTest.fetchListInvite(docId: widget.documentId);
      nbStatusTrue = 0;
      DatabaseTest.lstInviteChecked.values.toList().forEach((element) {
        if(element == true) nbStatusTrue++;
      });
      String attention = "";
      DatabaseTest.lstSizeInvite[DatabaseTest.emailClient]! > 1 ?  attention = "Personne déjà scannée !" :  attention = "";
      if (verify) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
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
                Text("Code non validé...")
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
      setState(() {
        verify = false;
      });
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