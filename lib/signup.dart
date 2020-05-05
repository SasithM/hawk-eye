import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hawk_eye/auth_service.dart';
import 'package:hawk_eye/landing.dart';
import 'package:responsive_container/responsive_container.dart';
import 'package:hawk_eye/constants.dart';
import 'package:hawk_eye/login.dart';

var signupData = new List(6);

class SignupScreenOne extends StatefulWidget {
  @override
  _SignupScreenOneState createState() => _SignupScreenOneState();
}

class _SignupScreenOneState extends State<SignupScreenOne> {

  final TextEditingController _email = new TextEditingController();
  final TextEditingController _pswd = new TextEditingController();
  final TextEditingController _name = new TextEditingController();
  final TextEditingController _nic = new TextEditingController();
  final TextEditingController _address = new TextEditingController();

  void createUser() async{
    Firestore dbreference = Firestore.instance;
    await dbreference.collection('user').document(signupData[0]).setData({
      'email': signupData[0].toString(),
      'name': signupData[2].toString(),
      'nic': signupData[3].toString(),
      'address': signupData[4].toString(),
      'accVerify': signupData[5],
    });
  }

  final signupFormKey = new GlobalKey<FormState>();

  Widget _buildSUEmailTF(){
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
          height: 40.0,
          child: TextFormField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Proxima Nova'
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 6.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter a valid Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSUPasswordTF(){
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
          height: 40.0,
          child: TextFormField(
            controller: _pswd,
            obscureText: true,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Proxima Nova',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 6.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter a Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSUNameTF(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            'Name',
            style: kLabelStyle
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 40.0,
          child: TextFormField(
            controller: _name,
            keyboardType: TextInputType.text,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Proxima Nova',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 6.0),
              prefixIcon: Icon(
                Icons.face,
                color: Colors.white,
              ),
              hintText: 'Enter your full name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSUIdentityTF(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            'NIC Number',
            style: kLabelStyle
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 40.0,
          child: TextFormField(
            controller: _nic,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Proxima Nova'
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 6.0),
              prefixIcon: Icon(
                Icons.confirmation_number,
                color: Colors.white,
              ),
              hintText: 'Enter your NIC number',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSUAddress(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
            'Address on Driving License',
            style: kLabelStyle
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 40.0,
          child: TextFormField(
            controller: _address,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Proxima Nova'
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 6.0),
              prefixIcon: Icon(
                Icons.my_location,
                color: Colors.white,
              ),
              hintText: 'Enter your Address',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSUNextBtn() {
    return ResponsiveContainer(
      //padding: EdgeInsets.symmetric(vertical: 25.0),
      widthPercent: 40.0,
      heightPercent: 5.0,
      child: RaisedButton(
        onPressed: () async {
          if(signupFormKey.currentState.validate()){
            signupData[0] = _email.text;
            signupData[1] = _pswd.text;
            signupData[2] = _name.text;
            signupData[3] = _nic.text;
            signupData[4] = _address.text;
            signupData[5] = false;

            //doSomething(email, pswd){};
            print(signupData[0].toString());
            print(signupData[1].toString());
            print(signupData[2].toString());
            print(signupData[3].toString());
            print(signupData[4].toString());
            print(signupData[5].toString());

            try{
              final form = signupFormKey.currentState;
              form.save();
              final auth = AuthService();
              String uid = await auth.createUserWithEmailAndPassword(_email.text, _pswd.text);
              print('signed ======= $uid');
              if (uid.length > 0 && uid != null) {
                createUser();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LandingPage()));
              }
            } catch (e) {
              print('Error: $e');
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Signup Failed', textAlign: TextAlign.center,),
                    content: Text('Invalid E-mail or Password or user already exists, please try with different details', textAlign: TextAlign.center,),
                    actions: <Widget>[
                      FlatButton(
                          child: Text('close'),
                          onPressed: () => Navigator.pop(context, false)
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
          'NEXT',
          style: TextStyle(
            color: Colors.black,
            letterSpacing: 1.5,
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Proxima Nova',
          ),
        ),
      ),
    );
  }

  Widget _buildSULoginBtn() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(MaterialPageRoute<Null>(builder: (BuildContext context){
          return LoginScreen();
        }));
      },
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: 'Already have an Account?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: ' Login',
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
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: <Widget>[
              ResponsiveContainer(
                widthPercent: 100.0,
                heightPercent: 100.0,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(4280361249)
                    //color: Colors.blueAccent
                  ),
                ),
              ),

              Center(
                child: Form(
                  key: signupFormKey,
                    child: ListView(
                      children: <Widget>[
                        ResponsiveContainer(
                          widthPercent: 100.0,
                          heightPercent: 100.0,
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal: 50.0,
                              vertical: 50.0,
                            ),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Proxima Nova',
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 40.0),
                                _buildSUEmailTF(),
                                SizedBox(height: 20.0),
                                _buildSUPasswordTF(),
                                SizedBox(height: 20.0),
                                _buildSUNameTF(),
                                SizedBox(height: 20.0),
                                _buildSUIdentityTF(),
                                SizedBox(height: 20.0),
                                _buildSUAddress(),
                                SizedBox(height: 40.0),
                                _buildSUNextBtn(),
                                SizedBox(height: 20.0),
                                _buildSULoginBtn(),
                              ],
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
