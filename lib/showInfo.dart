import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hawk_eye/login.dart';
import 'package:hawk_eye/main.dart';
import 'package:hawk_eye/selectedCrimeDetails.dart';
import 'package:neumorphic/neumorphic.dart';
import 'package:responsive_container/responsive_container.dart';

String selectedCrimeCategory;
String selectedCrimeId;

class ShowInfo extends StatefulWidget {
  @override
  _ShowInfoState createState() => _ShowInfoState();
}

class _ShowInfoState extends State<ShowInfo> {

  getCrimeReports(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents.map((doc) {
      var dateTime = doc['time'].toString();
      var date = List.from(dateTime.split(new RegExp(r"[.: ]")));
      return new ResponsiveContainer(
          padding: EdgeInsets.fromLTRB(3, 8, 3, 8),
          heightPercent: 15.0,
          widthPercent: 100.0,
          child: NeuCard(
            curveType: CurveType.concave,
            bevel: 15,
            decoration: NeumorphicDecoration(color: Colors.grey[200],
              borderRadius: BorderRadius.circular(18),),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: FlatButton(
                onPressed: () {
                  selectedCrimeId = doc.documentID;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SelectedCrimeDetails()),);
                },
                padding: EdgeInsets.all(0.0),
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(16, 16, 0, 0),
                              child: Stack(
                                children: <Widget>[
                                  Center(
                                    child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        doc['location'],
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20.0,
                                            color: Colors.black
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.fromLTRB(16, 0, 0, 23),
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        '${date[0]} at ${date[1]}:${date[2]}',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                            color: Colors.black
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("user")
          .document(loggedUser)
          .collection("crimes")
          .orderBy("time", descending: true)
          .where('category', isEqualTo: selectedCrimeCategory)
          .where('msgVerify', isEqualTo: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            body: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: ResponsiveContainer(
                    heightPercent: 3.0,
                    widthPercent: 100,
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),

                Expanded(
                  flex: 2,
                  child: ResponsiveContainer(
                      heightPercent: 6,
                      widthPercent: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            color: Colors.transparent,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back),
                              color: Colors.blue[900],
                              splashColor: Colors.blueAccent,
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              alignment: Alignment.center,
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                            ),
                          ),

                          Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                              color: Colors.transparent,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                alignment: Alignment.centerLeft,
                                child: Text(selectedCrimeCategory,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 25,
                                  ), //style
                                ),
                              )
                          ),
                        ],
                      )
                  ),
                ),

                Expanded(
                  flex: 30,
                  child: ResponsiveContainer(
                    heightPercent: 80.0,
                    widthPercent: 87.0,
                    padding: EdgeInsets.all(0),
                    child: Scrollbar(
                      child: new ListView(
                          padding: EdgeInsets.all(0),
                          children: getCrimeReports(snapshot)
                      ),
                    ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: ResponsiveContainer(
                    heightPercent: 3.0,
                    widthPercent: 100,
                    child: Container(
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        else{
          return new Scaffold(
            body: Stack(
              children: <Widget>[
                Center(
                  child: Text(
                      "Waiting!"
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }
}
