import 'package:flutter/material.dart';
import 'package:notes/size_config.dart';
import 'package:notes/widgets/auth/auth_form.dart';
import 'package:notes/widgets/bounce.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = 'sign-in';

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // height: MediaQuery.of(context).size.height * 0.5,
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 5,
                  ),
                  Bounce('assets/images/signIn.png'),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 2,
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: SizeConfig.widthMultiplier * 2),
                    padding: EdgeInsets.all(SizeConfig.widthMultiplier * 1.5),
                    child: Text(
                      'Welcome',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: SizeConfig.heightMultiplier * 3),
                    ),
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: SizeConfig.widthMultiplier * 2),
                    padding: EdgeInsets.all(SizeConfig.widthMultiplier * 1.5),
                    child: Text(
                      'Sign in to continue',
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: SizeConfig.heightMultiplier * 1.5),
                    ),
                  ),
                ],
              ),
            ),
            AuthForm(true),
          ],
        ),
      ),
    );
  }
}
