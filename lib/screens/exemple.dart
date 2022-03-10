import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart';

class Exemple extends StatefulWidget {
  const Exemple({Key? key}) : super(key: key);

  @override
  _ExempleState createState() => _ExempleState();
}

class _ExempleState extends State<Exemple> {
  String serverResponse = 'Server response';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Align(

        alignment: Alignment.topCenter,
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('Send request to server'),
                color: Colors.orangeAccent,
                onPressed: () {
                  _makeGetRequest();
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(serverResponse),
              ),
            ],
          ),
        ),
      ),
    );
  }
  _makeGetRequest() async {
    Response response = await get(Uri.parse(_localhost()));
    setState(() {
      serverResponse = response.body;
    });
  }
  String _localhost() {
    if (Platform.isAndroid)
      return 'http://10.0.2.2:3000';
    else // for iOS simulator
      return 'http://localhost:3000';
  }
}
