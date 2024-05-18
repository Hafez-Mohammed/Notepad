import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/components/sign_button.dart';
import 'package:flutter_course/components/textfield_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_course/notes/notes.dart';
import 'package:image_picker/image_picker.dart';

class AddNote extends StatefulWidget {
  final String docId;
  final String catName;

  const AddNote({Key? key, required this.docId, required this.catName})
      : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  File? file;
  String? imageName;
  String? url;
  bool isLoading = false;
  TextEditingController noteContent = TextEditingController();

  getImage() async {
    final ImagePicker picker = ImagePicker();
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        file = File(image.path);
        imageName = image.path.split('/').last;
      });
    }
  }

  Future addNote() async {
    if (noteContent.text == "") {
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.rightSlide,
        desc: "Note Name can not be empty",
        btnOkOnPress: () {},
      ).show();
    }
    try {
      setState(() {
        isLoading = true;
      });
      if (file != null) {
        final storageRef = FirebaseStorage.instance.ref('images/$imageName');
        await storageRef.putFile(file!);
        url = await storageRef.getDownloadURL();
      }

      CollectionReference notes = FirebaseFirestore.instance
          .collection("Categories")
          .doc(widget.docId)
          .collection('Notes');
      await notes.add({'content': noteContent.text, 'image': url ?? 'none', 'date' : DateTime.now().toString()});
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Good',
        desc: "Note added",
        btnOkOnPress: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                Notes(docId: widget.docId, catName: widget.catName),
          ));
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
        appBar: AppBar(
          title: Text('Add Note'),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextfieldAuth(
                        myController: noteContent,
                        hint: "Type your Note",
                        isObscure: false,
                        lines: 10,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 150,
                        child: getImageButton(
                          title: "Choose Image",
                          action: getImage,
                          isSelected: (file != null) ? true : false,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 150,
                        child: SignButton(
                          title: "Add",
                          action: addNote,
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}

class getImageButton extends StatelessWidget {
  final bool isSelected;
  final String title;
  final void Function()? action;
  const getImageButton({
    Key? key,
    required this.title,
    required this.action,
    required this.isSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: action,
      minWidth: 500,
      color: isSelected ? Colors.green : Colors.orange,
      shape: MaterialStateOutlineInputBorder.resolveWith((states) =>
          OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(style: BorderStyle.none))),
      child: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
