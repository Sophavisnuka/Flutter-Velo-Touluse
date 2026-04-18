import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/model/pass_type.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/view/pass_activated_screen.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/view/pass_detail_screen.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/view/widgets/downgrade_blocked_sheet.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/view/widgets/payment_sheet.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/view/widgets/switch_confirm_sheet.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/view/widgets/switch_warning_sheet.dart';
import 'package:velo_toulouse/ui/services/navigation_service.dart';
import 'package:velo_toulouse/ui/services/notification_service.dart';
import 'package:velo_toulouse/ui/states/user_global_state.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';
import 'package:velo_toulouse/ui/widgets/list_tile_card.dart';
import 'package:velo_toulouse/util/formatter.dart';

class SelectPassCard extends StatelessWidget {
  final PassType type;
  final bool isCurrent;
  final DateTime? expiresAt;
  final bool fromBikeFlow;
  final void Function(DateTime)? onSwitch;

  const SelectPassCard({
    super.key,
    required this.type,
    this.isCurrent = false,
    this.expiresAt,
    this.fromBikeFlow = false,
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
          expiresAt: currentExpiresAt,
        ),
      );
      return;
    }

    // Show warning only for upgrades (higher tier, active, not expired).
    // Same-tier early renew skips warning because time is topped up, not lost.
    if (currentPass.isActive && !isPassExpired && type.tier > currentPass.tier) {
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

    // Confirm sheet
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

    // Payment sheet
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

    // For same-tier early renew: new period starts from current expiry (top-up).
    // For everything else (activate, upgrade, expired renew): starts from now.
    final bool isSameTierEarlyRenew =
        isCurrent && !isPassExpired && currentExpiresAt != null;
    final DateTime activatedAt =
        isSameTierEarlyRenew ? currentExpiresAt : DateTime.now();

    onSwitch?.call(activatedAt);

    if (context.mounted) {
      final notificationService = context.read<NotificationService>();
      final navigationService = context.read<NavigationService>();

      notificationService.show(InAppNotification(
        title: 'Pass Activated!',
        message: 'Ready to ride — tap to go release your bike',
        icon: Icons.directions_bike_rounded,
        color: Colors.green,
        onTap: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
          navigationService.goToTab(0);
        },
      ));

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PassActivatedScreen(
            newPass: type,
            activatedAt: activatedAt,
            fromBikeFlow: fromBikeFlow,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userVm = context.watch<UserGlobalState>();
    final currentPass = userVm.currentPass;
    final isPassExpired = userVm.isPassExpired;
    final currentExpiresAt = userVm.expiresAt;
    final label = _buttonLabel(currentPass, isPassExpired);
    final btnColor = _buttonColor(label);

    final card = Container(
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

    if (!isCurrent) return card;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PassDetailScreen()),
      ),
      child: card,
    );
  }
}
