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
  String _currentGauge;
  int _currentIndex;
  int _tryCount;

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
            return ListView.builder(
              itemCount : snapshot.data?.length ?? 0,
              itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(snapshot.data[index].partNumber),
                      subtitle: Text("Quantity: ${snapshot.data[index].partQuantity}\nBrand: ${snapshot.data[index].partBrand}"),
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
            if(_tryCount >= 3){
              return Center(child: Text("No $_currentGauge tracks in the database"),);
            }
            else{
              _tryCount++;
              print("Try : $_tryCount");
              return Column(children: [LinearProgressIndicator(backgroundColor: Colors.red,)],);
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
            icon: Icon(Icons.train),
            label: "1"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.train),
            label: "HO"
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.train),
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
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

