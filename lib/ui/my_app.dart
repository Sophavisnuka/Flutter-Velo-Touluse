import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/ui/providers/bottom_nav_provider.dart';
import 'package:velo_toulouse/ui/screens/history_screen.dart';
import 'package:velo_toulouse/ui/screens/map_screen.dart';
import 'package:velo_toulouse/ui/screens/profile_screen.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen.dart';
import 'package:velo_toulouse/ui/widgets/bottom_nav_bar.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentIndex = 0;

  final List<Widget> screens = [
    MapScreen(),
    SelectPassScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  void onTabChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavProvider = context.watch<BottomNavProvider>();
    final currentIndex = bottomNavProvider.currentIndex;
    return ChangeNotifierProvider(
      create: (_) => BottomNavProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          extendBody: true,
          body: IndexedStack(
            index: currentIndex,
            children: screens,
          ),
          bottomNavigationBar: BottomNavBar(
            currentIndex: currentIndex,
            onTabChanged: (index) => bottomNavProvider.setIndex(index),
          ),
        ),
      ),
    );
  }
}