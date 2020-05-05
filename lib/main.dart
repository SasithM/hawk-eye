import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hawk_eye/landing.dart';

double userDevicePixelRatio;
String loggedUser;

void main(){
  runApp(
    MaterialApp(
      home: SplashScreen(),
    )
  );
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(
        Duration(seconds: 3), (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LandingPage(),));
        }
    );
  }
  @override
  Widget build(BuildContext context) {

    userDevicePixelRatio = MediaQuery.of(context).devicePixelRatio;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Text(
              'HAWK EYE',
              style: TextStyle(
                fontSize: 50.0, fontWeight: FontWeight.bold, color: Colors.amber
              ),
            ),
          )
          ],
        ),
      );
  }
}
