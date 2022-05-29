

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/devices.dart';

const BoldStyle = TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold);



class ScannerHoneOffline extends StatefulWidget {

  ScannerHoneOffline({required this.documentId});

  final String documentId;

  @override
  _ScannerHoneOfflineState createState() => _ScannerHoneOfflineState();
}


class _ScannerHoneOfflineState extends State<ScannerHoneOffline> {


  @override
  Widget build(BuildContext context) {
    return _buildScreen(context);
  }

  Widget _buildScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Offline"),
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
                            builder: (context) => DevicesListScreen(deviceType: DeviceType.browser, documentId: widget.documentId),
                        ),
                      );
                    },
                    child: const Text('BROWSER')
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
                          builder: (context) => DevicesListScreen(deviceType: DeviceType.advertiser, documentId: widget.documentId),
                        ),
                      );
                    },
                    child: const Text('ADVERTISER')
                ),
              ),
            ],
          )
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}


