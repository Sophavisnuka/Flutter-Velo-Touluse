import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/select_pass_screen.dart';
import 'package:velo_toulouse/ui/states/user_view_model.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';
import 'package:velo_toulouse/util/formatter.dart';

/// Screen showing the user's active pass details: type, activation date,
/// expiry, time remaining, price, and included benefits.
class PassDetailScreen extends StatelessWidget {
  const PassDetailScreen({super.key});

  String _timeRemaining(DateTime expiresAt) {
    final now = DateTime.now();
    if (now.isAfter(expiresAt)) return 'Expired';
    final diff = expiresAt.difference(now);
    final days = diff.inDays;
    final hours = diff.inHours.remainder(24);
    if (days > 0) {
      return '$days day${days == 1 ? '' : 's'} $hours hr${hours == 1 ? '' : 's'} remaining';
    }
    return '$hours hour${hours == 1 ? '' : 's'} remaining';
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserViewModel>();
    final pass = vm.currentPass;
    final activatedAt = vm.user?.activatedAt;
    final expiresAt = vm.expiresAt;
    final isExpired = vm.isPassExpired;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F1F1),
      appBar: AppBar(
        title: const Text('Pass Details', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Pass hero card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    width: 72, height: 72,
                    decoration: BoxDecoration(
                      color: pass.color.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(pass.icon, color: pass.color, size: 36),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    pass.label,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isExpired
                          ? Colors.red.withOpacity(0.12)
                          : Colors.green.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isExpired ? 'Expired' : 'Active',
                      style: TextStyle(
                        color: isExpired ? Colors.red : Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Info rows
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _infoRow(
                    icon: Icons.calendar_today,
                    label: 'Activated On',
                    value: activatedAt != null ? Formatter.expiry(activatedAt) : '—',
                  ),
                  const Divider(height: 1, indent: 56),
                  _infoRow(
                    icon: Icons.event_busy,
                    label: 'Expires On',
                    value: Formatter.expiry(expiresAt),
                  ),
                  const Divider(height: 1, indent: 56),
                  _infoRow(
                    icon: Icons.hourglass_bottom,
                    label: 'Time Remaining',
                    value: expiresAt != null ? _timeRemaining(expiresAt) : '—',
                    valueColor: isExpired ? Colors.red : Colors.green[700],
                  ),
                  const Divider(height: 1, indent: 56),
                  _infoRow(
                    icon: Icons.attach_money,
                    label: 'Price',
                    value: '${pass.price}${pass.priceSuffix}',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Benefits
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'What\'s included',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  const SizedBox(height: 12),
                  ...pass.details.map(
                    (d) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.verified, color: Colors.green, size: 18),
                          const SizedBox(width: 10),
                          Expanded(child: Text(d, style: const TextStyle(fontSize: 13))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SelectPassScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Switch Pass',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[500]),
          const SizedBox(width: 16),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
