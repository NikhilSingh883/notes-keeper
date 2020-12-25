import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/screens/addNotesScreen.dart';
import 'package:notes/screens/notesScreen.dart';
import 'package:notes/screens/searchScreen.dart';
import 'package:notes/screens/sign_in_screen.dart';
import 'package:notes/screens/sign_up_screen.dart';
import 'package:notes/size_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return MaterialApp(
              title: 'Notes Keeper',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) return NotesScreen();
                  return SignInScreen();
                },
              ),
              routes: {
                SignUpScreen.routeName: (context) => SignUpScreen(),
                SignInScreen.routeName: (context) => SignInScreen(),
                NotesScreen.routeName: (context) => NotesScreen(),
                AddNotesScreen.routeName: (context) => AddNotesScreen(),
                SearchScreen.routeName: (context) => SearchScreen(),
              },
            );
          },
        );
      },
    );
  }
}
