import 'package:annahasta/models/cont_model.dart';
import 'package:annahasta/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:annahasta/Screens/common/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/remote_data_source/distributer_helper.dart';

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
            padding: const EdgeInsets.all(20),
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
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(150, 50),
                            ),
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
                    "Comfirmed Listings",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  StreamBuilder<List<ContModel>>(
                    stream: DistributedHelper.read(),
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
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 10.0),
                                    onLongPress: () {},
                                    title: Row(
                                      children: [
                                        if (singleUser.isveg == "FoodType.veg")
                                          Image.asset(
                                            'assets/veg.png',
                                            height: 15,
                                          ),
                                        if (singleUser.isveg ==
                                            "FoodType.nonVeg")
                                          Image.asset(
                                            'assets/nonveg.png',
                                            height: 15,
                                          ),
                                        if (singleUser.isveg == "thing")
                                          Image.asset(
                                            'assets/thing.png',
                                            height: 20,
                                          ),
                                        const SizedBox(width: 10),
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

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const SignInPage()));
  }
}
