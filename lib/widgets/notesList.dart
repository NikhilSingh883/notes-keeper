import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/note.dart';
import 'package:notes/widgets/noteTile.dart';

class NotesList extends StatelessWidget {
  final Stream notesStream;
  NotesList(this.notesStream);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: notesStream,
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
}
