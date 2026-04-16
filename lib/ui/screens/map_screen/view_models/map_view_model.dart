import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
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
  Station? selectedStation;

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

  /// Selects a station and moves the map so the station is centered
  /// in the visible area between the search bar and the popup.
  /// [cameraShiftDown] is how many screen pixels to shift the camera
  /// center southward (positive y in world coords), which moves the
  /// station upward on screen.
  void selectStation(Station station, {double cameraShiftDown = 0}) {
    selectedStation = station;
    filteredStations = [];
    notifyListeners();

    final stationLatLng = LatLng(
      station.location.latitude,
      station.location.longitude,
    );

    if (cameraShiftDown > 0) {
      try {
        final camera = mapController.camera;
        // Project the station to world pixel space at zoom 16.
        // y increases southward, so adding to y moves the camera center south,
        // which makes the station appear north of (above) screen center.
        final stationOffset = camera.projectAtZoom(stationLatLng, 16.0);
        final shiftedOffset = Offset(
          stationOffset.dx,
          stationOffset.dy + cameraShiftDown,
        );
        final newCenter = camera.unprojectAtZoom(shiftedOffset, 16.0);
        mapController.move(newCenter, 16.0);
      } catch (_) {
        mapController.move(stationLatLng, 16.0);
      }
    } else {
      mapController.move(stationLatLng, 16.0);
    }
  }

  void clearSelectedStation() {
    selectedStation = null;
    notifyListeners();
  }

  /// Re-fetches a single station's counts from Firestore and updates the
  /// in-memory list so markers and the popup show fresh data.
  Future<void> refreshStation(String stationId) async {
    final updated = await repo.fetchStation(stationId);

    stations = stations.map((s) {
      return s.stationId == stationId ? updated : s;
    }).toList();

    if (selectedStation?.stationId == stationId) {
      selectedStation = updated;
    }

    notifyListeners();
  }
}
