import 'package:flutter/cupertino.dart';
import 'package:notes/models/note.dart';

class NotesProvider with ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get getNotes {
    return [..._notes];
  }
}
