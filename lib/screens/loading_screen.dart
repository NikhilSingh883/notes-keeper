import 'package:flutter/material.dart';
import 'package:notes/widgets/bounce.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Bounce('assets/images/signIn.png'),
            Text(
              'Loading...',
              style: TextStyle(color: Colors.white60, fontSize: 20),
            ),
          ]),
    );
  }
}
