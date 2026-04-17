import 'package:flutter/material.dart';
import 'package:velo_toulouse/model/pass_type.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';

class SwitchConfirmSheet extends StatelessWidget {
  final PassType currentPass;
  final PassType newPass;
  final VoidCallback onConfirm;

  const SwitchConfirmSheet({
    super.key,
    required this.currentPass,
    required this.newPass,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 20),

          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: newPass.color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(newPass.icon, color: newPass.color, size: 28),
          ),
          const SizedBox(height: 16),

          const Text(
            'Are you sure?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'This will cancel your ${currentPass.label} and activate your ${newPass.label} right now.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Yes, activate ${newPass.label}',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'No, keep my ${currentPass.label}',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}