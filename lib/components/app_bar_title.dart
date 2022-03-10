import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';

class AppBarTitle extends StatelessWidget {
  //const AppBarTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'asset/image/firebase_logo.png',
          height: 20,
        ),
        SizedBox(width: 8),
        Text(
          'iziSecure',
          style: TextStyle(
            color: CustomColors.firebaseYellow,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
