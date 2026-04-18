import 'package:flutter/material.dart';
import 'package:velo_toulouse/data/repositories/stations/station_repository.dart';
import 'package:velo_toulouse/model/station.dart';

class BikeViewModel extends ChangeNotifier {
  final StationRepository repo;

  BikeViewModel({required this.repo});

  Station? selectedStation;
  bool isStationLoading = false;
  bool isReleasing = false;

  Future<void> selectStation(Station station) async {
    isStationLoading = true;
    selectedStation = null;
    notifyListeners();

    selectedStation = await repo.fetchStationWithSlots(station.stationId);

    isStationLoading = false;
    notifyListeners();
  }

  Future<void> releaseBike(String slotId) async {
    if (selectedStation == null) return;
    isReleasing = true;
    notifyListeners();

    await repo.releaseBike(selectedStation!.stationId, slotId);
    selectedStation = await repo.fetchStationWithSlots(selectedStation!.stationId);

    isReleasing = false;
    notifyListeners();
  }

  Future<void> returnBike(String slotId) async {
    if (selectedStation == null) return;
    isReleasing = true;
    notifyListeners();

    await repo.returnBike(selectedStation!.stationId, slotId);
    selectedStation = await repo.fetchStationWithSlots(selectedStation!.stationId);

    isReleasing = false;
    notifyListeners();
  }
}