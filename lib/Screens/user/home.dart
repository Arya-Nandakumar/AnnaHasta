import 'package:annahasta/Screens/ngo/home.dart';
import 'package:flutter/material.dart';
import 'package:annahasta/Screens/user/profile.dart';
import 'package:annahasta/models/cont_model.dart';
import '../../models/remote_data_source/firestore_helper.dart';
import 'package:annahasta/Functions/userbottomnav.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
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
                pageBuilder: (context, animation1, animation2) => const HomePage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
          child: const Text(
            'AnnaHasta',
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.account_circle_outlined,
            ),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const ProfilePage(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: const UserBottomNav(selectedIndex: 0),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
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
        child: Text("Some error occurred"),
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
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
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
                      const SizedBox(
                        width: 10,
                      ), // Add some space between the icon and text
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
          },
        ),
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  })

          ],
        ),
      ),
    );
  }
}
