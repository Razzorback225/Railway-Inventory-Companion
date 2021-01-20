import 'package:flutter/material.dart';
import '../models/rail.dart';

class RailInfo extends StatelessWidget {
  // Declare a field that holds the Todo.
  final Rail rail;
  final bool displayType;

  // In the constructor, require a Todo.
  RailInfo({Key key, @required this.rail, @required this.displayType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text(rail.partNumber),
        backgroundColor: Colors.red,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(       
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              child: Image(
                image: NetworkImage("https://rimatour.com/wp-content/uploads/2017/09/No-image-found.jpg"),
              ),         
            ),
            Text("Gauge", style: TextStyle(fontSize: 18),),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: rail.partQuantity),
            ),
            SizedBox(height: 16,),
            Text("Quantity", style: TextStyle(fontSize: 18),),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: rail.partQuantity
              ),
            ),
            SizedBox(height: 16,),
            Visibility(
              visible: displayType,
              child: Column(
                children: [
                  Text("Rail type", style: TextStyle(fontSize: 18),),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: rail.partType
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}