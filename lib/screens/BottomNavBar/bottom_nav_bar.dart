import 'package:flutter/material.dart';

import 'history_screen.dart';
import 'home_screen.dart';
import 'serach_screen.dart';

class BottomNavBarScreen extends StatefulWidget {
  @override
  _BottomNavBarScreenState createState() => _BottomNavBarScreenState();
}

class _BottomNavBarScreenState extends State<BottomNavBarScreen> {
  int selectedIndex = 0;
  PageController _pageController = PageController();

  void changeIndex({index}) {
    setState(() {
      selectedIndex = index;
      _pageController.animateToPage(selectedIndex,
          duration: Duration(microseconds: 600), curve: Curves.linear);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            print(selectedIndex);
            selectedIndex = index;
            _pageController.animateToPage(selectedIndex,
                duration: Duration(microseconds: 600), curve: Curves.linear);
          });
        },
        elevation: 10,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue,
        selectedFontSize: 12,
        unselectedFontSize: 10,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.favorite_sharp), label: 'Subscription'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
              ),
              label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
              ),
              label: 'History'),
        ],
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        children: [
          HomeScreen(),
          SearchScreen(),
          HistoryScreen(),
        ],
      ),
    );
  }
}
