import 'package:flutter/material.dart';
import 'package:notes/screens/sign_in_screen.dart';
import 'package:notes/size_config.dart';
import 'package:notes/widgets/auth/auth_form.dart';
import 'package:notes/widgets/bounce.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = '/sign-in';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: GestureDetector(
        onPanUpdate: (details) {
          if (details.delta.dx > 0) {
            Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
          }
        },
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: SizeConfig.heightMultiplier * 5,
              ),
              Bounce('assets/images/signUp.png'),
              SizedBox(
                height: SizeConfig.heightMultiplier * 2,
              ),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 2),
                padding: EdgeInsets.all(SizeConfig.widthMultiplier * 1.5),
                // alignment: Alignment.centerLeft,
                child: Text(
                  'Welcome',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 30),
                ),
              ),
              Container(
                alignment: Alignment.center,

                margin: EdgeInsets.only(left: SizeConfig.widthMultiplier * 2),
                padding: EdgeInsets.all(SizeConfig.widthMultiplier * 1.5),
                // alignment: Alignment.centerLeft,
                child: Text(
                  'Sign up to continue',
                  style: TextStyle(color: Colors.grey[700], fontSize: 15),
                ),
              ),
              AuthForm(false),
            ],
          ),
        ),
      ),
    );
  }
}
