import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:velo_toulouse/data/repositories/station_repository.dart';
import 'package:velo_toulouse/model/station.dart';

class MapViewModel extends ChangeNotifier {

  final StationRepository repo;

  MapViewModel({
    required this.repo
  });

  List<Station> stations = [];
  List<Station> filteredStations = [];
  bool isLoading = false;
  MapController mapController = MapController();

  Future<void> loadStation() async {
    isLoading = true;
    notifyListeners();

    stations = await repo.fetchStation();
    
    isLoading = false;
    notifyListeners();
  }

  Future<void> searchStation(String query) async {
    if (query.isEmpty) {
      filteredStations = [];
    } else {
      filteredStations = stations.where((stations) {
        return stations.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  Future<void> moveToStation(Station station) async {
    mapController.move(
      LatLng(station.location.latitude, station.location.longitude),16
    );
  }
}