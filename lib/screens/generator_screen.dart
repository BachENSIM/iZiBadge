import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:izibagde/model/database.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GeneratePage extends StatefulWidget {
  const GeneratePage({Key? key}) : super(key: key);

  @override
  _GeneratePageState createState() => _GeneratePageState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('evenements');

class _GeneratePageState extends State<GeneratePage> {
  static String? userUID = Database.userUid;
  bool status = false;
  final TextEditingController _emailCtl = TextEditingController();

  //String qrData =  FirebaseFirestore.instance.collection('evenements').doc(userUID).collection('items').doc('DY2kddSmQGxTLMax7KNi').collection('participation').doc().id as String;
  String qrData = " ";
  //StreamBuilder streamBuilder =

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              maxLines: 20,
              keyboardType: TextInputType.emailAddress,
              controller: _emailCtl,
            ),
            ElevatedButton(
                onPressed: () async {
                  List<String> list = _emailCtl.text.split(";");

                  DocumentReference docEmail = _mainCollection
                      .doc(userUID)
                      .collection('emails')
                      .doc(userUID);
                  for (int i = 0; i < list.length; i++) {
                    DocumentReference documentReferencer = _mainCollection
                        .doc(userUID)
                        .collection('items')
                        .doc('DY2kddSmQGxTLMax7KNi')
                        .collection('participation')
                        .doc();

                    Map<String, dynamic> data = <String, dynamic>{
                      "role": "Normal",
                      "statutEntree": false,
                      "timestamp": DateTime.now(),
                      "email": list[i],
                    };

                    print(" ID " + i.toString());
                    //add invitation of every one
                    await documentReferencer.set(data).whenComplete(() {
                      print(documentReferencer.id + " ID ");
                    }).catchError((e) => print(e));

                    qrData = documentReferencer.id;
                  }



                  Map<String, dynamic> lEmail = <String, dynamic>{
                    //"email" : _emailCtl.toString(),
                    "email": list,
                  };
                  //save all of email in Firebase to help select
                  await docEmail.update(lEmail).whenComplete(() {
                    print(" Add success ");
                  }).catchError((e) => print(e));

                  setState(() {
                    //print("0" + list[0]);
                    //print("1" + list[1]);
                    //print(_emailCtl.text);
                    status = true;
                    //qrData = documentReferencer.id;
                  });
                },
                child: Wrap(
                  children: const <Widget>[Text('Generator')],
                )
            ),
            SizedBox(
              height: 20,
            ),
            //Text(status ? qrData : " "),
            status ?
            QrImage(
                data:qrData,
            ) :
            Text(""),
          ],
        ),
      ),
    );
  }
}
