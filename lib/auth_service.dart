import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> createUserWithEmailAndPassword(String email, String password) async {
    final currentUser = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    //update username
    return currentUser.user.email;
  }

  Future<String> signInWithEmailAndPassword(String email, String password) async {
    return (await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user.email;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  signOut(){
    return _firebaseAuth.signOut();
  }

  void savingUser(String email) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('loggedUser', email);
    //print('saving user executed'); //for debug
  }

  void deletingUser() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('loggedUser', null);
    //print('deleting user executed'); //for debug
  }
}