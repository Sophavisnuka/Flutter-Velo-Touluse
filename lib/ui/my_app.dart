import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/ui/screens/history_screen/history_screen.dart';
import 'package:velo_toulouse/ui/screens/history_screen/view_models/ride_history_view_model.dart';
import 'package:velo_toulouse/ui/screens/map_screen/map_screen.dart';
import 'package:velo_toulouse/ui/screens/profile_screen/profile_screen.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/select_pass_screen.dart';
import 'package:velo_toulouse/ui/services/navigation_service.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';
import 'package:velo_toulouse/ui/widgets/app_notification_banner.dart';
import 'package:velo_toulouse/ui/widgets/bottom_nav_bar.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<Widget> screens = [
    MapScreen(),
    SelectPassScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final navService = context.watch<NavigationService>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: AppNotificationBanner(),
              ),
            ),
          ],
        );
      },
      home: Scaffold(
        extendBody: true,
        body: IndexedStack(
          index: navService.currentTab,
          children: screens,
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: navService.currentTab,
          onTabChanged: (index) {
            context.read<NavigationService>().goToTab(index);
            if (index == 2) {
              context.read<RideHistoryViewModel>().loadRides();
            }
          },
        ),
      ),
    );
  }
}
