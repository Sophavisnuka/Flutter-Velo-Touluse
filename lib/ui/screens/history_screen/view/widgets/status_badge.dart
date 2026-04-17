import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final bool isActive;
  const StatusBadge({super.key ,required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.orange.withOpacity(0.1) : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6, height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? Colors.orange : Colors.green,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            isActive ? 'Active' : 'Completed',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.orange : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}