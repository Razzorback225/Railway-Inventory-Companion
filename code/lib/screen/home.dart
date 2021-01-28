import 'package:manul/screen/dialog/dialog.dart';
import '../database.dart';
import 'newRail.dart';
import 'login/login.dart';
import 'account.dart';
import '../models/rail.dart';
import 'railInfo.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../icons/ric_icons_icons.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.title}) : super(key: key);
  
  final String? title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  Database fb = new Database();

  final List<String> gaugeList = ["1", "HO", "Z"];
  late String _currentGauge;
  late int _currentIndex;
  late int _tryCount;

  bool displayType = false;

  List<Rail> _railList = [];

  @override
  void initState(){
    _tryCount = 1;
    _currentIndex = 0;
    _currentGauge = gaugeList[_currentIndex];
    super.initState();    
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
      ),
      body: FutureBuilder<List<Rail>>( // RefreshIndicator
        future: refreshInventory(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _tryCount = 1;
            return ListView.builder(
              itemCount : snapshot.data?.length ?? 0,
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(snapshot.data![index].partNumber),
                      subtitle: Text("Quantity: ${snapshot.data![index].partQuantity}\nBrand: ${snapshot.data![index].partBrand}"),
                      isThreeLine: true,
                      onTap: (){
                        Route route = MaterialPageRoute(builder: (context) => new RailInfo(rail: _railList[index], displayType: displayType));
                        Navigator.push(context, route);
                      },
                      onLongPress: () => deleteItem(index),
                    ),
                  );
              },
            );
          }
          else {
            if(_tryCount >= 2){
              return Center(child: Text("No $_currentGauge tracks in the database"),);
            }
            else{
              _tryCount++;
              return Center(child: CircularProgressIndicator(backgroundColor: Colors.red,),);
            }
          }
        }
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _gaugeChanged,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.white,
        backgroundColor: Colors.red,
        items: [
          BottomNavigationBarItem(
            icon: Icon(RicIcons.oneGauge),
            label: "1"
          ),
          BottomNavigationBarItem(
            icon: Icon(RicIcons.hoGauge),
            label: "HO"
          ),
          BottomNavigationBarItem(
            icon: Icon(RicIcons.zGauge),
            label: "Z"
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          addNewRail();
        },
        tooltip: 'Add Rail',
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }

  void deleteItem(int index) async{
    ChooseDialog delItemDialog = new ChooseDialog(context);
    int result = await delItemDialog.showChooseDialog("Remove item", "Are you sure you want to remove this item?", "Yes", "No", false) as int;

    if(result == 1){
      fb.deleteItem(_currentGauge, _railList[index].partNumber);
    }
  }

  void addNewRail(){
    Route route =  new MaterialPageRoute(builder: (context) => new NewRailPage());
    Navigator.push(context,route).then((_) async{ 
      await refreshInventory();
      });
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

  void _gaugeChanged(int selectedGauge) async{
    _currentGauge = gaugeList[selectedGauge];
    if(_currentGauge != "HO"){
      displayType = false;
    }  
    else{
      displayType = true;
    }
    await refreshInventory().then((_) => setState(() {
      _currentIndex = selectedGauge;
      _tryCount = 1;
    }));    
  }

  Future<List<Rail>> refreshInventory() async {
    _railList = await fb.readInventory(_currentGauge);
    return _railList;
  }
}

