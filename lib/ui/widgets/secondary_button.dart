import 'package:flutter/material.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.onGetDirections,
    required this.label,
    required this.icon
  });

  final VoidCallback onGetDirections;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onGetDirections,
      icon: Icon(icon),
      label: Text(
        label,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme.primary,
        side: const BorderSide(color: AppTheme.primary, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 18),
      ),
    );
  }
}