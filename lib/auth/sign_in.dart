// ignore_for_file: unused_local_variable, unused_element
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/auth/custom_validator.dart';
import 'package:flutter_course/components/custom_logo.dart';
import 'package:flutter_course/components/sign_button.dart';
import 'package:flutter_course/components/textfield_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.of(context).pushReplacementNamed("home");
    } on FirebaseAuthException catch (e) {
      AwesomeDialog(
        context: context,
        title: 'Erorr',
        body: Text(e.message!),
        dialogType: DialogType.error,
        btnOkOnPress: () {},
      );
    }
  }

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('============User is currently signed out!');
      } else {
        print('============User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                CustomLogo(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Login",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Login to continue using the App",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 15),
                Text(
                  "Email",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                TextfieldAuth(
                  validator: (p0) => customValidator(p0, "password"),
                  myController: password,
                  hint: "Enter your Password",
                  isObscure: true,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(top: 8, bottom: 15),
                  child: InkWell(
                    onTap: () async {
                      if (email.text == "") {
                        return AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.rightSlide,
                          title: 'warning',
                          desc: "Please input your Email first",
                          btnOkOnPress: () {},
                        ).show();
                      }
                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email.text.trim());
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
                    },
                    child: Text(
                      "Forgot Password ?",
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                  ),
                ),
                SignButton(
                  title: "Login",
                  action: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        final credential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: email.text.trim(),
                                password: password.text.trim());
                        if (FirebaseAuth.instance.currentUser!.emailVerified) {
                          Navigator.of(context).pushReplacementNamed("home");
                        } else {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.rightSlide,
                            title: 'Warning',
                            desc: "Go to your Email and verfy it",
                            btnOkOnPress: () {},
                          ).show();
                        }
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
                SizedBox(height: 15),
                MaterialButton(
                  onPressed: () {
                    signInWithGoogle();
                  },
                  minWidth: 500,
                  color: Colors.red,
                  shape: MaterialStateOutlineInputBorder.resolveWith((states) =>
                      OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(style: BorderStyle.none))),
                  child: Text("Login With Google",
                      style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
                SizedBox(height: 5),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed("signup");
                  },
                  child: Center(
                    child: RichText(
                        text: TextSpan(
                            style:
                                TextStyle(color: Colors.black45, fontSize: 14),
                            children: [
                          TextSpan(text: "Do not have Account ?  "),
                          TextSpan(
                              text: "Sing Up",
                              style: TextStyle(color: Colors.blue))
                        ])),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
