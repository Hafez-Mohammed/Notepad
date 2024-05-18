import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/components/sign_button.dart';
import 'package:flutter_course/components/textfield_auth.dart';
import 'package:flutter_course/notes/notes.dart';

class EditNote extends StatefulWidget {
  final String catName;
  final String noteContent;
  final String docId;
  final String noteId;
  const EditNote(
      {Key? key,
      required this.catName,
      required this.docId,
      required this.noteId, required this.noteContent})
      : super(key: key);

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  bool isLoading = false;
  TextEditingController note = TextEditingController();

  Future editNote() async {
    if (note.text == "") {
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
      await FirebaseFirestore.instance
          .collection('Categories')
          .doc(widget.docId)
          .collection('Notes')
          .doc(widget.noteId)
          .update({'content': note.text});
      return AwesomeDialog(
        context: context,
        dialogType: DialogType.success,
        animType: AnimType.rightSlide,
        title: 'Good',
        desc: "Note updated",
        btnOkOnPress: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Notes(docId: widget.docId, catName: widget.catName),));
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
    note.text = widget.noteContent;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Note'),
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
                        myController: note,
                        hint: "Type your Note",
                        isObscure: false,
                        lines: 10,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 150,
                        child: SignButton(
                          title: "Save",
                          action: editNote,
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}
