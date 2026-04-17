import 'package:flutter/material.dart';

class StationDot extends StatelessWidget {
  const StationDot({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.radio_button_checked, size: 14, color: Colors.green),
        Container(width: 1.5, height: 20, color: Colors.grey.shade300),
        const Icon(Icons.location_on, size: 14, color: Colors.red),
      ],
    );
  }
}