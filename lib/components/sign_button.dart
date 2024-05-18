import 'package:flutter/material.dart';

class SignButton extends StatelessWidget {
  final String title;
  final void Function()? action; 
  const SignButton({Key? key, required this.title,required this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: action,
      minWidth: 500,
      color: Colors.orange,
      shape: MaterialStateOutlineInputBorder.resolveWith((states) =>
          OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(style: BorderStyle.none))),
      child: Text(title,style: TextStyle(color: Colors.white,fontSize: 16),),
    );
  }
}
