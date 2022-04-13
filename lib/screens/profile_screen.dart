import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/screens/login_screen.dart';
import 'package:izibagde/services/authentication.dart';
import 'package:provider/provider.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authentication>(context);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dash board"),
      ),
      body: ListView(
        children: <Widget>[
          CircleAvatar(
            radius: 70,
            backgroundColor: CustomColors.textPrimary,
            child: Image.asset(
                "asset/image/internet-security.png",
                width: size.width
            ),
          ),
          Padding(
            padding: const EdgeInsets.all((20.0)),
            child: Center(
              child: Column(
                children: [
                  const Divider(
                    thickness: 1,
                  ),
                  const Text(
                    'User name',
                    style:
                      TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold
                      ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "iziBagde",
                    style:
                      TextStyle(
                        fontSize: 12.0,
                        color: CustomColors.textPrimary
                      ),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  const Text(
                    'User name',
                    style:
                    TextStyle(
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "iziBagde",
                    style:
                    TextStyle(
                        fontSize: 12.0,
                        color: CustomColors.textPrimary
                    ),
                  ),
                  // Container(
                  //   alignment: Alignment.centerRight,
                  //   margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  //   child: GestureDetector(
                  //     onTap: () async => {
                  //       await auth.logout();
                  //       Navi
                  //       //Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()))
                  //       //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()))
                  //     },
                  //     child: Text(
                  //       "Logout",
                  //       style: TextStyle(
                  //           fontSize: 12,
                  //           fontWeight: FontWeight.bold,
                  //           color: Color(0xFF2661FA)
                  //       ),
                  //     ),
                  //   ),
                  // )
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: RaisedButton(
                      onPressed: () async {
                       await auth.logout();
                       Navigator.pushAndRemoveUntil(
                           context,
                           MaterialPageRoute(
                               builder: (context) => const LoginScreen()), (route) => false);
                      },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
                      textColor: CustomColors.textSecondary,
                      padding: const EdgeInsets.all(0),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        width: size.width * 0.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(80.0),
                            gradient: LinearGradient(
                                colors: [
                                  //Color.fromARGB(255, 255, 136, 34),
                                  //Color.fromARGB(255, 255, 177, 41)
                                  CustomColors.backgroundLight,
                                  CustomColors.backgroundDark
                                ]
                            )
                        ),
                        padding: const EdgeInsets.all(0),
                        child: const Text(
                          "LOGOUT",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ) ,
          )
        ],
      ),
    );
  }
}
