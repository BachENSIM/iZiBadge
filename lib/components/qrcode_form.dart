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
            return Text("Something went wrong....");
          } else if (snapshot.hasData || snapshot.data != null) {
            return ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 16.0),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var noteList = snapshot.data!.docs[index].data()!
                      as Map<String, dynamic>;
                  String docID = snapshot.data!.docs[index].id;
                  String email = noteList['email'];
                  print("email: " + email + " ID: " + docID);
                  return Column(
                    children: <Widget>[
                      QrImage(data: docID),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            CustomColors.firebaseOrange,
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 16.0, bottom: 16.0),
                          child: Text(
                            'Download',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.firebaseGrey,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                });
          }
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                CustomColors.firebaseOrange,
              ),
            ),
          );
        });
  }
}
