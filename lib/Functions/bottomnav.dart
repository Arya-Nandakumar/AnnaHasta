import 'package:flutter/material.dart';
import 'package:annahasta/Screens/ngo/home.dart';
import 'package:annahasta/Screens/ngo/contribute.dart';
import 'package:annahasta/Screens/ngo/search.dart';

class BottomNav extends StatelessWidget {
  final int selectedIndex;
  BottomNav({this.selectedIndex = 0});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      animationDuration: const Duration(seconds: 1),
      selectedIndex: selectedIndex,
      destinations: const <Widget>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Home',
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.find_in_page_sharp),
          icon: Icon(Icons.find_in_page_outlined),
          label: 'Search',
        ),
      ],
      onDestinationSelected: (int index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => HomePage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            break;
          // case 1:
          //   Navigator.pushReplacement(
          //     context,
          //     PageRouteBuilder(
          //       pageBuilder: (context, animation1, animation2) =>
          //           ContributePage(),
          //       transitionDuration: Duration.zero,
          //       reverseTransitionDuration: Duration.zero,
          //     ),
          //   );
          //   break;
          case 1:
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => SearchPage(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
            break;
        }
      },
    );
  }
}
