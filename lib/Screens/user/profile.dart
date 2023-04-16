import 'package:annahasta/models/cont_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:annahasta/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:annahasta/Screens/common/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/remote_data_source/firestore_helper.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? email;
  String? userID;
  String? firstName;
  String? secondName;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

 void _fetchDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = (prefs.getString('email') ?? '');
      firstName = (prefs.getString('firstname') ?? '');
      secondName = (prefs.getString('secondname') ?? '');
      userID = (prefs.getString('userid') ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
  body: Padding(
      padding: EdgeInsets.all(20),
      child:Column(
         crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
                Row(
      children: [
         Image.asset(
                  'assets/default.png',
                  height: 120, // Set the height of the logo image
                ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${firstName} ${secondName}",
                style: TextStyle(fontSize: 18),
              ),
             Text("${email}",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
                SizedBox(
        height: 10,
      ),
              ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: Size(150, 50),
        ),
        onPressed: () {
          _logout();
        },
        child: Text('Logout'),
      ),
            ],
          ),
        ),
      ]
    ),
    SizedBox(
        height: 40,
      ),
     Text(
        "My Listings",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 20,
      ),
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
        child: Text("some error occurred"),
      );
    }
    if (snapshot.hasData) {
      final userData = snapshot.data;
      final filteredData = userData!
          .where((user) => user.userid == userID)
          .toList(); // Filter data based on userid value
      return Expanded(
        child: ListView.builder(
          itemCount: filteredData.length,
          itemBuilder: (context, index) {
            final singleUser = filteredData[index];
            return Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("Delete"),
                          content: Text(
                              "Are you sure you want to delete"),
                          actions: [
                            ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                  Color.fromARGB(255, 198, 40, 40),
                                ),
                              ),
                              onPressed: () {
                                FirestoreHelper.delete(singleUser.documentID)

                                    .then(
                                  (value) {
                                    Navigator.pop(context);
                                  },
                                );
                              },
                              child: Text(
                                "Delete",
                                style: TextStyle(color: Colors.white),
                              ),
                            )
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
                      SizedBox(width: 10),
                     Flexible(
                        child: Text(
                          "${singleUser.boxID}",
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    "Date & Time: ${singleUser.contents}\nQuantity: ${singleUser.caseID}",
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
    return Center(
      child: CircularProgressIndicator(),
    );
  },
),

      ]
    )
  )
    );
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');

    FirebaseAuth.instance.signOut();

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => SignInPage()));
  }
}
