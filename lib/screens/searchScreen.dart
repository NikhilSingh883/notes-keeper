import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/screens/notesScreen.dart';
import 'package:notes/size_config.dart';
import 'package:notes/widgets/noteTile.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with TickerProviderStateMixin {
  TextEditingController searchTextEditingController =
      new TextEditingController();

  QuerySnapshot searchSnapshot;
  User user = FirebaseAuth.instance.currentUser;

  getData() {
    return FirebaseFirestore.instance
        .collection('notesRoom')
        .doc(user.uid)
        .collection('notes')
        .where('title', isEqualTo: searchTextEditingController.text.trim())
        .snapshots();
  }

  double _width = 0;
  double _height = 0;

  Widget searchList() {
    return StreamBuilder(
      stream: getData(),
      builder: (_, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.documents.length,
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemBuilder: (__, index) {
                  final String docID = snapshot.data.documents[index].id;
                  print(docID);
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

  double __width = 0;
  double __height = 0;
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff171719),
      body: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx > 0) {
            Navigator.of(context).pushReplacementNamed(NotesScreen.routeName);
          }
        },
        child: Stack(
          overflow: Overflow.clip,
          children: [
            SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 7,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          Text(
                            'Search',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.heightMultiplier * 2.5,
                                fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
                          Container(
                            padding:
                                EdgeInsets.all(SizeConfig.heightMultiplier),
                            decoration: BoxDecoration(
                              color: Color(0xff444446),
                              borderRadius: BorderRadius.circular(
                                  SizeConfig.widthMultiplier * 4),
                            ),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _height = SizeConfig.heightMultiplier * 5;
                                  _width = MediaQuery.of(context).size.width;
                                });
                              },
                              child: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: SizeConfig.heightMultiplier * 3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    AnimatedSize(
                      curve: Curves.ease,
                      duration: Duration(seconds: 1),
                      vsync: this,
                      child: Container(
                        margin: EdgeInsets.only(
                          top: SizeConfig.heightMultiplier * 2,
                          left: SizeConfig.widthMultiplier,
                          right: SizeConfig.widthMultiplier,
                        ),
                        child: Container(
                          height: _height,
                          width: _width,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(
                                SizeConfig.heightMultiplier * 6),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.heightMultiplier / 2,
                              horizontal: SizeConfig.widthMultiplier * 4),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: searchTextEditingController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter details....',
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                      fontSize: SizeConfig.heightMultiplier * 2,
                                      color: Colors.white70),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      // height: double.infinity,
                      margin: EdgeInsets.only(top: SizeConfig.heightMultiplier),
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.widthMultiplier * 2),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft:
                              Radius.circular(SizeConfig.widthMultiplier * 6),
                          topRight:
                              Radius.circular(SizeConfig.widthMultiplier * 6),
                        ),
                      ),
                      child: Column(
                        children: [
                          SingleChildScrollView(
                            child: searchList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
