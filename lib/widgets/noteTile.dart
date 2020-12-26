import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notes/models/note.dart';
import 'package:notes/screens/noteDetail.dart';
import 'package:notes/size_config.dart';

import '../main.dart';

class NotesTile extends StatelessWidget {
  final Note note;
  final String docID;
  final Timestamp created;
  final Timestamp lastUpdated;
  final String url;
  NotesTile(this.note, this.docID, this.created, this.lastUpdated, this.url);

  String returnDateAndTime(Timestamp stamp) {
    return '${stamp.toDate().day} - ${stamp.toDate().month} - ${stamp.toDate().year} , ${stamp.toDate().hour}:${stamp.toDate().minute}';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return NotesDetailScreen(note, docID, url);
        }));
      },
      child: Container(
        height: SizeConfig.heightMultiplier * 12,
        margin: EdgeInsets.symmetric(
          vertical: SizeConfig.heightMultiplier,
          horizontal: SizeConfig.widthMultiplier,
        ),
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.widthMultiplier * 6,
            vertical: SizeConfig.heightMultiplier),
        decoration: BoxDecoration(
            // image: DecorationImage(
            //     // image: AssetImage('assets/images/space.jpg'),
            //     fit: BoxFit.cover),
            color: Colors.white,
            border: Border.all(
                width: SizeConfig.widthMultiplier / 10, color: Colors.black),
            borderRadius:
                BorderRadius.circular(SizeConfig.widthMultiplier * 5)),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: url == ''
                  ? AssetImage('assets/images/demo.jpg')
                  : NetworkImage(url),
            ),
            SizedBox(width: SizeConfig.widthMultiplier * 4),
            Container(
              width: SizeConfig.widthMultiplier * 35,
              child: Text(
                note.title,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: TextStyle(
                  fontSize: SizeConfig.heightMultiplier * 2,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Spacer(),
            FittedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Created At -',
                    style: TextStyle(
                        fontSize: SizeConfig.heightMultiplier * 1.2,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    returnDateAndTime(created),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: SizeConfig.heightMultiplier * 1.2),
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier,
                  ),
                  Text(
                    'Updated At -',
                    style: TextStyle(
                        fontSize: SizeConfig.heightMultiplier * 1.2,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    returnDateAndTime(lastUpdated),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style:
                        TextStyle(fontSize: SizeConfig.heightMultiplier * 1.2),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
