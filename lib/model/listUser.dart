import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:http/http.dart' as http;

class ListUser {
  storeNewUser(User user, context,name,lastname) async {
    var uri = (Uri.parse("https://pierre2106j-qrcode.p.rapidapi.com/api"));
    var reponse = await http.get(uri.replace(queryParameters: <String,String> {
      "backcolor": "ffffff",
      "pixel": "9",
      "ecl": "L %7C M%7C Q %7C H",
      "forecolor": "000000",
      "type": "text %7C url %7C tel %7C sms %7C email",
      "text": user.uid, },
    ),
        headers: {
          "x-rapidapi-host": "pierre2106j-qrcode.p.rapidapi.com",
          "x-rapidapi-key": "f9f7a1b65fmsh8040df99eaf90e5p164474jsn2ed53a118bcd"
    });
  }
}