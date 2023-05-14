import 'package:annahasta/Screens/user/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:annahasta/models/cont_model.dart';
import '../../models/remote_data_source/firestore_helper.dart';
import 'package:annahasta/Functions/newnavbar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _scrollController = ScrollController();

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
      extendBody: true,
      bottomNavigationBar: SpotifyBottomNavigationBar(
        initialIndex: 2,
        onItemTapped: (index) {
          // Do something when an item in the navigation bar is tapped
        },
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            floating: false,
            pinned: true,
            snap: false,
            expandedHeight: 100.0,
            actions: <Widget>[],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: EdgeInsets.fromLTRB(20, 0, 0, 8),
              title: TextField(
                autofocus: true,
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search',
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  _onSearchChanged();
                },
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Details'),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                      "Location: ${_resultList[index]['boxID']}"),
                                  const SizedBox(height: 5),
                                  Text(
                                      "Quantity: ${_resultList[index]['caseID']}"),
                                  const SizedBox(height: 5),
                                  if (_resultList[index]['itemtype'] == "food")
                                    Text(
                                        "Vegetarian: ${_resultList[index]['isveg'] == "FoodType.veg" ? "Yes" : "No"}"),
                                  if (_resultList[index]['itemtype'] != "food")
                                    Text(
                                        "Item Name: ${_resultList[index]['itemtype']}"),
                                  const SizedBox(height: 5),
                                  Text(
                                      "Date & Time: ${_resultList[index]['contents']}"),
                                  const SizedBox(height: 5),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context, _resultList[index].id);
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Card(
                      child: ListTile(
                        leading: Container(
                          width: 60.0,
                          height: 80.0,
                          decoration: const BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            color: Colors.white12,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: (() {
                              if (_resultList[index]['isveg'] ==
                                  "FoodType.veg") {
                                return Image.asset('assets/veg.png');
                              } else if (_resultList[index]['isveg'] ==
                                  "FoodType.nonVeg") {
                                return Image.asset('assets/nonveg.png');
                              } else if (_resultList[index]['isveg'] ==
                                  "thing") {
                                return Image.asset('assets/thing.png');
                              } else {
                                return Container();
                              }
                            })(),
                          ),
                        ),
                        title: Text(
                          "${_resultList[index]['boxID']}",
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          "Date & Time: ${_resultList[index]['contents']}\nQuantity: ${_resultList[index]['caseID']}",
                        ),
                      ),
                    ),
                  );
                },
                childCount: _resultList.length,
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
