import 'package:flutter/material.dart';
import 'package:izibagde/components/custom_colors.dart';
import 'package:izibagde/components/search_form.dart';

class AppBarTitle extends StatelessWidget {
  //const AppBarTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).padding.top,
      //width: MediaQuery.of(context).padding.top,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'asset/image/firebase_logo.png',
            height: 20,
          ),
          SizedBox(width: 8),
          const Text(
            'iZiBadge',
            style: TextStyle(
              //color: CustomColors.accentLight,
              fontSize: 18,
            ),
          ),
          SizedBox(width: 225),
          /*IconButton(
            onPressed: () {
              */ /*Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SearchForm()));*/ /*
              showDialog(
                  context: context,
                  builder: (context) {
                    return SearchForm();
                  });
            },
            icon: Icon(Icons.search_rounded)),*/
        ],
      ),
    );
  }
}
