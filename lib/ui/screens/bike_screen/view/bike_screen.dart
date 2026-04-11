import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/data/repositories/station_repository.dart';
import 'package:velo_toulouse/model/station.dart';
import 'package:velo_toulouse/ui/screens/bike_screen/view/bike_tile.dart';
import 'package:velo_toulouse/ui/screens/bike_screen/view_models/bike_view_model.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';

class BikeScreen extends StatefulWidget {
  final Station station;

  const BikeScreen({super.key, required this.station});

  @override
  State<BikeScreen> createState() => _BikeScreenState();
}

class _BikeScreenState extends State<BikeScreen> {
  late final BikeViewModel _vm;

  @override
  void initState() {
    super.initState();
    _vm = BikeViewModel(
      repo: StationRepository(firestore: FirebaseFirestore.instance),
    );
    _vm.selectStation(widget.station); 
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _vm,
      child: Consumer<BikeViewModel>(
        builder: (context, vm, _) {
          final station = vm.selectedStation;
          return Scaffold(
            backgroundColor: AppTheme.surface,
            appBar: AppBar(
              backgroundColor: AppTheme.background,
              title: Text(widget.station.name),
            ),
            body: _buildBody(vm, station),
          );
        },
      ),
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