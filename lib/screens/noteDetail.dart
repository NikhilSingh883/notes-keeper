import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/size_config.dart';

class NotesDetailScreen extends StatefulWidget {
  static const String routeName = '/note-detail';
  final Note note;
  final String noteId;
  NotesDetailScreen(this.note, this.noteId);

  @override
  _NotesDetailScreenState createState() => _NotesDetailScreenState();
}

class _NotesDetailScreenState extends State<NotesDetailScreen> {
  //  String titlee = widget.note.title;
  TextEditingController _title = TextEditingController();
  TextEditingController _desc = TextEditingController();
  static String title = '';
  String desc = '';
  updateNotes() async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    User user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('notesRoom')
        .doc(user.uid)
        .collection('notes')
        .doc(widget.noteId)
        .update({
      'title': title == '' ? widget.note.title : title,
      'desc': desc == '' ? widget.note.description : desc,
      'lastUpdated': Timestamp.now(),
    });
  }

  delteteNotes() async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    User user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('notesRoom')
        .doc(user.uid)
        .collection('notes')
        .doc(widget.noteId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.widthMultiplier,
                vertical: SizeConfig.heightMultiplier),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      height: SizeConfig.heightMultiplier * 5,
                      width: SizeConfig.widthMultiplier * 11,
                      margin: EdgeInsets.only(
                        left: SizeConfig.widthMultiplier * 5,
                        top: SizeConfig.heightMultiplier * 2,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              SizeConfig.widthMultiplier * 5),
                          color: Colors.green[400]),
                      child: Image(
                        image: AssetImage('assets/images/send.png'),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: SizeConfig.heightMultiplier * 5,
                      backgroundImage: AssetImage('assets/images/demo.jpg'),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        height: SizeConfig.heightMultiplier * 10,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(
                            vertical: SizeConfig.heightMultiplier * 2,
                            horizontal: SizeConfig.widthMultiplier * 2),
                        padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.heightMultiplier,
                          horizontal: SizeConfig.widthMultiplier * 5,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                SizeConfig.widthMultiplier * 3),
                            color: Colors.white),
                        child: TextFormField(
                          onChanged: (val) {
                            title = val;
                          },
                          initialValue: widget.note.title,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w600),
                          textAlign: TextAlign.left,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: SizeConfig.heightMultiplier * 100,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                      vertical: SizeConfig.heightMultiplier * 2),
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.heightMultiplier * 3,
                    horizontal: SizeConfig.widthMultiplier * 10,
                  ),
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.widthMultiplier * 3),
                      color: Colors.white),
                  child: TextFormField(
                    maxLines: 30,
                    onChanged: (val) {
                      desc = val;
                    },
                    initialValue: widget.note.description,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: SizeConfig.widthMultiplier * 7,
            ),
            FloatingActionButton(
              backgroundColor: Color(0xff171719),
              heroTag: '1',
              onPressed: () {
                delteteNotes();
                Navigator.of(context).pop();
              },
              child: Icon(Icons.delete),
            ),
            Spacer(),
            FloatingActionButton(
              backgroundColor: Color(0xff171719),
              heroTag: '2',
              onPressed: () {
                updateNotes();
                Navigator.of(context).pop();
              },
              child: Icon(Icons.save),
            ),
          ],
        ));
  }
}
