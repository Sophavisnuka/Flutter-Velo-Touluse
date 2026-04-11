import 'package:flutter/material.dart';

class IconTextTile extends StatelessWidget {
  const IconTextTile({
    super.key,
    this.text,
    // this.stations,
    required this.textColor,
    required this.bgColor,
    required this.icons,
    required this.iconColor,
  });

  final Color textColor;
  final Color bgColor;
  final Color iconColor;
  final IconData icons;
  final String? text;
  // final Station? stations;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icons, color: iconColor),
          const SizedBox(width: 8),
          Text(
            text!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}