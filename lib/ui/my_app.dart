import 'package:flutter/material.dart';
import 'package:velo_toulouse/ui/screens/history_screen.dart';
import 'package:velo_toulouse/ui/screens/map_screen/map_screen.dart';
import 'package:velo_toulouse/ui/screens/profile_screen/profile_screen.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/view/select_pass_screen.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';
import 'package:velo_toulouse/ui/widgets/bottom_nav_bar.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> screens = [
    MapScreen(),
    SelectPassScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: _currentIndex,
          onTabChanged: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}