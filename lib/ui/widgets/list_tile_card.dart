import 'package:flutter/material.dart';

class ListTileCard extends StatelessWidget {
  const ListTileCard({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    this.subtitle,
    this.bgColor,
  });

  final Color color;
  final IconData icon;
  final String title;
  final Color? bgColor;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(10),
        leading: Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(10),
          child: Icon(icon, color: color, fontWeight: FontWeight.bold,),
        ),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
      ),
    );
  }
}