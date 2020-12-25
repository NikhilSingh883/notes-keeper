import 'package:flutter/material.dart';

class Note {
  final String title;
  final String description;

  Note({
    @required this.description,
    @required this.title,
  });

  set title(String tit) {
    this.title = tit;
  }

  set description(String desc) {
    this.description = desc;
  }

  String get getDescription {
    return this.description;
  }

  String get getTitle {
    return this.title;
  }
}
