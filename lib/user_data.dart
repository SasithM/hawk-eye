import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hawk_eye/login.dart';
import 'package:hawk_eye/main.dart';
import 'package:hawk_eye/report_crimes.dart';

var crimeData = new List(5);

Future<String> submitForUser() async{
  crimeData.map((i){
    print('$i'); //this print iteration was used for debug purpose
  }).toList();
  Firestore dbreference = Firestore.instance;
  void createRecord() async{
    await dbreference.collection('user').document(loggedUser).collection('crimes').document(uploadTime).setData({
      'images': crimeData[0],
      'category': crimeData[1].toString(),
      'location': crimeData[2].toString(),
      'details': crimeData[3].toString(),
      'time': crimeData[4].toString(),
      'msgVerify': false,
    });
  }
  createRecord();
  return 'successful';
}