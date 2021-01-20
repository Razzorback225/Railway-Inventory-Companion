import '../firebase.dart';
import 'newRail.dart';
import 'login/login.dart';
import 'account.dart';
import '../models/rail.dart';
import 'railInfo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  Firebase fb = new Firebase();

  final List<String> gaugeList = ["1", "HO", "Z"];
  List<DropdownMenuItem<String>> _gaugeMenuItems;
  String _currentGauge;

  bool displayType = false;

  List<Rail> _railList = [];

  @override
  void initState(){
    _gaugeMenuItems = getDropDownMenuItems(gaugeList);
    _currentGauge = _gaugeMenuItems[0].value;
    super.initState();    
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
  Widget build(BuildContext context) {
    User user = FirebaseAuth.instance.currentUser;
    String name;
    if(user.displayName != null){
      name = user.displayName;
    }
    else{
      name = "";
    }
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children : [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.red
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children : [
                        Container(
                          width: 100, height: 100, 
                          alignment: Alignment.center,
                          // padding: EdgeInsets.all(5.0),
                          child: FaIcon(FontAwesomeIcons.userAlt, size: 60, color: Colors.white,),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                            color: Colors.red,
                          )
                        ),
                        SizedBox(height: 16,),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        )]
                    ),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.userAlt, color: Colors.black),
                    title: Text("My account", style: TextStyle(fontSize: 20),),
                    onTap: account,
                  ),
                ],
              ),
            ), // End expanded
            ListTile(
              title: Center(child: Text("Log Out", style: TextStyle(fontSize: 20, decoration: TextDecoration.underline),)),
              onTap : logOut,
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Rail Inventory Companion'),
        backgroundColor: Colors.red,
        actions: [
          DropdownButton(
            value : _currentGauge,
            items: _gaugeMenuItems,
            onChanged: _gaugeChanged,
            dropdownColor: Colors.red,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
      body: FutureBuilder<List<Rail>>( // RefreshIndicator
        future: refreshInventory(),
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount : snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(snapshot.data[index].partNumber),
                      subtitle: Text("Quantity: ${snapshot.data[index].partQuantity}\nType: ${snapshot.data[index].partType}"),
                      isThreeLine: true,
                      onTap: (){
                        Route route = MaterialPageRoute(builder: (context) => new RailInfo(rail: _railList[index], displayType: displayType));
                        Navigator.push(context, route);
                      },
                    ),
                  );
              },
            );
          }
          else {
            return Center(child: Text("No track of this gauge in the database"),);
            //return Center(child: CircularProgressIndicator(backgroundColor: Colors.red,));
          }
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewRail,
        tooltip: 'Add Rail',
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void addNewRail(){
    Route route =  new MaterialPageRoute(builder: (context) => new NewRailPage());
    Navigator.push(context,route).then((_) => refreshInventory());
  }

  void logOut(){
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut().then((res) {
    Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false);
    });
  }

  void account(){
    Route route =  new MaterialPageRoute(builder: (context) => new AccountPage());
    Navigator.push(context, route);
  }

  void _gaugeChanged(String selectedGauge) {
    _currentGauge = selectedGauge;
    if(_currentGauge != "HO"){
      displayType = false;
    }  
    else{
      displayType = true;
    }
    refreshInventory().then((_) => setState(() {}));    
  }

  Future<List<Rail>> refreshInventory() async {
    _railList = await fb.readInventory(_currentGauge);
    return _railList;
  }
}

