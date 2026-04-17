import 'package:flutter/material.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';
import 'package:velo_toulouse/util/formatter.dart';

class TripSummaryScreen extends StatelessWidget {
  final Duration duration;
  final String startStationName;
  final String endStationName;

  const TripSummaryScreen({
    super.key,
    required this.duration,
    required this.startStationName,
    required this.endStationName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),

              // Success icon
              Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: const Color(0xFF00A63E).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF00A63E),
                  size: 52,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              const Text(
                'Trip Complete!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF101828),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your bike has been returned safely.',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF6A7282),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Duration card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Trip Duration',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6A7282),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      Formatter.formatDuration(duration),
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF101828),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Route card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _StationRow(
                      icon: Icons.radio_button_checked,
                      iconColor: AppTheme.primary,
                      label: 'From',
                      stationName: startStationName,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Column(
                        children: List.generate(
                          3,
                          (i) => Container(
                            width: 2,
                            height: 6,
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            color: const Color(0xFFD1D5DB),
                          ),
                        ),
                      ),
                    ),
                    _StationRow(
                      icon: Icons.location_on,
                      iconColor: const Color(0xFF00A63E),
                      label: 'To',
                      stationName: endStationName,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Done button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.15),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _StationRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String stationName;

  const _StationRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.stationName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 20),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              stationName,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF101828),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
