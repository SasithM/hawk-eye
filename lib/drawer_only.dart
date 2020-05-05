import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hawk_eye/dashboard.dart';
import 'package:hawk_eye/landing.dart';
import 'package:hawk_eye/login.dart';
import 'package:hawk_eye/main.dart';
import 'package:hawk_eye/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

String userName, email;

class DrawerOnly extends StatefulWidget {
  @override
  _DrawerOnlyState createState() => _DrawerOnlyState();
}

class _DrawerOnlyState extends State<DrawerOnly> {

  String userLetter;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  Future<void> userLogOut() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('loggedUser', null);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LandingPage()));
  }

  Future<void> getUserDetails() async {
    final Firestore dbreference = Firestore.instance;
    await dbreference.collection('user').document(loggedUser).get().then((data){
      setState(() {
        userName = data['name'].toString();
        email = data['email'];
        var letter = List.from(userName.split(''));
        userLetter = letter[0];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
          color: Colors.grey[300],
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text('$userName', textScaleFactor: 1.2),
                accountEmail: Text('$email', textScaleFactor: 1.0,),
                currentAccountPicture: CircleAvatar(
                  backgroundColor:
                  Theme.of(context).platform == TargetPlatform.iOS ? Colors.grey[900] : Colors.white,
                  child: Text('$userLetter', style: TextStyle(fontSize: 40.0),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text("HOME"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context)
                      .push(MaterialPageRoute<Null>(builder: (BuildContext context){
                    return Dashboard();
                  }));
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("PROFILE"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context)
                      .push(MaterialPageRoute<Null>(builder: (BuildContext context){
                    return ProfilePage();
                  }));
                },
              ),
              ListTile(
                leading: Icon(Icons.message),
                title: Text("MESSAGES"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context)
                      .push(MaterialPageRoute<Null>(builder: (BuildContext context){
                    return Dashboard();
                  }));
                },
              ),
              ListTile(
                leading: Icon(Icons.help),
                title: Text("HELP & SUPPORT"),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context)
                      .push(MaterialPageRoute<Null>(builder: (BuildContext context){
                    return Dashboard();
                  }));
                },
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text("SIGN OUT"),
                onTap: () {
                  Navigator.pop(context);
                  userLogOut();
                },
              ),
            ],
          ),
        )
    );
  }
}
