import 'package:flutter/material.dart';
import '../models/rail.dart';

class RailInfo extends StatefulWidget {

  Rail? rail;
  bool? displayType;

  RailInfo({Key? key, @required this.rail, @required this.displayType}) : super(key: key);

  @override
  _RailInfoState createState() => _RailInfoState();
}

class _RailInfoState extends State<RailInfo> {
  
  late Rail rail;

  late bool displayType; 
  
  @override
  void initState(){
    rail = widget.rail as Rail;
    displayType = widget.displayType as bool;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.rail!.partNumber, style: TextStyle(fontSize: 20),),
            Text(rail.partDesc, style: TextStyle(fontSize: 14),),
          ],
        ),
        backgroundColor: Colors.red,
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              child: Image(
                image: NetworkImage("https://rimatour.com/wp-content/uploads/2017/09/No-image-found.jpg"),
              ),         
            ),
            ListTile(
              title: Text("Brand", style: TextStyle(fontSize: 18),),
              subtitle: TextField(
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: rail.partBrand),
              ),
            ),
            ListTile(
              title: Text("Gauge", style: TextStyle(fontSize: 18),),
              subtitle: TextField(
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: rail.partGauge),
              ),
            ),
            ListTile(
              title: Text("Quantity", style: TextStyle(fontSize: 18),),
              subtitle: TextField(
                enabled: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: rail.partQuantity),
              ),
            ),
            Visibility(
              visible: displayType,
              child: ListTile(
                title: Text("Rail type", style: TextStyle(fontSize: 18),),
                subtitle: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: rail.partType),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}