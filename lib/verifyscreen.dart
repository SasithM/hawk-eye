import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hawk_eye/drawer_only.dart';
import 'package:responsive_container/responsive_container.dart';

class VerifyUser extends StatefulWidget {
  @override
  _VerifyUserState createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ResponsiveContainer(
                  widthPercent: 100.0,
                  heightPercent: 100.0,
                  child: Container(color: Color(4280361249)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
