import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';

class generatorQRCodeform extends StatefulWidget {
  //const QRCodeScreen({Key? key}) : super(key: key);
  late final String documentId;

  generatorQRCodeform({required this.documentId});

  @override
  _generatorQRCodeformState createState() => _generatorQRCodeformState();
}

class _generatorQRCodeformState extends State<generatorQRCodeform> {
  int count = 0;
  static String? dataQRCode;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: DatabaseTest.readListInvite(widget.documentId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Something went wrong...");
          } else if (snapshot.hasData || snapshot.data != null) {
            var noteList =
                snapshot.data!.docs[0].data()! as Map<String, dynamic>;
            String docID = snapshot.data!.docs[0].id;
            String email = noteList['email'];
            return Column(
              children: <Widget>[
                QrImage(data: docID),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    //télécharger le QRCOde sur le téléphone
                    //Etape 1: valider le QRCode
                    final qrValidationResult = QrValidator.validate(
                      data: docID,
                      version: QrVersions.auto,
                      errorCorrectionLevel: QrErrorCorrectLevel.L,
                    );
                    //prendre le QRCode
                    final qrCode = qrValidationResult.qrCode;
                    //dessiner le QRCode (ajouter des couleurs,...)
                    final painter = QrPainter.withQr(
                      qr: qrCode!,
                      emptyColor: const Color(0xFFFFFFFF),
                      color: const Color(0xFF000000),
                      gapless: true,
                      embeddedImageStyle: null,
                      embeddedImage: null,
                    );
                    //le mettre dans un hazard fichier
                    Directory tempDir = await getTemporaryDirectory();
                    String tempPath = tempDir.path;
                    final ts = DateTime.now().toUtc().toString();
                    String path = '$tempPath/$ts.png';
                    //exporter QRCode d'image au fichier
                    final picData = await painter.toImageData(2048);
                    await writeToFile(picData!, path);
                    //Sauvergarder dans le gallery
                    //String pathCreate = await createQrPicture(qr);

                    final success = await GallerySaver.saveImage(path);

                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: success!
                          ? Text('Sauvegarder dans la gallerie')
                          : Text('Problème lors de la sauvegarde...'),
                    ));
                    debugPrint(success.toString());
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    child: Text(
                      "Sauvegarder dans la gallerie",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              ],
            );
            // });
          }
          return const Center(
            child: CircularProgressIndicator(
                // valueColor: AlwaysStoppedAnimation<Color>(
                //   CustomColors.accentLight,
                // ),
                ),
          );
        });
  }

  //sauvegarder dans un fichier
  Future<void> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}
