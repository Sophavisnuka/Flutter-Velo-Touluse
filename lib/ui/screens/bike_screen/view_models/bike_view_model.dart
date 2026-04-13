import 'package:flutter/material.dart';
import 'package:velo_toulouse/data/repositories/station_repository.dart';
import 'package:velo_toulouse/model/station.dart';

class BikeViewModel extends ChangeNotifier {
  final StationRepository repo;

  BikeViewModel({required this.repo});

  Station? selectedStation;
  bool isStationLoading = false;

  Future<void> selectStation(Station station) async {
    isStationLoading = true;
    selectedStation = null;
    notifyListeners();

    selectedStation = await repo.fetchStationWithSlots(station.stationId);

    isStationLoading = false;
    notifyListeners();
  }
}