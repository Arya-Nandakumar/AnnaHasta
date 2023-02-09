import 'package:annahasta/Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:annahasta/Functions/colorhex.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
      
        primarySwatch: buildMaterialColor(Color(0xFF7A01FF)),
      ), 
      home: LoginPage(),
    );
  }
}