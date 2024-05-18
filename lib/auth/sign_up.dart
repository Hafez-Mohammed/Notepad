// ignore_for_file: unused_local_variable

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/auth/custom_validator.dart';
import 'package:flutter_course/components/custom_logo.dart';
import 'package:flutter_course/components/sign_button.dart';
import 'package:flutter_course/components/textfield_auth.dart';

class SignUP extends StatefulWidget {
  const SignUP({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUP> {
  TextEditingController email = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confPassword = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white10,
          scrolledUnderElevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomLogo(),
                    Text(
                      "Sign Up",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Enter your personal Information",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "User Name",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    TextfieldAuth(
                      validator: (p0) => customValidator(p0, "user name"),
                      myController: userName,
                      hint: "Enter User Name",
                      isObscure: false,
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Email",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    TextfieldAuth(
                      validator: (p0) => customValidator(p0, "email"),
                      myController: email,
                      hint: "Enter your Email",
                      isObscure: false,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Password",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    TextfieldAuth(
                      validator: (p0) => customValidator(p0, "password"),
                      myController: password,
                      hint: "Enter Password",
                      isObscure: true,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Confirm Password",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),
                    TextfieldAuth(
                      validator: (p0) =>
                          customValidator(p0, "confirm password"),
                      myController: confPassword,
                      hint: "Enter Confirm Password",
                      isObscure: true,
                    ),
                    SizedBox(height: 15),
                    SignButton(
                      title: "Sign Up",
                      action: () async {
                        if (formKey.currentState!.validate()) {
                          try {
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: email.text.trim(),
                              password: password.text.trim(),
                            );
                            await FirebaseAuth.instance.currentUser!.sendEmailVerification();
                            Navigator.of(context).pushReplacementNamed("signin");
                          } on FirebaseAuthException catch (e) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Erorr',
                              desc: e.message,
                              btnOkOnPress: () {},
                            ).show();
                          }
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
