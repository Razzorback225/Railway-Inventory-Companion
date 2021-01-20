import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/rail.dart';

class Firebase {
  Firebase();
  User user = FirebaseAuth.instance.currentUser;
  final databaseReference = FirebaseDatabase.instance.reference();

  Future<bool> checkRootExist() async {
    //TODO : Add root checking verification
    await databaseReference.child(user.uid).once().then((DataSnapshot snapshot){
      if(snapshot.value != null){
        return true;
      }
      else{
        return false;
      }
    });
  }

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
            Map<String, int> buffer = new Map.from(snapshot.value);  
            
            for (String part in buffer.keys) {
                items.add(Rail(part, gauge, trackType, buffer[part].toString()));
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
          Map<String, int> buffer = new Map.from(snapshot.value);
          
          for (String part in buffer.keys) {
              items.add(Rail(part, gauge, "N/A", buffer[part].toString()));
          } 
          return items; 
        }
        else {
          return null;
        }
      });
    }
  }

  void pushNR(String partNumber, String gauge, int quantity, String trackType){
    var path = databaseReference.child(user.uid).child("Marklin").child(gauge);

    if(gauge != "HO"){
      path.child(partNumber).set(quantity);
    }
    else {
      path.child(trackType).child(partNumber).set(quantity);
    }    
  }
}