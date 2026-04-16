import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/model/pass_type.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/view/widgets/pass_activated_sheet.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/view/widgets/payment_sheet.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/view/widgets/switch_confirm_sheet.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/view/widgets/switch_warning_sheet.dart';
import 'package:velo_toulouse/ui/states/user_view_model.dart';
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

  Future<void> _confirmSwitch(BuildContext context, PassType currentPass) async {
    // Step 1: Warning sheet (only if user has an active pass)
    if (currentPass.isActive) {
      final continueToConfirm = await showModalBottomSheet<bool>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => SwitchWarningSheet(
          currentPass: currentPass,
          newPass: type,
          onContinue: () => Navigator.pop(context, true),
        ),
      );
      if (continueToConfirm != true) return;
    }

    // Step 2: Confirm sheet
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SwitchConfirmSheet(
        currentPass: currentPass,
        newPass: type,
        onConfirm: () => Navigator.pop(context, true),
      ),
    );
    if (confirmed != true) return;

    // Step 3: Payment sheet
    final paid = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaymentSheet(
        newPass: type,
        onPaid: () => Navigator.pop(context, true),
      ),
    );
    if (paid != true) return;

    // Step 4: Activate pass
    onSwitch?.call();
    final now = DateTime.now();

    if (context.mounted) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        isDismissible: false,
        builder: (_) => PassActivatedSheet(
          newPass: type,
          activatedAt: now,
        ),
      );
    }
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
                    // In SelectPassCard, update the Switch Plan button:
                    onPressed: () {
                      final currentPass = context.read<UserViewModel>().currentPass;
                      _confirmSwitch(context, currentPass);
                    },
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
}