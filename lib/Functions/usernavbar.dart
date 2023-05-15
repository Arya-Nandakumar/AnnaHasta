import 'package:annahasta/Screens/user/contribute.dart';
import 'package:flutter/material.dart';
import '../Screens/user/home.dart';
import '../Screens/user/search.dart';
import 'package:line_icons/line_icons.dart';

class SpotifyBottomNavigationBar extends StatefulWidget {
  final int initialIndex;
  final Function(int) onItemTapped;

  SpotifyBottomNavigationBar(
      {this.initialIndex = 0, required this.onItemTapped});

  @override
  _SpotifyBottomNavigationBarState createState() =>
      _SpotifyBottomNavigationBarState();
}

class _SpotifyBottomNavigationBarState
    extends State<SpotifyBottomNavigationBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    widget.onItemTapped(index);

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                const UserHomePage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => ContributePage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>
                const SearchPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: BottomNavigationBar(
        elevation: 1,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        items: [
          BottomNavigationBarItem(
            icon: Icon(LineIcons.home),
            label: 'Home',
            activeIcon: Icon(LineIcons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(LineIcons.plusCircle),
            label: 'Contribute',
            activeIcon: Icon(LineIcons.plusCircle),
          ),
          BottomNavigationBarItem(
            icon: Icon(LineIcons.search),
            label: 'Search',
            activeIcon: Icon(LineIcons.search),
          ),
        ],
      ),
    );
  }
}