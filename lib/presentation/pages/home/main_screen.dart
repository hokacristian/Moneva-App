import 'package:flutter/material.dart';
import 'package:moneva/presentation/pages/home/home_page.dart';
import 'package:moneva/presentation/pages/history/history_input_page.dart';
import 'package:moneva/presentation/pages/outcome/outcome_page.dart';
import 'package:moneva/presentation/pages/dampak/dampak_page.dart';
import 'package:moneva/presentation/pages/profile/profile_page.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // List halaman berdasarkan index
  final List<Widget> _pages = [
    HomePage(),
    HistoryInputPage(),
    OutcomePage(),
    DampakPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Agar icon tidak mengecil
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Outcome",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: "Dampak",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
