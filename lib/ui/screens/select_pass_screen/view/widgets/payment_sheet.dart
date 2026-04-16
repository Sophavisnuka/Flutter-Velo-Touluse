import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:velo_toulouse/model/pass_type.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';

class PaymentSheet extends StatelessWidget {
  final PassType newPass;
  final VoidCallback onPaid;

  const PaymentSheet({
    super.key,
    required this.newPass,
    required this.onPaid,
  });

  String get _qrData {
    final uri = Uri.https('pay.velo-toulouse.com', '/velo', {
      'amount': newPass.price.toString(),
      'plan': newPass.name,
      'ref': 'VELO-${DateTime.now().millisecondsSinceEpoch}',
    });

    return uri.toString();
  }

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

          const Text(
            'Complete Payment',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Scan the QR code to pay for your ${newPass.label}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Amount
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Amount due', style: TextStyle(color: Colors.grey)),
                Text(
                  '${newPass.price}${newPass.priceSuffix}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // QR Code
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: QrImageView(
              data: _qrData,
              version: QrVersions.auto,
              size: 180,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Use your banking app to scan',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPaid,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'I have paid',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}