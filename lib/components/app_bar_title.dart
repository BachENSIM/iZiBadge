import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/components/search_form.dart';

class AppBarTitle extends StatelessWidget {
  //const AppBarTitle({Key? key}) : super(key: key);
  //Cette page pour afficher l'app bar title sur la page d'accueil
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'asset/image/firebase_logo.png',
          height: 20,
        ),
        const SizedBox(width: 8),
        const Text(
          'iZiBadge',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
