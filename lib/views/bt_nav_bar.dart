import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:workcheckin/views/checkin_screen.dart';
import 'package:workcheckin/views/history_screen.dart';
import 'package:workcheckin/views/home_screen.dart';
import 'package:workcheckin/views/leave_screen.dart';

class BtNavBar extends StatefulWidget {
  Map<String, dynamic> message;
  BtNavBar({Key key, this.message}) : super(key: key);
  @override
  _BtNavBarState createState() => _BtNavBarState();
}

class _BtNavBarState extends State<BtNavBar> {
  int _currentIndex = 0;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SizedBox.expand(
          child: PageView(

            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: <Widget>[
              CheckinScreen(),
              LeaveScreen(),
              HistoryScreen(),
              HomeScreen(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          showElevation: true,
          selectedIndex: _currentIndex,
          onItemSelected: (index) {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              title: Text('Item One'),
              icon: Icon(Icons.home),
              activeColor: Colors.blue,
              inactiveColor: Colors.grey[600],
            ),
            BottomNavyBarItem(
              title: Text('Item One'),
              icon: Icon(Icons.apps),
              activeColor: Colors.red,
              inactiveColor: Colors.grey[600],
            ),
            BottomNavyBarItem(
              title: Text('Item One'),
              icon: Icon(Icons.chat_bubble),
              activeColor: Colors.deepPurple,
              inactiveColor: Colors.grey[600],
            ),
            BottomNavyBarItem(
              title: Text('Item One'),
              icon: Icon(Icons.settings),
              inactiveColor: Colors.grey[600],
            ),
            BottomNavyBarItem(
              title: Text('Item One'),
              icon: Icon(Icons.settings),
              activeColor: Colors.greenAccent,
              inactiveColor: Colors.grey[600],
            ),
          ],
        ),
      );
    
  }
}