import 'package:flutter/material.dart';
import 'package:velo_toulouse/model/pass_type.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';

class SwitchWarningSheet extends StatelessWidget {
  final PassType currentPass;
  final PassType newPass;
  final VoidCallback onContinue;

  const SwitchWarningSheet({
    super.key,
    required this.currentPass,
    required this.newPass,
    required this.onContinue,
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
          // Handle
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 20),

          // Icon
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
          ),
          const SizedBox(height: 16),

          const Text(
            'Switch your pass?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            'You already have an active pass. Please read before continuing.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Pass comparison
          Row(
            children: [
              Expanded(child: _passChip(currentPass, 'Active now', isActive: true)),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.arrow_forward, color: Colors.grey),
              ),
              Expanded(child: _passChip(newPass, 'New pass', isActive: false)),
            ],
          ),
          const SizedBox(height: 20),

          // Warnings
          _warningTile(Icons.cancel_outlined, Colors.red,
            'Your ${currentPass.label} will be cancelled immediately — even if there is time remaining.'),
          const SizedBox(height: 8),
          _warningTile(Icons.money_off, Colors.orange,
            'No refund will be issued for unused time on your current pass.'),
          const SizedBox(height: 8),
          _warningTile(Icons.layers_clear, Colors.orange,
            'Passes cannot be stacked — only one pass is active at a time.'),
          const SizedBox(height: 24),

          // Buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'I understand — continue',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Keep my ${currentPass.label}',
                style: const TextStyle(color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _passChip(PassType pass, String label, {required bool isActive}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isActive ? pass.color : pass.color.withOpacity(0.4),
          width: isActive ? 1.5 : 1,
        ),
        borderRadius: BorderRadius.circular(10),
        color: pass.color.withOpacity(0.05),
      ),
      child: Column(
        children: [
          Icon(pass.icon, color: pass.color, size: 20),
          const SizedBox(height: 6),
          Text(pass.label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          Text(
            '${pass.price}${pass.priceSuffix}',
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? Colors.green : pass.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _warningTile(IconData icon, Color color, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87)),
        ),
      ],
    );
  }
}