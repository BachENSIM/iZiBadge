//Step 1 _ import the necessarylibrary
import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/screens/login_screen.dart';
import 'package:izibagde/services/authentication.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //Step 2 _ create controller for email and pass
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  //Step 3
  final _formKey = GlobalKey<FormState>();

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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Page"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              //Step 6
              child: TextFormField(
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Enter your email"),
                keyboardType: TextInputType.emailAddress,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                  return null;
                },
                controller: _emailCtl,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              //Step 7
              child: TextFormField(
                obscureText: false,
                controller: _passCtl,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: "Enter your password"),
                keyboardType: TextInputType.emailAddress,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  } else if (value.length < 6) {
                    return "Password should be at least 6 characters";
                  }
                  return null;
                },
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: RaisedButton(
                onPressed: () async {
                  final isValid = _formKey.currentState!.validate();
                  //Step 8
                  await auth
                      .handleSignUp(_emailCtl.text, _passCtl.text)
                      .then((value) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginScreen()));
                  }).catchError((e) => print(e));
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(80.0)),
                textColor: CustomColors.textSecondary,
                padding: const EdgeInsets.all(0),
                child: Container(
                  alignment: Alignment.center,
                  height: 50.0,
                  width: size.width * 0.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(80.0),
                      gradient: LinearGradient(colors: [
                        //Color.fromARGB(255, 255, 136, 34),
                        //Color.fromARGB(255, 255, 177, 41)
                        CustomColors.backgroundLight,
                        CustomColors.backgroundColorDark
                      ])),
                  padding: const EdgeInsets.all(0),
                  child: Text(
                    "SIGN UP",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: GestureDetector(
                onTap: () => {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginScreen()))
                },
                child: Text(
                  "Already Have an Account? Sign in",
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: CustomColors.backgroundLight),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
