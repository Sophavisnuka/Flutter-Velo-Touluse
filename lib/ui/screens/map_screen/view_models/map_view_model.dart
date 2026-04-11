import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:velo_toulouse/data/repositories/station_repository.dart';
import 'package:velo_toulouse/model/station.dart';

class MapViewModel extends ChangeNotifier {
  final StationRepository repo;

  MapViewModel({required this.repo});

  List<Station> stations = [];
  List<Station> filteredStations = [];
  bool isMapLoading = false;
  MapController mapController = MapController();

  Future<void> loadStation() async {
    isMapLoading = true;
    notifyListeners();

    stations = await repo.fetchAllStations();

    isMapLoading = false;
    notifyListeners();
  }

  void filterStations(String query) {
    if (query.isEmpty) {
      filteredStations = [];
    } else {
      filteredStations = stations.where((station) {
        return station.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  void moveToStation(Station station) {
    filteredStations = [];
    notifyListeners();

    mapController.move(
      LatLng(station.location.latitude, station.location.longitude), 16,
    );
  }
}