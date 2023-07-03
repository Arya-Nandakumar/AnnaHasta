import 'package:annahasta/Screens/common/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:annahasta/Functions/decidepage.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _checkIfLoggedIn();
    deleteOldDocuments();
  }

  void deleteOldDocuments() async {
    final now = DateTime.now();
    final sixHoursAgo = now.subtract(Duration(hours: 6));

    final firestore = FirebaseFirestore.instance;
    final collectionRef = firestore.collection('listings');

    final snapshot = await collectionRef.get();

    for (final doc in snapshot.docs) {
      final dateAndTime = doc.data()['dateAndTime'] as String;
      final documentTime = DateFormat('dd-MM-yy h:mm a').parse(dateAndTime);

      if (documentTime.isBefore(sixHoursAgo)) {
        await doc.reference.delete();
      }
    }
  }

  void _checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    if (email != null && password != null) {
      setState(() {});
      FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const VerifyCheckPage()));
      }).catchError((error) {
        print(error);
      });
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignInPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Color(0xFF5823f9)),
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
                const SizedBox(
                  height: 20.0,
                ),
                const CircularProgressIndicator()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
