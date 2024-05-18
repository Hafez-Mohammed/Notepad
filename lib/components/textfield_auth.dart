import 'package:flutter/material.dart';

class TextfieldAuth extends StatelessWidget {
  final TextEditingController myController;
  final String? Function(String?)? validator;
  final String hint;
  final bool isObscure;
  final int? lines;
  const TextfieldAuth({Key? key, required this.myController, required this.hint, required this.isObscure, this.validator, this.lines})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: (lines != null)? lines : 1,
      validator: validator,
      obscureText: isObscure,
      controller: myController,
      cursorColor: Color.fromARGB(255, 255, 153, 0),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color.fromARGB(255, 215, 209, 209),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.grey,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.grey,
            )),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.grey,
            )),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.grey,
            )),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 14,),
      ),
    );
  }
}
