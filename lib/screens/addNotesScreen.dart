import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/screens/noteDetail.dart';
import 'package:notes/screens/notesScreen.dart';
import 'package:notes/size_config.dart';

import '../main.dart';

class AddNotesScreen extends StatefulWidget {
  static const String routeName = '/add-notes';
  @override
  _AddNotesScreenState createState() => _AddNotesScreenState();
}

class _AddNotesScreenState extends State<AddNotesScreen> {
  TextEditingController _title = TextEditingController();
  TextEditingController _desc = TextEditingController();
  TextEditingController _hour = TextEditingController();
  TextEditingController _minutes = TextEditingController();
  TextEditingController _seconds = TextEditingController();

  File _pickedImage = null;

  Future<void> _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    // _pickedImage = await getImageFileFromAssets('images/default-image.jpg');

    setState(() {
      _pickedImage = image;
    });

    // widget.imagePickedFn(_pickedImage);
  }

  Future<void> _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    // _pickedImage = await getImageFileFromAssets('images/default-image.jpg');

    setState(() {
      _pickedImage = image;
    });
  }

  addNotes() async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    String url = '';
    User user = FirebaseAuth.instance.currentUser;
    if (_pickedImage != null) {
      String pp = _pickedImage.path.replaceAll('/', '');
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(user.uid)
          .child(pp);
      await ref.putFile(_pickedImage).onComplete;

      url = await ref.getDownloadURL();
    }
    await FirebaseFirestore.instance
        .collection('notesRoom')
        .doc(user.uid)
        .collection('notes')
        .add({
      'title': _title.text.trim(),
      'desc': _desc.text.trim(),
      'createdAt': Timestamp.now(),
      'lastUpdated': Timestamp.now(),
      'imageUrl': url,
    });
  }

  void _showPicker(context) {
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
            padding:
                EdgeInsets.symmetric(vertical: SizeConfig.heightMultiplier * 3),
            height: SizeConfig.heightMultiplier * 15,
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                  child: Column(children: [
                    Container(
                      child: new Icon(
                        Icons.photo_camera,
                        size: 30,
                        color: Colors.green[300],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.heightMultiplier * 1.5),
                      child: Text(
                        'Camera',
                        style: TextStyle(
                            fontSize: SizeConfig.heightMultiplier * 1.5,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ]),
                ),
                InkWell(
                  onTap: () {
                    _imgFromGallery();
                    Navigator.of(context).pop();
                  },
                  child: Column(children: [
                    Container(
                      child: new Icon(
                        Icons.photo_library,
                        size: SizeConfig.heightMultiplier * 3,
                        color: Colors.red[500],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: SizeConfig.heightMultiplier * 1.5),
                      child: Text(
                        'Gallery',
                        style: TextStyle(
                            fontSize: 15,
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
        _title.text.trim(),
        _desc.text.trim(),
        scheduledNotificationDateTime,
        platformChannelSpecifics);
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
                    Navigator.of(context)
                        .pushReplacementNamed(NotesScreen.routeName);
                  },
                  child: Container(
                    padding: EdgeInsets.all(SizeConfig.heightMultiplier),
                    height: SizeConfig.heightMultiplier * 5,
                    width: SizeConfig.widthMultiplier * 11,
                    margin: EdgeInsets.only(
                        top: SizeConfig.heightMultiplier * 5,
                        left: SizeConfig.widthMultiplier * 2),
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
                          _showPicker(context);
                        },
                        child: CircleAvatar(
                          radius: SizeConfig.heightMultiplier * 4,
                          backgroundImage: _pickedImage != null
                              ? FileImage(_pickedImage)
                              : AssetImage('assets/images/demo.jpg'),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier,
                      ),
                      InkWell(
                        onTap: () {
                          _showPicker(context);
                        },
                        child: Container(
                          padding: EdgeInsets.all(SizeConfig.widthMultiplier),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(
                                SizeConfig.widthMultiplier),
                          ),
                          child: Text(
                            'Add Image',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      height: SizeConfig.heightMultiplier * 10,
                      margin: EdgeInsets.symmetric(
                        vertical: SizeConfig.heightMultiplier * 2,
                        horizontal: SizeConfig.widthMultiplier * 2,
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.heightMultiplier,
                        horizontal: SizeConfig.widthMultiplier * 5,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              SizeConfig.widthMultiplier * 3),
                          color: Colors.white),
                      child: TextFormField(
                        controller: _title,
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
                  controller: _desc,
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
        children: [
          InkWell(
            onTap: () {
              _showTimerPicker(context);
            },
            child: Container(
              margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 8),
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
                      style:
                          TextStyle(fontSize: SizeConfig.heightMultiplier * 2),
                    ),
                  )
                ],
              ),
            ),
          ),
          Spacer(),
          FloatingActionButton(
            backgroundColor: Color(0xff171719),
            onPressed: () {
              addNotes();

              Navigator.of(context).pushReplacementNamed(NotesScreen.routeName);
            },
            child: Icon(Icons.save),
          ),
        ],
      ),
    );
  }
}
