import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'models/rail.dart';

class Database {

  Database();
  User? user = FirebaseAuth.instance.currentUser;
  final databaseReference = FirebaseDatabase.instance.reference();

  int hoCounter = 0;
  int otherCounter = 0;

  Future<void> createRoot() async {
    await databaseReference.child(user?.uid).set("Marklin");
  }

  Future<dynamic> readInventory(String gauge) async{
    List<Rail> items = [];
    List typeList = ["M-Track","C-Track","K-Track"];

    if(gauge == "HO"){
      for(String trackType in typeList) {
        await databaseReference.child(user?.uid).child("Marklin").child(gauge).child(trackType).once().then((DataSnapshot snapshot) {
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
      hoCounter++;
      if(items.length > 0){
        print("firebase.dart : $gauge counter : $hoCounter");
        return items;
      }
      else{
        return null;
      }
    }
    else{
      await databaseReference.child(user?.uid).child("Marklin").child(gauge).once().then((DataSnapshot snapshot) {
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
      otherCounter++;
      if(items.length > 0){
        print("firebase.dart : $gauge counter : $otherCounter");
        return items;
      }
      else{
        return null;
      }
    }
  }

  void pushNR(String partNumber, String gauge, int quantity, String trackType)async{
    var path = databaseReference.child(user?.uid).child("Marklin").child(gauge);

    if(gauge != "HO"){
      await path.child(partNumber).child("Quantity").set(quantity);
    }
    else {
      await path.child(trackType).child(partNumber).child("Quantity").set(quantity);
    }    
  }

  void deleteItem(String gauge, String partNumber) async{
    await databaseReference.child(user?.uid).child("Marklin").child(gauge).child(partNumber).remove();
  }

  void updateItem(Rail rail)async{
    Map<String, dynamic> data = new Map();
    data["Quantity"] = rail.partQuantity;
    data["Picture"] = rail.partImageUrl;
    data["Description"] = rail.partDesc;
    await databaseReference.child(user?.uid).child(rail.partBrand).child(rail.partGauge).child(rail.partNumber).update(data);
  }
}