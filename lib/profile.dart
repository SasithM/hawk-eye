import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hawk_eye/drawer_only.dart';
import 'package:hawk_eye/login.dart';
import 'package:hawk_eye/main.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:responsive_container/responsive_container.dart';
import 'dart:math';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

var userProfileData;
var name;

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('user').document(loggedUser).snapshots(),
      builder: (context, snapshot){
        if(snapshot.hasData){

          userProfileData = snapshot.data;

          name = userProfileData['name'].toString();
          var userLetter = List.from(name.split(''));

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Color(4280361249),
            ),
            drawer: DrawerOnly(),
            body: Stack(
              children: <Widget>[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: ResponsiveContainer(
                            heightPercent: 12.0,
                            widthPercent: 100.0,
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Stack(
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                  ],
                                ),
                                Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      ResponsiveContainer(
                                        widthPercent: 60,
                                        heightPercent: 10,
                                        child: Container(
                                          color: Colors.transparent,
                                          padding: EdgeInsets.only(top: 15),
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                userProfileData['name'],
                                                style: TextStyle(
                                                    fontSize:(userDevicePixelRatio * 10) / 3 + 20.0,
                                                    fontWeight: FontWeight.w500
                                                ),
                                              ),
                                              Text(
                                                userProfileData['email'],
                                                style: TextStyle(
                                                  fontSize:(userDevicePixelRatio * 10) / 3 + 5.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Center(
                                  child: CircleAvatar(
                                    radius: 65.0,
                                    backgroundColor: Colors.grey[300],
                                    child: Text(
                                      userLetter[0],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: (userDevicePixelRatio * 10) / 3 + 60.0,
                                          color: Colors.grey[800]
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                        ),
                      ),

                      Expanded(
                        flex: 7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            ResponsiveContainer(
                              widthPercent: 90.0,
                              heightPercent: 20.0,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    height: 85.0,
                                    width: 340.0,
                                    padding: EdgeInsets.all(0.0),
                                    child: NeuCard(
                                      curveType: CurveType.flat,
                                      bevel: 15,
                                      decoration: NeumorphicDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Container(
                                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'ID',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: (userDevicePixelRatio * 10) / 3 + 5.0,
                                                        color: Colors.grey[600]
                                                    ),
                                                  ),
                                                  Text(
                                                    '${userProfileData['nic']} V',
                                                    style: TextStyle(fontWeight: FontWeight.w600,
                                                        fontSize: (userDevicePixelRatio * 10) / 3 + 6.0,
                                                        color: Colors.blueAccent,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  )
                                                ],
                                              ),
                                            ),

                                            Expanded(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'Address',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: (userDevicePixelRatio * 10) / 3 + 5.0,
                                                        color: Colors.grey[600]
                                                    ),
                                                  ),
                                                  Text(
                                                    userProfileData['address'].toString(),
                                                    style: TextStyle(fontWeight: FontWeight.w600,
                                                        fontSize: (userDevicePixelRatio * 10) / 3 + 6.0,
                                                        color: Colors.blueAccent
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }else{
          return Scaffold(
            body: Stack(
              children: <Widget>[
                Center(
                  child: Text('Loading...!'),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
