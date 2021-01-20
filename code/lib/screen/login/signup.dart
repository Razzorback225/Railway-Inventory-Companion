import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../dialog/dialog.dart';
import 'login.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage>{
  
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffold = GlobalKey<ScaffoldState>();

  final usernameCtrlr = TextEditingController();
  final passwordCtrlr = TextEditingController();
  final passwordRptCtrlr = TextEditingController();

  @override
  Widget build(BuildContext ctxt) {
    return Form(
      key: _formKey,
      child: Scaffold(
        key: _scaffold,
        body: Container(
          padding: EdgeInsets.all(16),
          child: ListView(
            children: [
              SizedBox(height:16),
              TextFormField(
                controller: usernameCtrlr,
                validator: (value) {
                  if(value.isNotEmpty){
                    if(!value.contains('@')){
                      return 'Please enter a valid email';
                    }
                  }
                  else{
                    return 'Please provide an email to continue';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                  hintText: 'john.doe@gmail.com'
                ),
              ),
              SizedBox(height:16),
              TextFormField(
                controller: passwordCtrlr,
                validator: (value){
                  if(value.isNotEmpty){
                    if(value.length < 8){
                      return 'Your password is to short';
                    }
                  }
                  else{
                    return 'Please provide a password to continue';
                  }
                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password (Min. 8 characters!)',
                  hintText: '********'
                ),
              ),
              SizedBox(height:16),
              TextFormField(
                controller: passwordRptCtrlr,
                validator: (value){
                  if(value.isNotEmpty){
                    if(value != passwordCtrlr.text){
                      return 'Password doesn\'t match the one above';
                    }
                  }
                  else{
                    return 'Please repeat the password entered above';
                  }
                  return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Repeat the password',
                  hintText: '********'
                ),
              ),
              SizedBox(height : 16),
              ElevatedButton.icon(
                icon: Icon(Icons.person_add),
                onPressed: validateSignUp,
                style: ElevatedButton.styleFrom(
                    padding : EdgeInsets.all(10),
                    primary: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                ),
                label: Text(
                  "Validate",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future validateSignUp() async{
    if(_formKey.currentState.validate()){
      FirebaseAuth auth = FirebaseAuth.instance;
      MessageDialog errorDialog = new MessageDialog(context);
      try {
        await auth.createUserWithEmailAndPassword(
          email: usernameCtrlr.text, 
          password: passwordCtrlr.text
          ).then((_){
            User user = auth.currentUser;
            user.sendEmailVerification();
            MessageDialog popup = new MessageDialog(context);
            popup.showMessageDialog('Check your mails', 'An email has been sent to ${user.email}.\nPlease verify this email to connect to the app');
            Route vRoute = MaterialPageRoute(builder: (context) => LoginPage());
            Navigator.of(context).pushReplacement(vRoute);          
          });      
      }
      on FirebaseAuthException catch(e) {
        await errorDialog.showMessageDialog("Authentification error", e.message);
      }
    }
  }
}