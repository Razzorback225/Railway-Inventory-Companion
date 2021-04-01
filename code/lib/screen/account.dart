import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dialog/dialog.dart';
//import '../firebase/auth.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key? key, this.title})  : super(key: key);

  final String? title;

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  final oldPwdrCtrlr = TextEditingController();
  final newPwdCtrlr = TextEditingController();
  final newPwdRptCtrlr = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void dispose(){
    oldPwdrCtrlr.dispose();
    newPwdCtrlr.dispose();
    newPwdRptCtrlr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('My account'),
        backgroundColor: Colors.red,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Username", style: TextStyle(fontSize: 18),textAlign: TextAlign.left,),
                IconButton(icon: Icon(Icons.edit), color: Colors.black, onPressed: updateEmail),
              ],
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: user?.email,
              ),
              enabled: false,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text("Name", style: TextStyle(fontSize: 18),textAlign: TextAlign.left,),
                IconButton(icon: Icon(Icons.edit), color: Colors.black, onPressed: updateName),
              ],
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: user?.displayName,
              ),
              enabled: false,
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future updateName() async{
    EntryDialog nameDialog = new EntryDialog(context);
    String name = await nameDialog.showEntryDialog("Name update", "Please enter your new name", "Name", "", "Validate") as String;

    if(name != ""){
      user?.updateProfile(displayName: name);
    }
  }

  Future updateEmail() async{
    EntryDialog emailDialog = new EntryDialog(context);
    String email = await emailDialog.showEntryDialog("Email update", "Please enter your new E-Mail address", "E-mail", "", "Validate") as String;

    if(email.isNotEmpty && email.contains('@')){
      user?.verifyBeforeUpdateEmail(email);
    }
  }
}
