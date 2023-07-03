import 'package:flutter/material.dart';
import '../Screens/ngo/home.dart';
import '../Screens/ngo/search.dart';
import 'package:line_icons/line_icons.dart';

class SBottomNavigationBar extends StatefulWidget {
  final int initialIndex;
  final Function(int) onItemTapped;

  const SBottomNavigationBar(
      {super.key, this.initialIndex = 0, required this.onItemTapped});

  @override
  _SBottomNavigationBarState createState() => _SBottomNavigationBarState();
}

class _SBottomNavigationBarState extends State<SBottomNavigationBar> {
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
            pageBuilder: (context, animation1, animation2) => const HomePage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
        break;
      case 1:
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
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LineIcons.home),
            label: 'Home',
            activeIcon: Icon(LineIcons.home),
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
