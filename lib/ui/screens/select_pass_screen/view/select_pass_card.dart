import 'package:flutter/material.dart';

enum PassType {
  day,
  monthly,
  yearly,
}

class SelectPassCard extends StatelessWidget {
  final PassType type;
  final bool isCurrent;
  final VoidCallback? onSwitch; // callback when "Switch Plan" is pressed

  const SelectPassCard({
    super.key,
    required this.type,
    this.isCurrent = false,
    this.onSwitch,
  });

  // Getters for icon, color, name, price, details, expireDate
  IconData get icon {
    switch (type) {
      case PassType.day:
        return Icons.sunny;
      case PassType.monthly:
        return Icons.calendar_month;
      case PassType.yearly:
        return Icons.calendar_today;
    }
  }

  Color get iconColor {
    switch (type) {
      case PassType.day:
        return Colors.deepOrange;
      case PassType.monthly:
        return Colors.blue;
      case PassType.yearly:
        return Colors.purple;
    }
  }

  String get passName {
    switch (type) {
      case PassType.day:
        return 'Day Pass';
      case PassType.monthly:
        return 'Monthly Pass';
      case PassType.yearly:
        return 'Yearly Pass';
    }
  }

  String get price {
    switch (type) {
      case PassType.day:
        return '\$2.50/day';
      case PassType.monthly:
        return '\$25.00/month';
      case PassType.yearly:
        return '\$250.00/year';
    }
  }

  List<String> get details {
    switch (type) {
      case PassType.day:
        return ['Valid for 24 hours from activation', 'Instant Activation'];
      case PassType.monthly:
        return ['Valid for 30 days', 'Unlimited rides'];
      case PassType.yearly:
        return ['Valid for 365 days', 'Unlimited rides', 'Priority support'];
    }
  }

  String get expireDate {
    switch (type) {
      case PassType.day:
        return 'Mar 31, 2026';
      case PassType.monthly:
        return 'Apr 30, 2026';
      case PassType.yearly:
        return 'Dec 31, 2026';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // Top tile with icon, name and price
          ListTile(
            leading: Container(
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.all(10),
              child: Icon(icon, color: iconColor),
            ),
            title: Text(passName),
            subtitle: Text(price),
          ),

          SizedBox(height: 10),

          // Feature details
          ...details.map(
            (detail) => ListTile(
              leading: Icon(Icons.verified, color: Colors.green),
              title: Text(detail),
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),

          Divider(),

          // Expire info + switch/current button
          ListTile(
            title: Text('Expires'),
            subtitle: Text(expireDate),
            trailing: isCurrent
                ? Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      'Current Pass',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                : TextButton(
                    onPressed: onSwitch ?? () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.orange.withOpacity(0.15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    ),
                    child: Text(
                      'Switch Plan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[800],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}