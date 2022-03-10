import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:izibagde/screens/autocomp_screen.dart';
import 'package:izibagde/screens/exemple.dart';
import 'package:izibagde/screens/dashboard_screen.dart';
import 'package:izibagde/screens/login_screen.dart';
import 'package:izibagde/screens/test_loop_screen.dart';
import 'package:izibagde/services/authentication.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //initilization of Firebase app
  // other Firebase service initialization
  //runApp(const MyApp());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MultiProvider(
      providers: [
        Provider<Authentication>(
            create: (_) => Authentication()
        )
      ],
      child: MaterialApp(
        title: "Page connection",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //home: const LoginScreen(),
        //home:  DashboardScreen(),
        home:  TestLoop(),
        //home:  AutoScreen(),

      ),
    );

    // throw MaterialApp(
    //   home: LandingPage(),
    // );
  }

}
// class LandingPage extends StatefulWidget {
//   const LandingPage({Key? key}) : super(key: key);
//
//   @override
//   _LandingPageState createState() => _LandingPageState();
// }
//
// class _LandingPageState extends State<LandingPage> {
//   @override
//   Widget build(BuildContext context) {
//     return MultiProvider(
//         providers: [
//           Provider<Authentication>(
//               create: (_) => Authentication()
//           )
//         ],
//         child: MaterialApp(
//           title: "Page connection",
//           theme: ThemeData(
//             primarySwatch: Colors.blue,
//           ),
//           home: const LoginScreen(),
//         ),
//     );
//   }
// }
//


// class LandingPage extends StatelessWidget {
//   final Future<FirebaseApp> _initialization = Firebase.initializeApp();
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: _initialization,
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Scaffold(
//               body: Center(
//                 child: Text("Error: ${snapshot.error}"),
//               ),
//             );
//           }
//
//           if (snapshot.connectionState == ConnectionState.done) {
//             return StreamBuilder(
//               stream: FirebaseAuth.instance.authStateChanges(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.active) {
//                   User user = snapshot.data();
//                   if (user == null)
//                     return LoginPage();
//                   } else {
//                     return Homepage();
//                   }
//                 }
//
//                 return Scaffold(
//                   body: Center(
//                     child: Text("Checking Authentication ..."),
//                   ),
//                 );
//               },
//             );
//           }
//
//           return Scaffold(
//             body: Center(
//               child: Text("Connecting to the app..."),
//             ),
//           );
//         });
//   }
// }
