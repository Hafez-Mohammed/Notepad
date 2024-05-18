// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_course/notes/add_note.dart';
import 'package:flutter_course/notes/edit_note.dart';

class Notes extends StatefulWidget {
  final String docId;
  final String catName;
  const Notes({super.key, required this.docId, required this.catName});

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  bool isLoading = true;
  List<QueryDocumentSnapshot> notes = [];

  Future getNotes() async {
    await FirebaseFirestore.instance
        .collection('Categories')
        .doc(widget.docId)
        .collection('Notes')
        .orderBy('date', descending: true)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        notes.add(doc);
      });
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddNote(
                docId: widget.docId,
                catName: widget.catName,
              ),
            ));
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text(widget.catName),
        ),
        body: PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              if (didPop) {
                return;
              }
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('home', (route) => false);
            },
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(15),
                    child: ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditNote(
                              catName: widget.catName,
                              docId: widget.docId,
                              noteId: notes[index].id,
                              noteContent: notes[index]['content'],
                            ),
                          ));
                        },
                        onLongPress: () {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.rightSlide,
                            desc: "Do you want to delete Note ?",
                            btnOkOnPress: () async {
                              await FirebaseFirestore.instance
                                  .collection('Categories')
                                  .doc(widget.docId)
                                  .collection('Notes')
                                  .doc(notes[index].id)
                                  .delete();
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                builder: (context) => Notes(
                                    docId: widget.docId,
                                    catName: widget.catName),
                              ));
                            },
                            btnCancelOnPress: () {},
                          ).show();
                        },
                        child: SizedBox(
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: RichText(
                                            text: TextSpan(
                                          text: notes[index]['content'],
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black),
                                        )),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      (notes[index]['image'] != 'none')
                                          ? Image.network(
                                              notes[index]['image'],
                                              width: 150,
                                              height: 150,
                                              fit: BoxFit.fill,
                                            )
                                          : SizedBox(
                                              height: 150,
                                            )
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                        '${DateTime.parse(notes[index]['date']).year}-${DateTime.parse(notes[index]['date']).month}-${DateTime.parse(notes[index]['date']).day}   ${DateTime.parse(notes[index]['date']).hour}:${DateTime.parse(notes[index]['date']).minute}'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ))));
  }
}
