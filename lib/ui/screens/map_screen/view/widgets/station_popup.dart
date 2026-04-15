import 'package:flutter/material.dart';
import 'package:velo_toulouse/model/station.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';
import 'package:velo_toulouse/ui/widgets/list_tile_card.dart';
import 'package:velo_toulouse/ui/widgets/primary_button.dart';
import 'package:velo_toulouse/ui/widgets/secondary_button.dart';

class StationDetailPopup extends StatelessWidget {
  final Station stations;
  final VoidCallback onViewDetails;
  final VoidCallback onGetDirections;

  const StationDetailPopup({
    super.key,
    required this.stations,
    required this.onViewDetails,
    required this.onGetDirections,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Station title
          Text(
            stations.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          // Available bikes info
          ListTileCard(
            icon: Icons.ev_station,
            color: AppTheme.primary,
            bgColor: AppTheme.primary.withOpacity(0.15),
            title: 'Available bikes: ${stations.availableBike.toString()}',
          ),
          const SizedBox(height: 16),
          ListTileCard(
            icon: Icons.directions_bike,
            color: AppTheme.secondary,
            bgColor: AppTheme.secondary.withOpacity(0.15),
            title: 'Available slots: ${stations.availableSlots.toString()}',
          ),
          const SizedBox(height: 16),
          // Action buttons
          Row(
            children: [
              // Get Directions (Primary Button)
              Expanded(
                flex: 1,
                child: PrimaryButton(
                  onViewDetails: onViewDetails,
                  text: 'View Details',
                  icon: Icons.info_outline,
                ),
              ),
              const SizedBox(width: 10),
              // View Details (Secondary Button)
              Expanded(
                flex: 1,
                child: SecondaryButton(
                  onGetDirections: onGetDirections,
                  label: 'Get Directions',
                  icon: Icons.navigation,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}