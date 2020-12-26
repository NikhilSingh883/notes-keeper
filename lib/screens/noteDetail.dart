import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:notes/models/note.dart';
import 'package:notes/size_config.dart';

import '../main.dart';

class NotesDetailScreen extends StatefulWidget {
  static const String routeName = '/note-detail';
  final Note note;
  final String noteId;
  final String url;
  NotesDetailScreen(this.note, this.noteId, this.url);

  @override
  _NotesDetailScreenState createState() => _NotesDetailScreenState();
}

class _NotesDetailScreenState extends State<NotesDetailScreen> {
  //  String titlee = widget.note.title;
  TextEditingController _title = TextEditingController();
  TextEditingController _desc = TextEditingController();
  TextEditingController _hour = TextEditingController();
  TextEditingController _minutes = TextEditingController();
  TextEditingController _seconds = TextEditingController();
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

  bool isNumeric(String s) {
    if (s == '') return true;
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Wrong Format"),
      content: Text("Please provide proper timings"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _showTimerPicker(context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            padding: EdgeInsets.symmetric(
              vertical: SizeConfig.heightMultiplier * 3,
              horizontal: SizeConfig.widthMultiplier * 5,
            ),
            height: SizeConfig.heightMultiplier * 40,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _hour,
                    style: TextStyle(
                        fontSize: SizeConfig.heightMultiplier * 2,
                        color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'HH',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.heightMultiplier * 2,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: SizeConfig.heightMultiplier * 1.2),
                  child: Text(
                    'hour',
                    style: TextStyle(
                      fontSize: SizeConfig.heightMultiplier,
                      color: Colors.yellow,
                    ),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: SizeConfig.heightMultiplier * 1.2),
                  child: Text(
                    ':',
                    style: TextStyle(
                      fontSize: SizeConfig.heightMultiplier * 2,
                      color: Colors.yellow,
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _minutes,
                    style: TextStyle(
                        fontSize: SizeConfig.heightMultiplier * 2,
                        color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'MM',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.heightMultiplier * 2,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: SizeConfig.heightMultiplier * 1.2),
                  child: Text(
                    'min',
                    style: TextStyle(
                      fontSize: SizeConfig.heightMultiplier,
                      color: Colors.yellow,
                    ),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: SizeConfig.heightMultiplier * 1.2),
                  child: Text(
                    ':',
                    style: TextStyle(
                      fontSize: SizeConfig.heightMultiplier * 2,
                      color: Colors.yellow,
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _seconds,
                    style: TextStyle(
                        fontSize: SizeConfig.heightMultiplier * 2,
                        color: Colors.white),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'SS',
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.heightMultiplier * 2,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: SizeConfig.heightMultiplier * 1.2),
                  child: Text(
                    'sec',
                    style: TextStyle(
                      fontSize: SizeConfig.heightMultiplier,
                      color: Colors.yellow,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    if (isNumeric(_minutes.text.trim()) &&
                        isNumeric(_hour.text.trim()) &&
                        isNumeric(_seconds.text.trim())) {
                      int hour =
                          _hour.text == '' ? 0 : int.parse(_hour.text.trim());
                      int min = _minutes.text == ''
                          ? 0
                          : int.parse(_minutes.text.trim());
                      int sec = _seconds.text == ''
                          ? 0
                          : int.parse(_seconds.text.trim());
                      DateTime scheduledNotificationDateTime =
                          DateTime.now().add(
                        Duration(
                          seconds: sec,
                          hours: hour,
                          minutes: min,
                        ),
                      );

                      scheduleReminder(scheduledNotificationDateTime);
                      Navigator.pop(context);
                    } else {
                      showAlertDialog(context);
                    }
                  },
                  child: Column(children: [
                    Container(
                      child: new Icon(
                        Icons.timelapse,
                        size: SizeConfig.heightMultiplier * 5,
                        color: Colors.red[500],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.widthMultiplier * 3),
                      child: Text(
                        'Tap',
                        style: TextStyle(
                            fontSize: SizeConfig.heightMultiplier * 1.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          );
        });
  }

  void scheduleReminder(DateTime scheduledNotificationDateTime) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'notes_logo',
      // sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('notes_logo'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        0,
        title == '' ? widget.note.title : title,
        desc == '' ? widget.note.description : desc,
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            SingleChildScrollView(
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
                          updateNotes();
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
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return ImagePreview(widget.url);
                                }));
                              },
                              child: Hero(
                                tag: 'imageHero',
                                child: CircleAvatar(
                                  radius: SizeConfig.heightMultiplier * 4,
                                  backgroundImage: widget.url == ''
                                      ? AssetImage('assets/images/demo.jpg')
                                      : NetworkImage(widget.url),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.heightMultiplier,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (_) {
                                  return ImagePreview(widget.url);
                                }));
                              },
                              child: Container(
                                padding:
                                    EdgeInsets.all(SizeConfig.widthMultiplier),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.widthMultiplier),
                                ),
                                child: Text(
                                  'Tap to view',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
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
                          borderRadius: BorderRadius.circular(
                              SizeConfig.widthMultiplier * 3),
                          color: Colors.white),
                      child: TextFormField(
                        maxLines: 30,
                        onChanged: (val) {
                          desc = val;
                        },
                        initialValue: widget.note.description,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w400),
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
          ],
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
            InkWell(
              onTap: () {
                _showTimerPicker(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.widthMultiplier * 2),
                height: SizeConfig.heightMultiplier * 5,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.widthMultiplier * 5),
                  color: Colors.red[300],
                ),
                child: Row(
                  children: [
                    Icon(Icons.timer),
                    Container(
                      padding:
                          EdgeInsets.only(left: SizeConfig.widthMultiplier * 2),
                      child: Text(
                        'Set Timer',
                        style: TextStyle(
                            fontSize: SizeConfig.heightMultiplier * 2),
                      ),
                    )
                  ],
                ),
              ),
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

class ImagePreview extends StatelessWidget {
  final String url;
  ImagePreview(this.url);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: 'imageHero',
              child: Image(
                image: url == ''
                    ? AssetImage('assets/images/demo.jpg')
                    : NetworkImage(url),
              )),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
