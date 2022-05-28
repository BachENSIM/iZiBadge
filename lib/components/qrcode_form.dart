import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/model/database_test.dart';
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
            // return ListView.separated(
            //     separatorBuilder: (context, index) =>
            //         const SizedBox(height: 16),
            //     itemCount: snapshot.data!.docs.length,
            //     itemBuilder: (context, index) {
            var noteList =
                snapshot.data!.docs[0].data()! as Map<String, dynamic>;
            String docID = snapshot.data!.docs[0].id;
            String email = noteList['email'];
            print("email: " + email + " ID: " + docID);
            return Column(
              children: <Widget>[
                QrImage(data: docID),
                const SizedBox(height: 15),
                ElevatedButton(
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
                  onPressed: () {
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
}
