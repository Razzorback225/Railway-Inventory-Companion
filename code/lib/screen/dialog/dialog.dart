import 'package:flutter/material.dart';

class MessageDialog {
  BuildContext context;

  MessageDialog(this.context);

  Map<String, String> error = new Map();

  Future<void> showMessageDialog(String title, String message) async {
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

  String _entryResult;

  String get dialogResult {
    return _entryResult;
  }

  EntryDialog(this.ctxt);

  Future<String> showEntryDialog(String title, String message, String entryLabel, String entryHint, String buttonText){
    
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
                this._entryResult = textFieldCtrlr.text;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

