import 'package:flutter/material.dart';
import 'package:velo_toulouse/model/pass_type.dart';
import 'package:velo_toulouse/util/formatter.dart';

/// Bottom sheet shown when user tries to switch to a lower-tier pass.
/// Explains the restriction and shows when the current pass expires.
class DowngradeBlockedSheet extends StatelessWidget {
  final PassType currentPass;
  final DateTime? expiresAt;

  const DowngradeBlockedSheet({
    super.key,
    required this.currentPass,
    required this.expiresAt,
  });

  @override
  Widget build(BuildContext context) {
    final expiryText = Formatter.expiry(expiresAt);

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
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.block, color: Colors.red, size: 28),
          ),
          const SizedBox(height: 16),

          const Text(
            'Downgrade Not Allowed',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          Text(
            'You have an active ${currentPass.label}. Switching to a lower-tier pass is not allowed.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: currentPass.color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: currentPass.color.withOpacity(0.25)),
            ),
            child: Row(
              children: [
                Icon(currentPass.icon, color: currentPass.color, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentPass.label,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Expires: $expiryText',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          if (expiresAt != null)
            Text(
              'Your ${currentPass.label} will expire on $expiryText. You can switch to a higher-tier pass at any time.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Got it',
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
