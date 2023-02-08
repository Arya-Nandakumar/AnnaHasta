import 'package:flutter/material.dart';
import 'package:annahasta/main.dart';
import 'package:annahasta/Functions/bottomnav.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('AnnaHasta'),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNav(selectedIndex: 0),
    );
  }
}
