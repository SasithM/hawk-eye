import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hawk_eye/auth_service.dart';
import 'package:hawk_eye/constants.dart';
import 'package:hawk_eye/dashboard.dart';
import 'package:hawk_eye/get_permission.dart';
import 'package:hawk_eye/main.dart';
import 'package:hawk_eye/signup.dart';
import 'package:responsive_container/responsive_container.dart';

String accStatus;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _email = new TextEditingController();
  final TextEditingController _pswd = new TextEditingController();

  final formKey = new GlobalKey<FormState>();

  bool _rememberMe = false;

  bool _access = false;

  void haveAccess(String email) async{
    Firestore dbreference = Firestore.instance;
    await dbreference.collection('user').document(email).get().then((data){
      setState(() {
        _access = data['accVerify'];
      });
    });
  }

  Widget _buildEmailTF(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            'Email',
            style: kLabelStyle
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Proxima Nova'
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
            validator: (value){
              if(value.isEmpty){
                return'email is missing';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            'Password',
            style: kLabelStyle
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: _pswd,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Proxima Nova',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
            validator: (value){
              String pswdPattern = r'[a-zA-Z0-9@._]{6,25}$';
              RegExp regExpPswd = new RegExp(pswdPattern);
              if(value.isEmpty){
                return 'password is empty';
              }else if(!regExpPswd.hasMatch(value)){
                return '6 to 25 characters with @ . _';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.amber,
              activeColor: Colors.redAccent,
              onChanged: (value){
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return ResponsiveContainer(
      //padding: EdgeInsets.symmetric(vertical: 25.0),
      widthPercent: 30.0,
      heightPercent: 5.0,
      child: RaisedButton(
        onPressed: () async {
          if (formKey.currentState.validate()) {
            try{
              final form = formKey.currentState;
              form.save();
              final auth = AuthService();
              haveAccess(_email.text);
              String uid = await auth.signInWithEmailAndPassword(_email.text, _pswd.text);
              print('logged ======= $uid');
              if (uid.length > 0 && uid != null && _access == true) {
                auth.savingUser(uid);
                loggedUser = uid;
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));
              }else if(uid.length > 0 && uid != null && _access == false) {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Account Not Verified', textAlign: TextAlign.center,),
                      content: Text('Please be patient', textAlign: TextAlign.center,),
                      actions: <Widget>[
                        FlatButton(
                            child: Text('close'),
                            onPressed: (){
                              Navigator.pop(context, false);
                            }
                        ),
                      ],
                    )
                );
              }
            } catch (e) {
              setState(() {
                _email.clear();
                _pswd.clear();
              });
              print('Error: $e');
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Login Failed', textAlign: TextAlign.center,),
                    content: Text('Invalid E-mail or Password, please try again', textAlign: TextAlign.center,),
                    actions: <Widget>[
                      FlatButton(
                          child: Text('close'),
                          onPressed: (){
                            Navigator.pop(context, false);
                          }
                      ),
                    ],
                  )
              );
            }
          }
        },
        //padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 10.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Proxima Nova',
          ),
        ),
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context){
          return SignupScreenOne();
        }));
      },
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: 'Don\'t have an Account?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: ' Sign Up',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    checkPermissionForContribute();
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              ResponsiveContainer(
                heightPercent: 100.0,
                widthPercent: 100.0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(4280361249)
                    //color: Colors.blueAccent
                  ),
                ),
              ),

              Center(
                child: Form(
                  key: formKey,
                    child: ListView(
                      children: <Widget>[
                        ResponsiveContainer(
                          heightPercent: 100.0,
                          widthPercent: 100.0,
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal: 40.0,
                              vertical: 120.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Log In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Proxima Nova',
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 30.0),
                                _buildEmailTF(),
                                SizedBox(height: 30.0),
                                _buildPasswordTF(),
                                _buildForgotPasswordBtn(),
                                _buildRememberMeCheckbox(),
                                SizedBox(height: 30.0),
                                _buildLoginBtn(),
                                SizedBox(height: 20.0),
                                _buildSignupBtn(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



