import 'package:flutter/material.dart';

class NavigationService extends ChangeNotifier {
  int _currentTab = 0;
  int get currentTab => _currentTab;

  void goToTab(int index) {
    if (_currentTab == index) return;
    _currentTab = index;
    notifyListeners();
  }
}
