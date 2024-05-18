import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/components/sign_button.dart';
import 'package:flutter_course/components/textfield_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  bool isLoading = false;
  TextEditingController folderName = TextEditingController();
  CollectionReference categories =
      FirebaseFirestore.instance.collection("Categories");

  Future addCategory() async {
    if (folderName.text == "") {
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        desc: "Category Name can not be empty",
        btnOkOnPress: () {},
      ).show();
    }
    try {
      setState(() {
        isLoading = true;
      });
      await categories.add({'name': folderName.text.trim(), 'user_id' : FirebaseAuth.instance.currentUser!.uid});
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Good',
        desc: "Category added",
        btnOkOnPress: () {
          Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
        },
      ).show();
    } catch (e) {
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        animType: AnimType.rightSlide,
        title: 'Erorr',
        desc: e.toString(),
        btnOkOnPress: () {},
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Add Category'),),
        body: isLoading ? Center(child: CircularProgressIndicator(),) : Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextfieldAuth(
                myController: folderName,
                hint: "Enter name of new folder",
                isObscure: false,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: 150,
                child: SignButton(
                  title: "Add",
                  action: addCategory,
                ),
              )
            ],
          ),
        ));
  }
}
