import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/components/sign_button.dart';
import 'package:flutter_course/components/textfield_auth.dart';

class UpdateCategory extends StatefulWidget {
  final String catName;
  final String docId;
  const UpdateCategory({ Key? key, required this.catName, required this.docId }) : super(key: key);

  @override
  _UpdateCategoryState createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateCategory> {
   bool isLoading = false;
  TextEditingController folderName = TextEditingController();
  CollectionReference categories =
      FirebaseFirestore.instance.collection("Categories");

  Future updateCategory() async {
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
      await categories.doc(widget.docId).update({'name' : folderName.text.trim()});
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Good',
        desc: "Category updated",
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
  void initState() {
    folderName.text = widget.catName;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Update Category'),),
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
                  title: "Save",
                  action: updateCategory,
                ),
              )
            ],
          ),
        ));
  }
}