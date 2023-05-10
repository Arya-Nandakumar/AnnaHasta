import 'dart:ffi';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:annahasta/Functions/bottomnav.dart';

import '../ngo/proceed.dart';

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
        ),
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNav(selectedIndex: 1),
      body: ListView.builder(
          itemCount: _resultList.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Details'),
                      content: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Location: ${_resultList[index]['boxID']}"),
                            SizedBox(height: 5),
                            Text("Quantity: ${_resultList[index]['caseID']}"),
                            SizedBox(height: 5),
                            if (_resultList[index]['itemtype'] == "food")
                              Text(
                                  "Vegetarian: ${_resultList[index]['isveg'] == "FoodType.veg" ? "Yes" : "No"}"),
                            if (_resultList[index]['itemtype'] != "food")
                              Text(
                                  "Item Name: ${_resultList[index]['itemtype']}"),
                            SizedBox(height: 5),
                            Text(
                                "Date & Time: ${_resultList[index]['contents']}"),
                            SizedBox(height: 5),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, _resultList[index].id);
                          },
                          child: Text('Close'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        ProceedPage(
                                            documentId: _resultList[index].id!),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                                settings: RouteSettings(
                                    arguments: _resultList[index].id),
                              ),
                            );
                          },
                          child: Text('Proceed'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: ListTile(
                title: Text(
                  _resultList[index]['boxID'],
                ),
                subtitle: Text(
                  _resultList[index]['caseID'],
                ),
                trailing: Text(
                  _resultList[index]['contents'],
                ),
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
