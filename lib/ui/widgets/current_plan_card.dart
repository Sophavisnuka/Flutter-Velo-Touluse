import 'package:flutter/material.dart';

class CurrentPlanCard extends StatelessWidget {
  const CurrentPlanCard({
    super.key,
    required this.color,
    required this.bgColor
  });

  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('Current Plan', style: TextStyle(fontSize: 12, color: color)),
          Text('Day Pass', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color)),
        ],
      ),
    );
  }
}