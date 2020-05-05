import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hawk_eye/drawer_only.dart';
import 'package:hawk_eye/get_permission.dart';
import 'package:hawk_eye/report_crimes.dart';
import 'package:responsive_container/responsive_container.dart';
import 'grid_dashboard.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

const PrimaryColor = const Color(0xFF151026);

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
      ),
      drawer: DrawerOnly(),
      floatingActionButton: FloatingActionButton(
        heroTag: "btn3",
        onPressed: () {
          checkPermissionForContribute().then((onValue){
            if(onValue == true){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReportCrimes()));
            }
          });
          // Add your onPressed code here!
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ResponsiveContainer(
                  heightPercent: 6.0,
                  widthPercent: 100.0,
                  child: Container(
                    //color: Colors.blue,
                    padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: Text(
                      'Hawk Eye',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 25,
                        color: Colors.white
                      ),
                    ),
                  ),
                ),

                ResponsiveContainer(
                  heightPercent: 4.0,
                  widthPercent: 100.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        //color: Colors.red,
                        padding: EdgeInsets.fromLTRB(10, 0, 2, 0),
                        child: Text(
                          'Home',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(2, 0, 5, 0),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.teal,
                        ),
                      )
                    ],
                  ),
                ),

                Expanded(
                  child: ResponsiveContainer(
                    heightPercent: 76.0,
                    widthPercent: 100.0,
                    child: Container(
                        child: GridDashboard()
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
