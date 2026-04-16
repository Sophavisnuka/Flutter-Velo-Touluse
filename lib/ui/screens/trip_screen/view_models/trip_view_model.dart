import 'package:flutter/material.dart';
import 'package:velo_toulouse/model/slot.dart';

class TripViewModel extends ChangeNotifier {
  bool isTripActive = false;
  Slot? activeTripSlot;
  String? activeStartStationName;
  String? activeEndStationName;
  DateTime? tripStartTime;
  DateTime? tripEndTime;

  void startTrip({required Slot slot, required String stationName}) {
    isTripActive = true;
    activeTripSlot = slot;
    activeStartStationName = stationName;
    activeEndStationName = null;
    tripStartTime = DateTime.now();
    tripEndTime = null;
    notifyListeners();
  }

  void endTrip({required String endStationName}) {
    isTripActive = false;
    activeEndStationName = endStationName;
    tripEndTime = DateTime.now();
    notifyListeners();
  }

  Duration get elapsed {
    if (tripStartTime == null) return Duration.zero;
    final end = tripEndTime ?? DateTime.now();
    return end.difference(tripStartTime!);
  }

  void reset() {
    isTripActive = false;
    activeTripSlot = null;
    activeStartStationName = null;
    activeEndStationName = null;
    tripStartTime = null;
    tripEndTime = null;
    notifyListeners();
  }
}
