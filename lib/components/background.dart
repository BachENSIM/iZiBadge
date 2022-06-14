import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({
    Key? key,
    required this.child,
  }) : super(key: key);
  //Cette page pour déco la page de connexion
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
                "asset/image/top1.png",
                width: size.width
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Image.asset(
                "asset/image/top2.png",
                width: size.width
            ),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
                "asset/image/bottom2.png",
                width: size.width
            ),
          ),
          child
        ],
      ),
    );
  }
}