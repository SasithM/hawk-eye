import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hawk_eye/dashboard.dart';
import 'package:hawk_eye/login.dart';
import 'package:hawk_eye/main.dart';
import 'package:hawk_eye/signup.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {

  @override
  _LandingPageState createState() => new _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.fill
          )
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: <Widget>[
              Center(
                child: ResponsiveContainer(
                  heightPercent: 50.0,
                  widthPercent: 85.0,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
              Center(
                child: ResponsiveContainer(
                  heightPercent: 33.0,
                  widthPercent: 67.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'HAWK EYE',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.w800,
                          color: Colors.yellow,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      ResponsiveContainer(
                        heightPercent: 7.0,
                        widthPercent: 67.0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: RaisedButton(
                            elevation: 5.0,
                            onPressed: () async {
                              final prefs = await SharedPreferences.getInstance();
                              var user = prefs.getString('loggedUser') ?? null;
                              if(user == '' || user == null){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => new LoginScreen()));
                              }else if(user != '' && user != null){
                                loggedUser = user;
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => new Dashboard()));
                              }

                            },
                            padding: EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Colors.amber)
                            ),
                            color: Colors.grey[800].withOpacity(0.9),
                            child: Text(
                              'LOGIN',
                              style: TextStyle(
                                color:Colors.amber,
                                letterSpacing: 1.5,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Proxima Nova',
                              ),
                            ),
                          ),
                        ),
                      ),

                      ResponsiveContainer(
                        heightPercent: 7.0,
                        widthPercent: 67.0,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: RaisedButton(
                            elevation: 5.0,
                            onPressed: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute<Null>(builder: (BuildContext context){
                                return SignupScreenOne();
                              }));
                            },
                            padding: EdgeInsets.all(15.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: BorderSide(color: Colors.amber)
                            ),
                            color: Colors.grey[900].withOpacity(0.9),
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                color:Colors.amber,
                                letterSpacing: 1.5,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Proxima Nova',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
