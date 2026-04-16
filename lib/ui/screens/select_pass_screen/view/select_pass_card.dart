import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:velo_toulouse/model/pass_type.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';
import 'package:velo_toulouse/ui/widgets/list_tile_card.dart';

class SelectPassCard extends StatelessWidget {
  final PassType type;
  final bool isCurrent;
  final DateTime? expiresAt;      // only set when isCurrent == true
  final VoidCallback? onSwitch;

  const SelectPassCard({
    super.key,
    required this.type,
    this.isCurrent = false,
    this.expiresAt,
    this.onSwitch,
  });

  String get _formattedExpiry {
    if (expiresAt == null) return '—';
    return DateFormat('MMM d, yyyy').format(expiresAt!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          // Header
          ListTileCard(
            color: type.color,
            icon: type.icon,
            title: type.label,
            subtitle: '${type.price}${type.priceSuffix}',
            bgColor: Colors.white,
          ),

          const SizedBox(height: 10),

          // Feature bullets
          ...type.details.map(
            (detail) => ListTile(
              leading: const Icon(Icons.verified, color: Colors.green),
              title: Text(detail),
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),

          const Divider(),

          // Expiry + action
          ListTile(
            title: const Text('Expires'),
            subtitle: Text(
              isCurrent ? _formattedExpiry : '—',
            ),
            trailing: isCurrent
                ? Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.secondary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text(
                      'Current Pass',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                : TextButton(
                    onPressed: () => _confirmSwitch(context),
                    style: TextButton.styleFrom(
                      backgroundColor: AppTheme.primary.withOpacity(0.15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    ),
                    child: Text(
                      'Switch Plan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmSwitch(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Switch to ${type.label}?'),
        content: const Text(
          'Your current pass will be replaced immediately.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true) onSwitch?.call();
  }
}