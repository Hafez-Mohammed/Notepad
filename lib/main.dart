// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/add_category.dart';
import 'package:flutter_course/auth/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_course/auth/sign_up.dart';
import 'package:flutter_course/home_page.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notepad",
      theme: ThemeData(
          colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary: Color.fromARGB(255, 255, 153, 0),
              onPrimary: Colors.white,
              secondary: Colors.white,
              onSecondary: Colors.white,
              error: Colors.white,
              onError: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black),
          progressIndicatorTheme: ProgressIndicatorThemeData(
              color: Color.fromARGB(255, 255, 153, 0)),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Color.fromARGB(255, 255, 153, 0),
          ),
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.white10,
              titleTextStyle: TextStyle(
                  color: Color.fromARGB(255, 255, 153, 0), fontSize: 20),
              iconTheme:
                  IconThemeData(color: Color.fromARGB(255, 255, 153, 0)))),
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null &&
              FirebaseAuth.instance.currentUser!.emailVerified)
          ? HomePage()
          : SignIn(),
      routes: {
        "home": (context) => HomePage(),
        "signin": (context) => SignIn(),
        "signup": (context) => SignUP(),
        "addCategory": (context) => AddCategory(),
      },
    );
  }
}
