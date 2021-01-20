import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'home.dart';

class ValidationPage extends StatefulWidget {
  ValidationPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ValidationPageState createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage>{
  final auth = FirebaseAuth.instance;
  User user;

  Timer timer;

  @override
  void initState(){
    user = auth.currentUser;
    user.sendEmailVerification();

    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        widthFactor: 0.9,
        child: Text(
            'An email has been sent to ${user.email} please verify'),
      ),
    );
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  @override
  void dispose(){
    timer.cancel();
    super.dispose();
  }
}