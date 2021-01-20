import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home.dart';
import 'signup.dart';
import '../dialog/dialog.dart';
import 'dart:async';
import '../../firebase.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  final usernameCtrlr = TextEditingController();
  final passwordCtrlr = TextEditingController();
  
  User user = FirebaseAuth.instance.currentUser;

  bool rememberMe = false;

  @override
  void initState(){
    super.initState();
    autoLogin();
  }

  @override
  Widget build(BuildContext ctxt) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: usernameCtrlr,
                decoration: InputDecoration(
                  border : OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'john.doe@gmail.com'
                ),
              ),
              SizedBox(height : 32),
              TextField(
                obscureText: true, 
                controller: passwordCtrlr,
                decoration: InputDecoration(
                  border : OutlineInputBorder(),
                  labelText: 'Password',
                  hintText: '********'
                ),
              ),
              SizedBox(height : 16),
              FractionallySizedBox(
                widthFactor : 1.0,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.login),
                  onPressed : _loginBtn_pressed,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),
                    primary: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  ),
                  label: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white) 
                  ),
                ),
              ),
              SizedBox(height : 16),
              FractionallySizedBox(
                widthFactor : 1.0,
                child: ElevatedButton.icon(
                  icon: Icon(Icons.person_add),
                  onPressed : _signup_pressed,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(10),
                    primary: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  ),
                  label: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white) 
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  Future _loginBtn_pressed() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    MessageDialog errorDialog = new MessageDialog(context);
    Route route =  new MaterialPageRoute(builder: (context) => new HomePage());
    //User user = auth.currentUser;
    try {
      if(user == null){
        UserCredential creds = await auth.signInWithEmailAndPassword(email: usernameCtrlr.text, password: passwordCtrlr.text);

        if(creds != null){
          user = auth.currentUser;
          if (!user.emailVerified) {
            errorDialog.showMessageDialog("Email not yet verified", "Please verified your email before signing in");
          }
          else{
            if(user.displayName != null){
              goToHome(route);
            }
            else{
              EntryDialog nameDialog = new EntryDialog(context);
              String name = await nameDialog.showEntryDialog("Full name (optionnal)", "If you want you can provide your full name.\nThis will help us to know who you are", "Full name","John Doe", "Ok");
              if(name.isNotEmpty){
                user.updateProfile(
                  displayName: name
                );
              }
              /*
              Firebase fb = new Firebase();
              if(await fb.checkRootExist()){
                print("Root exists");
                goToHome();
              }
              else{
                print("Creating root");
                await fb.createRoot();
                goToHome();
              }*/
              goToHome(route);           
            }
          }
        }
      }
      else{
        goToHome(route);
      }
    }
    on FirebaseAuthException catch(e) {
      if(e.code == "user-not-found") {
        // TODO : Implement error message class
        await errorDialog.showMessageDialog("Authentification Error", "User not found");
      }
      else {
        print(e.code);
      }
    }
  }

  void _signup_pressed(){
    Route route =  new MaterialPageRoute(builder: (context) => new SignUpPage());
    Navigator.push(context,route).then((_){
      //user.reload();
    });
  }

  void autoLogin(){
    if(user != null){
      print(user);
      /*Route route =  new MaterialPageRoute(builder: (context) => new HomePage());
      Navigator.push(context,route);*/
    }
  }

  void goToHome(Route route){
    Navigator.push(context,route);
  }
}