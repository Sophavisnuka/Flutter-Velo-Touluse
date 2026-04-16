import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/model/slot.dart';
import 'package:velo_toulouse/model/station.dart';
import 'package:velo_toulouse/ui/screens/bike_screen/view/countdown_screen.dart';
import 'package:velo_toulouse/ui/screens/bike_screen/view/widgets/bike_tile.dart';
import 'package:velo_toulouse/ui/screens/bike_screen/view/widgets/release_confirmation_sheet.dart';
import 'package:velo_toulouse/ui/screens/bike_screen/view/widgets/return_confirmation_sheet.dart';
import 'package:velo_toulouse/ui/screens/bike_screen/view_models/bike_view_model.dart';
import 'package:velo_toulouse/ui/screens/map_screen/view_models/map_view_model.dart';
import 'package:velo_toulouse/ui/screens/trip_screen/trip_summary_screen.dart';
import 'package:velo_toulouse/ui/screens/trip_screen/view_models/trip_view_model.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';

class BikeContent extends StatelessWidget {
  final String stationName;

  const BikeContent({super.key, required this.stationName});

  void _showReleaseConfirmation(BuildContext context, Slot slot) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ReleaseConfirmationSheet(
        slot: slot,
        stationName: stationName,
        onSlideComplete: () async {
          Navigator.pop(context);
          final bikeVm = context.read<BikeViewModel>();
          final mapVm = context.read<MapViewModel>();
          await bikeVm.releaseBike(slot.slotId);
          if (bikeVm.selectedStation != null) {
            await mapVm.refreshStation(bikeVm.selectedStation!.stationId);
          }
          if (context.mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CountdownScreen(
                  slot: slot,
                  stationName: stationName,
                ),
              ),
            );
          }
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  void _showReturnConfirmation(BuildContext context, Slot slot) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ReturnConfirmationSheet(
        slot: slot,
        stationName: stationName,
        onSlideComplete: () async {
          Navigator.pop(context);
          final bikeVm = context.read<BikeViewModel>();
          final mapVm = context.read<MapViewModel>();
          await bikeVm.returnBike(slot.slotId);
          if (bikeVm.selectedStation != null) {
            await mapVm.refreshStation(bikeVm.selectedStation!.stationId);
          }
          if (context.mounted) {
            final tripVm = context.read<TripViewModel>();
            final elapsed = tripVm.elapsed;
            final startStation = tripVm.activeStartStationName ?? '';
            tripVm.endTrip(endStationName: stationName);
            // Clear the selected station so the map's .then() callback
            // doesn't re-open the popup when BikeScreen is removed from stack.
            context.read<MapViewModel>().clearSelectedStation();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => TripSummaryScreen(
                  duration: elapsed,
                  startStationName: startStation,
                  endStationName: stationName,
                ),
              ),
              (route) => route.isFirst,
            );
          }
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BikeViewModel>();
    final tripVm = context.watch<TripViewModel>();
    final station = vm.selectedStation;
    final isReturnMode = tripVm.isTripActive;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: Text(stationName),
        actions: isReturnMode
            ? [
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A63E).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color(0xFF00A63E).withOpacity(0.4)),
                  ),
                  child: const Text(
                    'Return Mode',
                    style: TextStyle(
                      color: Color(0xFF00A63E),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: _buildBody(context, vm, station, isReturnMode),
    );
  }

  Widget _buildBody(
      BuildContext context, BikeViewModel vm, Station? station, bool isReturnMode) {
    if (vm.isStationLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (station == null) {
      return const Center(child: Text('Failed to load station data.'));
    }
    if (station.slot.isEmpty) {
      return const Center(child: Text('No bikes available at this station.'));
    }

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: ListView.builder(
            itemCount: station.slot.length,
            itemBuilder: (context, index) {
              final slot = station.slot[index];
              return BikeTile(
                slotNumber: slot.slotNumber,
                hasBike: slot.hasBike,
                isReturnMode: isReturnMode,
                onRelease: (slot.hasBike && !isReturnMode)
                    ? () => _showReleaseConfirmation(context, slot)
                    : null,
                onReturn: (!slot.hasBike && isReturnMode)
                    ? () => _showReturnConfirmation(context, slot)
                    : null,
              );
            },
          ),
        ),
        // Loading overlay while releasing/returning
        if (vm.isReleasing)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
