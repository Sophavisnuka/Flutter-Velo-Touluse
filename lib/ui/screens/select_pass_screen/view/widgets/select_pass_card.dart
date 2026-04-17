import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/model/pass_type.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/view/pass_activated_screen.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/view/widgets/downgrade_blocked_sheet.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/view/widgets/payment_sheet.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/view/widgets/switch_confirm_sheet.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/view/widgets/switch_warning_sheet.dart';
import 'package:velo_toulouse/ui/states/user_view_model.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';
import 'package:velo_toulouse/ui/widgets/list_tile_card.dart';
import 'package:velo_toulouse/util/formatter.dart';

class SelectPassCard extends StatelessWidget {
  final PassType type;
  final bool isCurrent;
  final DateTime? expiresAt;
  final VoidCallback? onSwitch;

  const SelectPassCard({
    super.key,
    required this.type,
    this.isCurrent = false,
    this.expiresAt,
    this.onSwitch,
  });

  String _buttonLabel(PassType currentPass, bool isExpired) {
    if (isCurrent) {
      return isExpired ? 'Renew' : 'Renew Early';
    }
    if (!currentPass.isActive) return 'Activate Pass';
    if (type.tier > currentPass.tier) return 'Upgrade';
    assert(type.tier < currentPass.tier, 'Same-tier non-current card should not reach here');
    return 'Downgrade'; // type.tier < currentPass.tier
  }

  Color _buttonColor(String label) {
    switch (label) {
      case 'Renew':
        return Colors.green;
      case 'Renew Early':
        return Colors.orange;
      case 'Downgrade':
        return Colors.red;
      default:
        return AppTheme.primary;
    }
  }

  Future<void> _confirmSwitch(
      BuildContext context,
      PassType currentPass,
      bool isPassExpired,
      DateTime? currentExpiresAt) async {
    // Block downgrade
    if (currentPass.isActive && type.tier < currentPass.tier) {
      await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => DowngradeBlockedSheet(
          currentPass: currentPass,
          expiresAt: currentExpiresAt, // always the active pass's expiry
        ),
      );
      return;
    }

    // Step 1: Warning sheet (skip if no current pass OR current pass is expired)
    if (currentPass.isActive && !isPassExpired) {
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
    if (!context.mounted) return;
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
    if (!context.mounted) return;
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

    // Step 4: Activate + full-screen celebration
    onSwitch?.call();
    final now = DateTime.now();

    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PassActivatedScreen(
            newPass: type,
            activatedAt: now,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userVm = context.watch<UserViewModel>();
    final currentPass = userVm.currentPass;
    final isPassExpired = userVm.isPassExpired;
    final currentExpiresAt = userVm.expiresAt;
    final label = _buttonLabel(currentPass, isPassExpired);
    final btnColor = _buttonColor(label);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          ListTileCard(
            color: type.color,
            icon: type.icon,
            title: type.label,
            subtitle: '${type.price}${type.priceSuffix}',
            bgColor: Colors.white,
          ),

          const SizedBox(height: 10),

          ...type.details.map(
            (detail) => ListTile(
              leading: const Icon(Icons.verified, color: Colors.green),
              title: Text(detail),
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
          ),

          const Divider(),

          ListTile(
            title: const Text('Expires'),
            subtitle: Text(
              isCurrent ? Formatter.expiry(expiresAt) : '—',
            ),
            trailing: TextButton(
              onPressed: () =>
                  _confirmSwitch(context, currentPass, isPassExpired, currentExpiresAt),
              style: TextButton.styleFrom(
                backgroundColor: btnColor.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: btnColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
