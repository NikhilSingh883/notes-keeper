import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes/models/error_msg.dart';
import 'package:notes/screens/notesScreen.dart';
import 'package:notes/screens/sign_in_screen.dart';
import 'package:notes/screens/sign_up_screen.dart';
import 'package:notes/size_config.dart';

class AuthForm extends StatefulWidget {
  final bool isSignUp;

  AuthForm(this.isSignUp);
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _userName = '';
  var _userEmail = '';
  var _userPassword = '';
  var _confirmPassword = '';
  var _userImageFile;

  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final TextEditingController _email = TextEditingController();

  Future<void> onSubmit(BuildContext context) async {
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }

    try {
      final res = FirebaseAuth.instance.currentUser;

      // final ref = FirebaseStorage.instance
      //     .ref()
      //     .child('user_images')
      //     .child(res.uid + '.jpg');

      // await ref.putFile(_userImageFile).onComplete;

      // final url = await ref.getDownloadURL();
      // Constraints.image = _userImageFile;

      await FirebaseFirestore.instance.collection('users').doc(res.uid).set({
        'username': _userName,
        'email': res.email,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _trySubmit(BuildContext context) async {
    final isValid = _formKey.currentState.validate();
    FocusScopeNode currentFocus = FocusScope.of(context);

    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if (isValid)
      _formKey.currentState.save();
    else
      return;

    _userEmail = _userEmail.trim();
    _userPassword = _userPassword.trim();
    if (widget.isSignUp) {
      var value = new ErrorMsg('');
      await signIn(_userEmail, _userPassword, value);
    } else {
      var value = new ErrorMsg('');
      await signUp(_userEmail, _userPassword, value);
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User user = authResult.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser;
      assert(user.uid == currentUser.uid);
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
        });
        Navigator.of(context).pushReplacementNamed(NotesScreen.routeName);
      }
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<void> signIn(String email, String password, ErrorMsg msg) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;

      if (user.emailVerified == false) {
        signOut();
        msg.error =
            'Please verify your email address by clicking on the link sent on your registered email id.😅';
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg.error)));
      } else {
        Navigator.of(context).pushReplacementNamed(NotesScreen.routeName);
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'email': user.email,
        });
      }
    } catch (e) {
      msg.error = e.message.toString() + '😅';
      if (msg != null) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg.error)));
      }
    }
  }

  Future<void> resetPassword(String email, ErrorMsg msg) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      msg.error = 'Check your email for resetting your password';
    } catch (e) {
      msg.error = e.message.toString() + '😅';
      if (msg != null) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg.error)));
      }
    }
  }

  Future<void> signUp(String email, String password, ErrorMsg msg) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      user.sendEmailVerification();
      msg.error =
          'Please verify your email address by clicking on the link sent on your registered email id and then try to sign in. 😅';
      signOut();
      Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
      // user.displayName = name;
    } catch (e) {
      msg.error = e.message.toString() + '😅';
      if (msg != null) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg.error)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: SizeConfig.heightMultiplier * 2),
        height: SizeConfig.heightMultiplier * 66,
        decoration: BoxDecoration(
          color: Color(0xff171719),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(SizeConfig.widthMultiplier * 6),
            topRight: Radius.circular(SizeConfig.widthMultiplier * 6),
          ),
        ),
        margin: EdgeInsets.only(top: SizeConfig.heightMultiplier * 2),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.heightMultiplier * 2),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Your Email Address',
                    style: TextStyle(
                        fontSize: SizeConfig.heightMultiplier * 1.3,
                        color: Colors.white70),
                  ),
                ),
                TextFormField(
                  controller: _email,
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  key: ValueKey('email'),
                  style: TextStyle(color: Colors.white70),
                  validator: (value) {
                    if (value.isEmpty ||
                        !value.contains('@') ||
                        !value.contains('.com')) return 'Enter a Valid Email!';
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'email@domain.com',
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.redAccent[400],
                    ),
                  ),
                  onSaved: (newValue) {
                    _userEmail = newValue;
                  },
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 2,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Password',
                    style: TextStyle(
                        fontSize: SizeConfig.heightMultiplier * 1.5,
                        color: Colors.white70),
                  ),
                ),
                TextFormField(
                  autocorrect: false,
                  key: ValueKey('password'),
                  controller: _pass,
                  style: TextStyle(color: Colors.white54),
                  validator: (value) {
                    if (value.isEmpty || value.length < 7)
                      return 'Password should be atleast 7';
                    if (!value.contains('@') &&
                        !value.contains('.') &&
                        !value.contains('-'))
                      return 'Add some special character';
                    return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'JognWick.dog',
                    hintStyle: TextStyle(color: Colors.white54),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.redAccent[400],
                    ),
                  ),
                  onSaved: (newValue) {
                    _userPassword = newValue;
                  },
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 2,
                ),
                if (!widget.isSignUp)
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Confirm Password',
                      style: TextStyle(
                          fontSize: SizeConfig.heightMultiplier * 1.5,
                          color: Colors.white70),
                    ),
                  ),
                if (!widget.isSignUp)
                  TextFormField(
                    controller: _confirmPass,
                    autocorrect: false,
                    key: ValueKey('confirmPassword'),
                    validator: (value) {
                      if (value != _pass.text) return 'Password doesnt match';
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white54),
                      hintText: 'JognWick.dog',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.redAccent[400],
                      ),
                    ),
                    onSaved: (newValue) {
                      _confirmPassword = newValue;
                    },
                  ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 4,
                ),
                InkWell(
                  onTap: () => _trySubmit(context),
                  child: Material(
                    borderRadius: BorderRadius.all(
                      Radius.circular(SizeConfig.heightMultiplier * 5),
                    ),
                    elevation: 3,
                    child: Container(
                      width: SizeConfig.widthMultiplier * 80,
                      height: SizeConfig.heightMultiplier * 6.5,
                      alignment: Alignment.center,
                      child: Text(
                        widget.isSignUp ? 'Sign In' : 'Sign Up',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.redAccent[400],
                        borderRadius: BorderRadius.all(
                          Radius.circular(SizeConfig.heightMultiplier * 5),
                        ),
                      ),
                    ),
                  ),
                ),
                if (widget.isSignUp)
                  InkWell(
                    onTap: () {
                      resetPassword(_email.text, new ErrorMsg(''));
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: SizeConfig.heightMultiplier * 2),
                      child: Text(
                        'Forgot Password ?',
                        style: TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                if (widget.isSignUp)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Don\'t have an account?',
                        style: TextStyle(color: Colors.white54),
                      ),
                      SizedBox(
                        width: SizeConfig.widthMultiplier,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, SignUpScreen.routeName);
                        },
                        child: Container(
                          child: Text(
                            'Create one',
                            style: TextStyle(color: Colors.redAccent[400]),
                          ),
                        ),
                      )
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
