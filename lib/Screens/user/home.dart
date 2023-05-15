import 'package:annahasta/Screens/user/profile.dart';
import 'package:flutter/material.dart';
import 'package:annahasta/models/cont_model.dart';
import '../../models/remote_data_source/firestore_helper.dart';
import 'package:annahasta/Functions/usernavbar.dart';
import 'package:annahasta/Functions/colorhex.dart';
import 'package:line_icons/line_icons.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final _scrollController = ScrollController();
  final bool _showTitle = true;
  final String _appBarTitle = "AnnaHasta";
  final String _scrollTitle = "Listings";

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color color = isDarkMode ? Colors.white : Colors.black;
    final Color adColor = isDarkMode
        ? buildMaterialColor(const Color(0xFF242525))
        : buildMaterialColor(const Color(0xFFBDBDBD));
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: SpotifyBottomNavigationBar(
        initialIndex: 0,
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
              background: Image.asset(
                'assets/background.png',
                fit: BoxFit.cover,
              ),
              titlePadding: EdgeInsets.fromLTRB(20, 0, 0, 8),
              title: Row(
                children: [
                  Text(
                    'AnnaHasta',
                    style: TextStyle(
                      color: color,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: const Icon(LineIcons.userCircle),
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
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
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
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: userData!.length,
                        itemBuilder: (context, index) {
                          final singleUser = userData[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            child: Card(
                              child: ListTile(
                                leading: Container(
                                  width: 60.0,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    color: adColor,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: (() {
                                      if (singleUser.isveg == "FoodType.veg") {
                                        return Image.asset('assets/veg.png');
                                      } else if (singleUser.isveg ==
                                          "FoodType.nonVeg") {
                                        return Image.asset('assets/nonveg.png');
                                      } else if (singleUser.isveg == "thing") {
                                        return Image.asset('assets/thing.png');
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
              )
            ]),
          ),
        ],
      ),
    );
  }
}
