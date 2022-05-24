import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/screens/dashboard_screen.dart';
import 'package:izibagde/screens/login_screen.dart';
import 'package:izibagde/services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


void main() async {
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
        providers: [Provider<Authentication>(create: (_) => Authentication())],
        child: MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            // 'en' is the language code. We could optionally provide a
            // a country code as the second param, e.g.
            // Locale('en', 'US'). If we do that, we may want to
            // provide an additional app_en_US.arb file for
            // region-specific translations.
            Locale('en', ''),
            Locale('fr', 'FR'),
          ],
          title: "Page connection",
          theme: ThemeData(
              textTheme: const TextTheme(//Just for examples
                // headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
                // headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
                // bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
              ),
              colorScheme: ColorScheme(
                primary: CustomColors.darkPrimaryColor, //Indigo
                secondary: CustomColors.accentColor, //Orange
                onPrimary: CustomColors.textIcons, //White
                onSecondary: CustomColors.textIcons, //White
                onError: CustomColors.textIcons, //White
                error: Colors.red,
                surface: CustomColors.textIcons, //Time selector
                onSurface: CustomColors.primaryText, //Time selector
                brightness: Brightness.light,
                background: CustomColors.darkPrimaryColor, //Probably not used
                onBackground: CustomColors.textIcons, //Probably not used
              )
            // primarySwatch: Colors.indigo,

            // primaryColor: CustomColors.darkPrimaryColor,
            // primaryColorDark: CustomColors.darkPrimaryColor,
            // primaryColorLight: CustomColors.lightPrimaryColor,

            // primaryTextTheme: Typography().black,
            // textTheme: Typography().black,
          ),
          //indiquer sur quelle page il va commencer quand lancer l'app
          //home: const LoginScreen(),
          home: DashboardScreen(),
        ),
      );
    /*return MultiProvider(
      providers: [Provider<Authentication>(create: (_) => Authentication())],
      child: MaterialApp(
        title: "Page connection",
        theme: ThemeData(
            textTheme: const TextTheme(//Just for examples
                // headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
                // headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
                // bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
                ),
            colorScheme: ColorScheme(
              primary: CustomColors.darkPrimaryColor, //Indigo
              secondary: CustomColors.accentColor, //Orange
              onPrimary: CustomColors.textIcons, //White
              onSecondary: CustomColors.textIcons, //White
              onError: CustomColors.textIcons, //White
              error: Colors.red,
              surface: CustomColors.textIcons, //Time selector
              onSurface: CustomColors.primaryText, //Time selector
              brightness: Brightness.light,
              background: CustomColors.darkPrimaryColor, //Probably not used
              onBackground: CustomColors.textIcons, //Probably not used
            )
            // primarySwatch: Colors.indigo,

            // primaryColor: CustomColors.darkPrimaryColor,
            // primaryColorDark: CustomColors.darkPrimaryColor,
            // primaryColorLight: CustomColors.lightPrimaryColor,

            // primaryTextTheme: Typography().black,
            // textTheme: Typography().black,
            ),
        //indiquer sur quelle page il va commencer quand lancer l'app
        //home: const LoginScreen(),
        home: DashboardScreen(),
      ),
    );*/
  }
}
