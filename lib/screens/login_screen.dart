import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:izibagde/model/database_test.dart';
import 'package:izibagde/screens/dashboard_screen.dart';
import 'package:izibagde/screens/register_screen.dart';
import 'package:izibagde/services/authentication.dart';
import 'package:izibagde/components/background.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //Cette page pour la connexion

  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  //for show/hide pass
  final textFieldFocusNode = FocusNode();
  bool _obscured = false;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  //Step 4
  @override
  void dispose() {
    // TODO: implement dispose
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Step 5
    final auth = Provider.of<Authentication>(context);
    Size size = MediaQuery.of(context).size;

    //another interface for login
    return Scaffold(
      body: Background(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: const Text(
                "CONNEXION",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    //color: CustomColors.textPrimary,
                    fontSize: 36),
                textAlign: TextAlign.left,
              ),
            ),

            SizedBox(height: size.height * 0.03),

            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailCtl,
                decoration: InputDecoration(
                  errorText: validateEmail(_emailCtl.text),
                  floatingLabelBehavior: FloatingLabelBehavior
                      .never, //Hides label on focus or if filled
                  labelText: "Email",
                  filled: true, // Needed for adding a fill color
                  //fillColor: CustomColors.backgroundLight,
                  isDense: true, // Reduces height a bit
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none, // No border
                    borderRadius:
                        BorderRadius.circular(12), // Apply corner radius
                  ),
                  prefixIcon: const Icon(Icons.email_outlined, size: 24),
                ),
              ),
            ),

            SizedBox(height: size.height * 0.03),
            //field pass
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: _obscured,
                focusNode: textFieldFocusNode,
                controller: _passCtl,
                decoration: InputDecoration(
                  errorText: validatePassword(_passCtl.text),
                  floatingLabelBehavior: FloatingLabelBehavior
                      .never, //Hides label on focus or if filled
                  labelText: "Password",
                  filled: true, // Needed for adding a fill color
                  //fillColor: CustomColors.backgroundLight,
                  isDense: true, // Reduces height a bit
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none, // No border
                    borderRadius:
                        BorderRadius.circular(12), // Apply corner radius
                  ),
                  prefixIcon: const Icon(Icons.lock_rounded, size: 24),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                    child: GestureDetector(
                      onTap: _toggleObscured,
                      child: Icon(
                        _obscured
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Text(
                "Mot de passe oublié ?",
                style: TextStyle(
                  fontSize: 12,
                  //color: CustomColors.backgroundLight
                ),
              ),
            ),

            SizedBox(height: size.height * 0.05),

            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: RaisedButton(
                onPressed: () async {
                  //final isValid = _formKey.currentState!.validate();
                  //Step 8
                  //if (_formKey.currentState!.validate() ) {
                  await auth
                      .handleSignInEmail(_emailCtl.text, _passCtl.text)
                      .then((value) {
                    print("after login" + _emailCtl.text);
                    print("after login" + _passCtl.text);
                    DatabaseTest.userUid = _emailCtl.text.toLowerCase();
                    Navigator.of(context).push(MaterialPageRoute(
                        //builder: (context) =>  ListViewEvent()));
                        builder: (context) => DashboardScreen()));
                    //builder: (context) => EventList()));
                  }).catchError((e) => print(e));
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                // textColor: CustomColors.textSecondary,
                padding: const EdgeInsets.all(0),
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  width: size.width * 0.5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80.0),
                  ),
                  padding: const EdgeInsets.all(0),
                  child: const Text(
                    "SE CONNECTER",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            Container(
              alignment: Alignment.centerRight,
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: GestureDetector(
                onTap: () => {
                  //Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()))
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen()))
                },
                child: Text(
                  "Créer un nouveau compte?",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    //color: CustomColors.backgroundLight,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

String? validatePassword(String? value) {
  // ignore: unnecessary_null_comparison
  if (value == null || value.isEmpty) {
    //return "Password is required";
    return "Mot de passe obligatoire";
  } else if (value.length < 6) {
    return "Password should be at least 6 characters";
  }
  return null;
}

String? validateEmail(String? value) {
  // ignore: unnecessary_null_comparison
  if (value == null || value.isEmpty) {
    //return "Email is required";
    return "Email obligatoire";
  }
  return null;
}
