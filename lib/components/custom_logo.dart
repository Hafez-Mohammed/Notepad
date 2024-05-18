import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        width: 100,
        height: 100,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Color.fromARGB(255, 227, 221, 221)),
        child: Center(
            child: Image.asset(
          "images/launch.png",
          width: 75,
          height: 75,
        )),
      ),
    );
  }
}
