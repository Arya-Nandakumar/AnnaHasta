import 'package:flutter/material.dart';
import 'package:annahasta/main.dart';
import 'package:annahasta/Functions/bottomnav.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: FocusNode(),
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: TextStyle(color: Colors.white),
          onSubmitted: (value) {
            // Perform the search here
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Perform the search here
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNav(selectedIndex: 2),
    );
  }
}
