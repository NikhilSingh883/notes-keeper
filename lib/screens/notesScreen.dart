import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/screens/addNotesScreen.dart';
import 'package:notes/screens/searchScreen.dart';
import 'package:notes/screens/sign_in_screen.dart';
import 'package:notes/size_config.dart';
import 'package:notes/widgets/noteTile.dart';

class Filter {
  static String alphabet = 'alpha';
  static String cTime = 'created';
  static String uTime = 'updated';
}

class NotesScreen extends StatefulWidget {
  static const String routeName = '/notes';
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen>
    with TickerProviderStateMixin {
  TextEditingController searchTextEditingController =
      new TextEditingController();
  Stream notesStream;
  @override
  void initState() {
    // TODO: implement initState
    getNotes();
    super.initState();
  }

  User user = FirebaseAuth.instance.currentUser;
  var filter = Filter.alphabet;
  getNotes() {
    Stream stream1 = FirebaseFirestore.instance
        .collection("notesRoom")
        .doc(user.uid)
        .collection("notes")
        .orderBy('createdAt', descending: true)
        .snapshots();
    Stream stream2 = FirebaseFirestore.instance
        .collection("notesRoom")
        .doc(user.uid)
        .collection("notes")
        .orderBy('lastUpdated', descending: true)
        .snapshots();
    Stream stream3 = FirebaseFirestore.instance
        .collection("notesRoom")
        .doc(user.uid)
        .collection("notes")
        .orderBy('title')
        .snapshots();

    if (filter == Filter.alphabet)
      return stream3;
    else if (filter == Filter.cTime)
      return stream1;
    else
      return stream2;
  }

  Widget notesList() {
    return StreamBuilder(
      stream: getNotes(),
      builder: (_, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (__, index) {
                  final String docID = snapshot.data.documents[index].id;
                  return NotesTile(
                    Note(
                      description: snapshot.data.documents[index]['desc'],
                      title: snapshot.data.documents[index]['title'],
                    ),
                    docID,
                    snapshot.data.documents[index]['createdAt'],
                    snapshot.data.documents[index]['lastUpdated'],
                    snapshot.data.documents[index]['imageUrl'],
                  );
                })
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff171719),
      appBar: AppBar(
        backgroundColor: Color(0xff171719),
        automaticallyImplyLeading: false,
        actions: [
          SizedBox(
            width: SizeConfig.widthMultiplier * 3,
          ),
          Text(
            'Notes',
            style: TextStyle(fontSize: SizeConfig.heightMultiplier * 3),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushReplacementNamed(SignInScreen.routeName);
            },
          ),
          IconButton(
            icon: Icon(Icons.search_rounded),
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(SearchScreen.routeName);
            },
          ),
        ],
      ),
      body: Container(
        height: SizeConfig.heightMultiplier * 90,
        child: notesList(),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            heroTag: '1',
            onPressed: () {
              setState(() {
                filter = Filter.cTime;
              });
            },
            child: Icon(
              Icons.timelapse,
              color: Color(0xff171719),
            ),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 2,
          ),
          FloatingActionButton(
            backgroundColor: Colors.white,
            heroTag: '2',
            onPressed: () {
              setState(() {
                filter = Filter.uTime;
              });
            },
            child: Icon(
              Icons.access_time_outlined,
              color: Color(0xff171719),
            ),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 2,
          ),
          FloatingActionButton(
            backgroundColor: Colors.white,
            heroTag: '3',
            onPressed: () {
              setState(() {
                filter = Filter.alphabet;
              });
            },
            child: Icon(
              Icons.sort_by_alpha,
              color: Color(0xff171719),
            ),
          ),
          SizedBox(
            height: SizeConfig.heightMultiplier * 2,
          ),
          FloatingActionButton(
            backgroundColor: Colors.white,
            heroTag: '4',
            onPressed: () {
              Navigator.of(context)
                  .pushReplacementNamed(AddNotesScreen.routeName);
            },
            child: Icon(
              Icons.add,
              color: Color(0xff171719),
            ),
          ),
        ],
      ),
    );
  }
}
