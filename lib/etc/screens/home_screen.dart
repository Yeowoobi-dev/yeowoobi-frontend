// 홈 화면

import 'package:flutter/material.dart';
import 'package:yeowoobi_frontend/widgets/bottom_nav_bar.dart';
import 'package:yeowoobi_frontend/book_log/screens/book_log_screen.dart';
import 'package:yeowoobi_frontend/sns/screens/sns_screen.dart';
import 'package:yeowoobi_frontend/board/screens/board_screen.dart';
import 'package:yeowoobi_frontend/etc/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    BookLogScreen(),
    SnsScreen(),
    BoardScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        // IndexedStack으로 변경하여 상태 유지
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
