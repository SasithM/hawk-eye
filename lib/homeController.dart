import 'package:flutter/material.dart';
import 'package:hawk_eye/auth_service.dart';
import 'package:hawk_eye/dashboard.dart';
//import 'package:hawk_eye/landing.dart';
//import 'package:hawk_eye/login.dart';
//
//class HomeController extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    final AuthService auth = Provider.of(context).auth;
//    return StreamBuilder(
//      stream: auth.onAuthStateChanged,
//      builder: (context, AsyncSnapshot<String> snapshot){
//        if(snapshot.connectionState == ConnectionState.active){
//          final bool signedIn =  snapshot.hasData;
//          return signedIn ? Dashboard() : LandingPage();
//        }
//        return CircularProgressIndicator();
//      },
//    );
//  }
//}

//class Provider extends InheritedWidget {
//  final AuthService auth;
//  Provider({Key: key, Widget child, this.auth,}) : super{key: key, child: child};
//
//  @override
//  bool updateShouldNotify(InheritedWidget oldWidget) {
//    return true;
//  }
//
//  static Provider of(BuildContext context) => (context.dependOnInheritedWidgetOfExactType(aspect: Provider) as Provider);
//
//}