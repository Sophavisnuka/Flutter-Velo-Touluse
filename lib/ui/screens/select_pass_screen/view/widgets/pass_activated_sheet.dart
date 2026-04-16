import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velo_toulouse/model/pass_type.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';

class PassActivatedSheet extends StatelessWidget {
  final PassType newPass;
  final DateTime activatedAt;

  const PassActivatedSheet({
    super.key,
    required this.newPass,
    required this.activatedAt,
  });

  @override
  Widget build(BuildContext context) {
    final expiresAt = newPass.expiresAt(activatedAt);
    final expiryText = expiresAt != null
        ? DateFormat('MMM d, yyyy').format(expiresAt)
        : '—';

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
          const SizedBox(height: 24),

          // Success icon
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle, color: Colors.green, size: 40),
          ),
          const SizedBox(height: 16),

          const Text(
            'Pass Activated!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Your ${newPass.label} is now active.',
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          // Pass details
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: newPass.color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: newPass.color.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Icon(newPass.icon, color: newPass.color, size: 32),
                const SizedBox(height: 8),
                Text(
                  newPass.label,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Expires: $expiryText',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Done',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}