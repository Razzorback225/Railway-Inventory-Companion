import '../firebase.dart';
import 'package:flutter/material.dart';

class NewRailPage extends StatefulWidget {
  NewRailPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NewRailPageState createState() => _NewRailPageState();
}

class _NewRailPageState extends State<NewRailPage>{

  Firebase fb = new Firebase();

  final partNumberCtrlr = TextEditingController();
  final quantityCtrlr = TextEditingController();

  bool _isVisible = false;

  List _trackTypes = ["Please select a track type", "M-Track", "K-Track", "C-Track"];
  List<DropdownMenuItem<String>> _trTypeDropDownMenu;
  String _currentTrackType;

  List _gauges = ["Please select the gauge","1","HO","Z"];
  List<DropdownMenuItem<String>> _gaugeDropDownMenu;
  String _currentGauge;

  @override
  void initState(){
    _trTypeDropDownMenu = getDropDownMenuItems(_trackTypes);
    _currentTrackType = _trTypeDropDownMenu[0].value;

    _gaugeDropDownMenu = getDropDownMenuItems(_gauges);
    _currentGauge = _gaugeDropDownMenu[0].value;
    super.initState();
  }

  @override
  void dispose(){
    partNumberCtrlr.dispose();
    quantityCtrlr.dispose();
    super.dispose();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems(List itemList){
    List<DropdownMenuItem<String>> items = new List();
    for(String item in itemList){
      items.add(new DropdownMenuItem(
        value: item,
        child: new Text(item),
      ));
    }
    return items;
  }

  @override
  Widget build (BuildContext ctxt){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Add rail"),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.check), 
            onPressed: (){
              fb.pushNR(partNumberCtrlr.text, _currentGauge, int.parse(quantityCtrlr.text), _currentTrackType);
              Navigator.pop(ctxt);
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: partNumberCtrlr,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Part number',
              ),
            ),
            SizedBox(height : 16),
            DropdownButton(
              isExpanded: true,
              value: _currentGauge,
              items: _gaugeDropDownMenu,
              onChanged: gaugeDropDownMenu_change,
            ),
            SizedBox(height : 16),
            TextField(
              controller: quantityCtrlr,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Quantity'
              ),
            ),
            SizedBox(height : 16),
            Visibility(
              visible: _isVisible,
              child: DropdownButton(
                isExpanded: true,
                value: _currentTrackType,
                items: _trTypeDropDownMenu, 
                onChanged: trTypeDropDownMenu_change,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void gaugeDropDownMenu_change(String selectedGauge){
    setState(() {
      _currentGauge = selectedGauge;
      if(_currentGauge == "HO"){
        _isVisible = true;
      }
      else{
        _isVisible = false;
      } 
    });
  }

  void trTypeDropDownMenu_change(String selectedTrackType){
    setState(() {
      _currentTrackType = selectedTrackType;
    });
  }
}