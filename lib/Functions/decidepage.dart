import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:annahasta/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:annahasta/Screens/ngo/home.dart';
import 'package:annahasta/Screens/common/remindv.dart';
import 'package:annahasta/Screens/user/home.dart';

class VerifyCheckPage extends StatefulWidget {
  const VerifyCheckPage({super.key});

  @override
  _VerifyCheckPageState createState() => _VerifyCheckPageState();
}

class _VerifyCheckPageState extends State<VerifyCheckPage> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    pullData();
  }

  Future<void> decidePage() async {
    if (loggedInUser.isVerified == true) {
      setState(() {
        _isLoading = true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('userid', user!.uid);
      prefs.setString('firstname', loggedInUser.firstName ?? '');
      prefs.setString('secondname', loggedInUser.secondName ?? '');

      if (loggedInUser.fssai != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const UserHomePage()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()));
      }
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const RemindVerifyPage()));
    }
  }

  void pullData() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      decidePage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
