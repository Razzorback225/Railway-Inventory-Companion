import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/rail.dart';

class Firebase {
  Firebase();
  User user = FirebaseAuth.instance.currentUser;
  final databaseReference = FirebaseDatabase.instance.reference();

  Future<void> createRoot() async {
    await databaseReference.child(user.uid).set("Marklin");
  }

  Future<List<Rail>> readInventory(String gauge) async{
    List<Rail> items = [];
    List typeList = ["M-Track","C-Track","K-Track"];

    if(gauge == "HO"){
      for(String trackType in typeList) {
        await databaseReference.child(user.uid).child("Marklin").child(gauge).child(trackType).once().then((DataSnapshot snapshot) {
          if(snapshot.value != null) {
            Map<String, dynamic> buffer = new Map.from(snapshot.value);  
            
            for (String part in buffer.keys) {
                items.add(Rail(
                  part, 
                  gauge, 
                  trackType, 
                  buffer[part]["Quantity"].toString(), 
                  "Marklin", 
                  buffer[part]["Description"],
                  buffer[part]["Picture"]
                )
              );
            }
          }
        });
      }
      if(items.length > 0){
        return items;
      }
      else {
        return null;
      }
    }
    else{
      await databaseReference.child(user.uid).child("Marklin").child(gauge).once().then((DataSnapshot snapshot) {
        if(snapshot.value != null) {
          Map<String, dynamic> buffer = new Map.from(snapshot.value);
          
          for (String part in buffer.keys) {
              items.add(Rail(
                part, 
                gauge, 
                "N/A", 
                buffer[part]["Quantity"].toString(), 
                "Marklin", 
                buffer[part]["Description"],
                buffer[part]["Picture"]
              )
            );
          } 
        }
      });
      print("firebase.dart : $items");
      if(items.length > 0){
        return items;
      }
      else {
        return null;
      }
    }
  }

  void pushNR(String partNumber, String gauge, int quantity, String trackType){
    var path = databaseReference.child(user.uid).child("Marklin").child(gauge);

    if(gauge != "HO"){
      path.child(partNumber).child("Quantity").set(quantity);
    }
    else {
      path.child(trackType).child(partNumber).child("Quantity").set(quantity);
    }    
  }

  void deleteItem(String gauge, String partNumber){
    databaseReference.child(user.uid).child("Marklin").child(gauge).child(partNumber).remove();
  }
}