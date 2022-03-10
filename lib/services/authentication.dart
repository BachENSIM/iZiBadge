import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:izibagde/model/user_model.dart' as model;
import 'package:izibagde/screens/dashboard_screen.dart';

class Authentication {
  //Step 1
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;

  //Step 2 - mapping data form firebase
  model.User? _firebaseUser(auth.User? user) {
    //Step 3
    if (user == null) {
      return null;
    }
    //Step 4
    return model.User(user.uid, user.email);
  }
  //to rest always sign in
  static Future<FirebaseApp> initializeFirebase({
  required BuildContext context,
}) async {
    FirebaseApp firebaseApp = auth.FirebaseAuth.instance.currentUser as FirebaseApp;

    model.User? user = auth.FirebaseAuth.instance.currentUser as model.User?;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => DashboardScreen())
      );
    }
  return firebaseApp;
  }


  //Step 5
  Stream<model.User?>? get user {
    return _firebaseAuth.authStateChanges().map(_firebaseUser);
  }

  //Step 6
  Future<model.User?> handleSignInEmail(String email, String password) async {
    //Step 7
    final result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    //Step 8
    if (result.user!.emailVerified ) {
      return _firebaseUser(result.user);
    } else {
      return null;
    }
  }
  //Step 9
  Future<model.User?> handleSignUp(String email, String password) async{
    //Step 10
    final result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    //Step 11
    return _firebaseUser(result.user);
  }
  //Step 12
  Future<void> logout() async {
    return await _firebaseAuth.signOut();
  }
}