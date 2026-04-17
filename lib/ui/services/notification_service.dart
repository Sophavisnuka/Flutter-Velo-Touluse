import 'dart:async';
import 'package:flutter/material.dart';

class InAppNotification {
  final String title;
  final String message;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;
  final Duration duration;

  const InAppNotification({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    this.onTap,
    this.duration = const Duration(seconds: 5),
  });
}

class NotificationService extends ChangeNotifier {
  InAppNotification? _current;
  InAppNotification? get current => _current;

  Timer? _timer;

  void show(InAppNotification notification) {
    _timer?.cancel();
    _current = notification;
    notifyListeners();
    _timer = Timer(notification.duration, dismiss);
  }

  void dismiss() {
    _timer?.cancel();
    _current = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
