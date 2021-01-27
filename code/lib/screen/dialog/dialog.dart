import 'package:flutter/material.dart';

class MessageDialog {
  BuildContext context;

  MessageDialog(this.context);

  Future<void> showMessageDialog(String title, String message) async{
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


}

class EntryDialog {
  BuildContext ctxt;

  EntryDialog(this.ctxt);

  Future<String> showEntryDialog(String title, String message, String entryLabel, String entryHint, String buttonText) async{
    
    final textFieldCtrlr = TextEditingController();
    
    return showDialog<String>(
      context: ctxt,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
                SizedBox(height: 16,),
                TextField(
                  controller: textFieldCtrlr,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: entryLabel,
                    hintText: entryHint,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(buttonText),
              onPressed: () {
                Navigator.of(context).pop(textFieldCtrlr.text);
              },
            ),
          ],
        );
      },
    );
  }
}

class ChooseDialog {
  BuildContext ctxt;

  ChooseDialog(this.ctxt);

  Future<int> showChooseDialog(String title, String message, String choice1, String choice2, bool isCancellable) async{

    return showDialog<int>(
      context: ctxt,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
                SizedBox(height: 16,),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(1),
                  child : Text(choice1),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(2),
                  child : Text(choice2),
                ),
                Visibility(
                  visible: isCancellable,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(0),
                    child : Text("Cancel"),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

