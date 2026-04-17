import 'package:flutter/material.dart';
import 'package:velo_toulouse/model/ride_history.dart';
import 'package:velo_toulouse/ui/screens/history_screen/view/widgets/station_dot.dart';
import 'package:velo_toulouse/ui/screens/history_screen/view/widgets/status_badge.dart';
import 'package:velo_toulouse/util/formatter.dart';

class RideCard extends StatelessWidget {
  final RideHistory ride;

  const RideCard({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header — date + status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Formatter.expiry(ride.startedAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
                StatusBadge(isActive: ride.isActive),
              ],
            ),

            const SizedBox(height: 12),

            // Station route
            Row(
              children: [
                StationDot(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(ride.startStationName,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 12),
                      Text(
                        ride.endStationName ?? 'In progress...',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ride.isActive ? Colors.orange : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Duration
            Row(
              children: [
                Icon(Icons.timer_outlined, size: 14, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  '${ride.currentDuration} min',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}