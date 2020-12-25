import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseMethods {
  getUserNotes(String userId) async {
    return FirebaseFirestore.instance
        .collection('notesRoom')
        .doc(userId)
        .collection('notes')
        .snapshots();
  }
}
