import '../firebase.dart';
import 'package:flutter/material.dart';
import 'dialog/dialog.dart';

class NewRailPage extends StatefulWidget {
  NewRailPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _NewRailPageState createState() => _NewRailPageState();
}

class _NewRailPageState extends State<NewRailPage>{

  Firebase fb = new Firebase();

  final _formKey = GlobalKey<FormState>();

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
    return Form(
      key : _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add rail"),
          backgroundColor: Colors.red,
          actions: [
            IconButton(
              icon: Icon(Icons.check), 
              onPressed: validateNewRail,
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: partNumberCtrlr,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Part number',
                ),
                validator: (value){
                  if(value.isEmpty){
                    return 'Please enter a valid part number';
                  }
                  return null;
                },
              ),
              SizedBox(height : 16),
              DropdownButton(
                isExpanded: true,
                value: _currentGauge,
                items: _gaugeDropDownMenu,
                onChanged: gaugeDropDownMenu_change,
              ),
              SizedBox(height : 16),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: quantityCtrlr,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Quantity'
                ),
                validator: (value){
                  if(value.isEmpty){
                    return 'Please enter a quantity (min 0)';
                  }
                  return null;
                },
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
      )
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

  Future validateNewRail() async{
    MessageDialog errorD = new MessageDialog(context);
    if(_formKey.currentState.validate()){
      switch(_currentGauge){
        case "1" :
          createRail();
          break;
        case "HO" :
          if(_currentTrackType != "Please select a track type"){
            createRail();  
          }
          else{
            errorD.showMessageDialog("Error", "Please select a track type to add a new rail.");
          }
          break;
        case "Z":
          createRail();
          break;
        default:
          errorD.showMessageDialog("Error", "Please select a gauge to add a new rail.");
          break;
      }      
    }
  }

  void createRail(){
    fb.pushNR(partNumberCtrlr.text, _currentGauge, int.parse(quantityCtrlr.text), _currentTrackType);
    Navigator.pop(context);
  }
}