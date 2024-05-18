// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/notes/notes.dart';
import 'package:flutter_course/update_category.dart';
import 'package:google_sign_in/google_sign_in.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  bool isLoading = true;
  List<QueryDocumentSnapshot> categories = [];

  Future getCategories() async {
    await FirebaseFirestore.instance
        .collection('Categories')
        .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        categories.add(doc);
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushNamed("addCategory");
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text("NotePad"),
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  bool isGoogleSignedIn = await GoogleSignIn().isSignedIn();
                  if (isGoogleSignedIn) {
                    await GoogleSignIn().signOut();
                  }

                  Navigator.of(context).pushReplacementNamed("signin");
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(15),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: categories.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Notes(
                              docId: categories[index].id,
                              catName: categories[index]['name'])));
                    },
                    onLongPress: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        desc: "What do you want ?",
                        btnOkText: "Update",
                        btnOkOnPress: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => UpdateCategory(
                                  catName: categories[index]['name'],
                                  docId: categories[index].id)));
                        },
                        btnCancelText: "Delete",
                        btnCancelOnPress: () async {
                          await FirebaseFirestore.instance
                              .collection('Categories')
                              .doc(categories[index].id)
                              .delete();
                          Navigator.of(context).pushReplacementNamed('home');
                        },
                      ).show();
                    },
                    child: Card(
                      child: Column(
                        children: [
                          Image.asset(
                            "images/folder.png",
                            width: 70,
                            height: 70,
                          ),
                          Text(
                            categories[index]['name'],
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                )));
  }
}
