import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:izibagde/screens/ScannerHomeOffline.dart';
import 'package:izibagde/screens/qrcode_screen.dart';
import 'package:izibagde/screens/scanner_screen.dart';

import '../services/Scan_Blue_Devices.dart';
import 'blue_home.dart';

/* cette page est faite pour choisir le mode de scan, soit en ligne ou hors ligne */
const BoldStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);



class ScanTypeScreen extends StatefulWidget {

  ScanTypeScreen({required this.documentId});

  final String documentId;

  @override
  _ScanTypeScreenState createState() => _ScanTypeScreenState();
}


class _ScanTypeScreenState extends State<ScanTypeScreen> {


  @override
  Widget build(BuildContext context) {
    return _buildScreen(context);
  }

  Widget _buildScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Online / Offline"),
      ),
      body: Center(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ScannerScreen(
                            documentId: widget.documentId,
                          ),
                        ),
                      );
                    },
                    child: const Text('Online Scan')
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    splashColor: Colors.blueGrey,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ScannerHoneOffline(
                            documentId: widget.documentId,
                          ),
                        ),
                      );
                    },
                    child: const Text('Offline Scan')
                ),
              ),
            ],
          )
      ),
 // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}


