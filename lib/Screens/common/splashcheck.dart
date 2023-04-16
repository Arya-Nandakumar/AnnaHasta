import 'package:annahasta/Screens/common/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:annahasta/Functions/decidepage.dart';


class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _isLoading = false;
   @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
  }
  
  
   void _checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    if (email != null && password != null) {
      setState(() {
      });
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => VerifyCheckPage()));
      }).catchError((error) {
        print(error);
      });
    }
    else {
      Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SignInPage()));
    }
  }


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      Container(
        decoration: BoxDecoration(color: Color(0xFF5823f9)),
      child: Center(
         child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/icon/logo_w.png',
                  height: 100, // Set the height of the logo image
                ),
                SizedBox(
                  height: 20.0,
                ),
              CircularProgressIndicator()
              ],
         ),
      ),
      ),
      ),
    );
  }
}