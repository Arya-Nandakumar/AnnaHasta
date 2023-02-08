import 'package:flutter/material.dart';
import 'package:annahasta/Screens/home.dart';
import 'package:annahasta/Functions/colorhex.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnnaHasta',
      theme: ThemeData(
        primarySwatch: buildMaterialColor(Color(0xFF7A01FF)),
      ),
      home: HomePage(),
    );
  }
}
