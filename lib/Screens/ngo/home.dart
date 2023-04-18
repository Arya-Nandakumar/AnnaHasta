import 'package:annahasta/Screens/ngo/details.dart';
import 'package:annahasta/Screens/ngo/proceed.dart';
import 'package:flutter/material.dart';
import 'package:annahasta/main.dart';
import 'package:annahasta/Functions/bottomnav.dart';
import 'package:annahasta/Screens/ngo/profile.dart';
import 'package:annahasta/models/cont_model.dart';
import '../../models/remote_data_source/firestore_helper.dart';
import 'package:annahasta/Screens/user/home.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        centerTitle: true,
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    UserHomePage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
          child: Text(
            'AnnaHasta',
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.account_circle_outlined,
            ),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      ProfilePage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: BottomNav(selectedIndex: 0),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            StreamBuilder<List<ContModel>>(
                stream: FirestoreHelper.read(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text("some error occured"),
                    );
                  }
                  if (snapshot.hasData) {
                    final userData = snapshot.data;
                    return Expanded(
                      child: ListView.builder(
                          itemCount: userData!.length,
                          itemBuilder: (context, index) {
                            final singleUser = userData[index];
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 10.0),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Details"),
                                          content: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  "Location: ${singleUser.boxID}"),
                                              SizedBox(height: 5),
                                              Text(
                                                  "Quantity: ${singleUser.caseID}"),
                                              SizedBox(height: 5),
                                              if(singleUser.itemtype=="food")
                                              Text(
                                                  "Vegetarian: ${singleUser.isveg == "FoodType.veg" ? "Yes" : "No"}"),
                                              if(singleUser.itemtype!="food")
                                              Text(
                                                  "Item Name: ${singleUser.itemtype}"),
                                              SizedBox(height: 5),
                                              Text(
                                                  "Date & Time: ${singleUser.contents}"),
                                              SizedBox(height: 5),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context,singleUser.documentID);
                                              },
                                              child: Text('Close'),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation1, animation2) => ProceedPage(documentId: singleUser.documentID!),
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    settings: RouteSettings(arguments: singleUser.documentID),
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
                                  title: Row(
                                    children: [
                                      if (singleUser.isveg == "FoodType.veg")
                                        Image.asset(
                                          'assets/veg.png',
                                          height: 15,
                                        ),
                                      if (singleUser.isveg == "FoodType.nonVeg")
                                        Image.asset(
                                          'assets/nonveg.png',
                                          height: 15,
                                        ),
                                      if (singleUser.isveg == "thing")
                                        Image.asset(
                                          'assets/thing.png',
                                          height: 20,
                                        ),
                                      // Add leading idd leading icon
                                      SizedBox(
                                          width:
                                              10), // Add some space between the icon and text
                                      Flexible(
                        child: Text(
                          "${singleUser.boxID}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                                    ],
                                  ),
                                  subtitle: Text(
                                      "Date & Time: ${singleUser.contents}\nQuantity: ${singleUser.caseID}"),
                                ),
                              ),
                            );
                          }),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                })
          ],
        ),
      ),
    );
  }
}
