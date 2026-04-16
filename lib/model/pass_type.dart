import 'package:flutter/material.dart';

enum PassType {
  none(
    label: 'No Pass',
    price: '—',
    priceSuffix: '',
    icon: Icons.block,
    color: Colors.grey,
    details: [],
  ),
  day(
    label: 'Day Pass',
    price: '€2.00',
    priceSuffix: '/day',
    icon: Icons.sunny,
    color: Colors.deepOrange,
    details: [
      'Valid for 24 hours from activation',
      'Usage fees apply per 30 min',
    ],
  ),
  monthly(
    label: 'Monthly Pass',
    price: '€15.00',
    priceSuffix: '/month',
    icon: Icons.calendar_month,
    color: Colors.blue,
    details: [
      'Valid for 30 days',
      'First 30 min free per ride',
    ],
  ),
  yearly(
    label: 'Yearly Pass',
    price: '€25.00',
    priceSuffix: '/year',
    icon: Icons.calendar_today,
    color: Colors.purple,
    details: [
      'Valid for 365 days',
      'First 30 min free per ride',
      'Priority support',
    ],
  );

  const PassType({
    required this.label,
    required this.price,
    required this.priceSuffix,
    required this.icon,
    required this.color,
    required this.details,
  });

  final String label;
  final String price;
  final String priceSuffix;
  final IconData icon;
  final Color color;
  final List<String> details;

  bool get isActive => this != PassType.none;

  /// Computes the expiry date dynamically from activation date
  DateTime? expiresAt(DateTime activatedAt) {
    switch (this) {
      case PassType.day:
        return activatedAt.add(const Duration(hours: 24));
      case PassType.monthly:
        return DateTime(
          activatedAt.year,
          activatedAt.month + 1,
          activatedAt.day,
        );
      case PassType.yearly:
        return DateTime(
          activatedAt.year + 1,
          activatedAt.month,
          activatedAt.day,
        );
      case PassType.none: 
        return null;
    }
  }
}