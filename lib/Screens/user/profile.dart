import 'package:annahasta/models/cont_model.dart';
import 'package:annahasta/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:annahasta/Screens/common/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/remote_data_source/firestore_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

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
            padding: const EdgeInsets.all(10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: [
                    Image.asset(
                      'assets/default.png',
                      height: 120, // Set the height of the logo image
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$firstName $secondName",
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(
                            "$email",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _logout();
                            },
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    ),
                  ]),
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    "My Listings",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<List<ContModel>>(
                    stream: FirestoreHelper.read(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Center(
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
                                margin: const EdgeInsets.symmetric(vertical: 3),
                                child: Card(
                                  child: ListTile(
                                    leading: Container(
                                      width: 60.0,
                                      height: 80.0,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        color: Colors.white12,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: (() {
                                          if (singleUser.isveg ==
                                              "FoodType.veg") {
                                            return Image.asset(
                                                'assets/veg.png');
                                          } else if (singleUser.isveg ==
                                              "FoodType.nonVeg") {
                                            return Image.asset(
                                                'assets/nonveg.png');
                                          } else if (singleUser.isveg ==
                                              "thing") {
                                            return Image.asset(
                                                'assets/thing.png');
                                          } else {
                                            return Container();
                                          }
                                        })(),
                                      ),
                                    ),
                                    title: Text(
                                      "${singleUser.boxID}",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      "Date & Time: ${singleUser.contents}\nQuantity: ${singleUser.caseID}",
                                    ),
                                    onLongPress: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: const Text("Delete"),
                                            content: const Text(
                                                "Are you sure you want to delete"),
                                            actions: [
                                              ElevatedButton(
                                                style: const ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStatePropertyAll<
                                                          Color>(
                                                    Color.fromARGB(
                                                        255, 198, 40, 40),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  FirestoreHelper.delete(
                                                          singleUser.documentID)
                                                      .then(
                                                    (value) {
                                                      Navigator.pop(context);
                                                    },
                                                  );
                                                },
                                                child: const Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ])));
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');

    FirebaseAuth.instance.signOut();

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignInPage()));
  }
}
