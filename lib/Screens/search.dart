import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:annahasta/Functions/bottomnav.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List _allResults = [];
  List _resultList = [];

  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);

    super.initState();
  }

  _onSearchChanged() {
    print(_searchController.text);
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    if (_searchController.text != "") {
      for (var clientSnapShot in _allResults) {
        var boxID = clientSnapShot['boxID'].toString().toLowerCase();
        if (boxID.contains(_searchController.text.toLowerCase())) {
          showResults.add(clientSnapShot);
        }
        var caseID = clientSnapShot['caseID'].toString().toLowerCase();
        if (caseID.contains(_searchController.text.toLowerCase())) {
          showResults.add(clientSnapShot);
        }
        var contents = clientSnapShot['contents'].toString().toLowerCase();
        if (contents.contains(_searchController.text.toLowerCase())) {
          showResults.add(clientSnapShot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultList = showResults;
    });
  }

  getClientStream() async {
    var data = await FirebaseFirestore.instance
        .collection('listings')
        .orderBy('boxID')
        .get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getClientStream();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 4,
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: TextStyle(color: Colors.white),
              border: InputBorder.none,
              icon: Icon(Icons.search, color: Colors.white),
            ),
            onChanged: (value) {
              _onSearchChanged();
            },
          )),
      bottomNavigationBar: BottomNav(selectedIndex: 2),
      body: ListView.builder(
          itemCount: _resultList.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                _resultList[index]['boxID'],
              ),
              subtitle: Text(
                _resultList[index]['caseID'],
              ),
              trailing: Text(
                _resultList[index]['contents'],
              ),
            );
          }),
    );
  }
}






















// class SearchPage extends StatefulWidget {
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 4,
//         title: TextField(
//           style: TextStyle(color: Colors.white),
//           controller: _searchController,
//           decoration: InputDecoration(
//             hintText: 'Search...',
//             border: InputBorder.none,
//             hintStyle: TextStyle(color: Colors.grey[350]),
//           ),
//           onSubmitted: (value) {
//             // Perform the search here
//           },
//         ),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(Icons.search),
//             onPressed: () {
//               // Perform the search here
//             },
//           ),
//         ],
//         automaticallyImplyLeading: false,
//       ),
//       bottomNavigationBar: BottomNav(selectedIndex: 2),
//     );
//   }
// }
