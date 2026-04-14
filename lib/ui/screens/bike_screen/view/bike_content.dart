import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/model/station.dart';
import 'package:velo_toulouse/ui/screens/bike_screen/view/widgets/bike_tile.dart';
import 'package:velo_toulouse/ui/screens/bike_screen/view_models/bike_view_model.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';

class BikeContent extends StatelessWidget {
  final String stationName;

  const BikeContent({super.key, required this.stationName});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<BikeViewModel>();
    final station = vm.selectedStation;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        title: Text(stationName),
      ),
      body: _buildBody(vm, station),
    );
  }

  Widget _buildBody(BikeViewModel vm, Station? station) {
    if (vm.isStationLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (station == null) {
      return const Center(child: Text('Failed to load station data.'));
    }
    if (station.slot.isEmpty) {
      return const Center(child: Text('No bikes available at this station.'));
    }
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ListView.builder(
        itemCount: station.slot.length,
        itemBuilder: (context, index) {
          final slot = station.slot[index];
          return BikeTile(
            slotId: slot.slotNumber,
            hasBike: slot.hasBike,
          );
        },
      ),
    );
  }
}