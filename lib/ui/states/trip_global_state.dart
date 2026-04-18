import 'package:flutter/material.dart';
import 'package:velo_toulouse/data/repositories/ride_history_repository.dart';
import 'package:velo_toulouse/model/slot.dart';
import 'package:velo_toulouse/model/ride_history.dart';

class TripGlobalState extends ChangeNotifier {
  final RideHistoryRepository _rideHistoryRepository;
  final String userId; // pass current user id in

  TripGlobalState({
    required this.userId, 
    required RideHistoryRepository rideHistoryRepository,
  })
      : _rideHistoryRepository = rideHistoryRepository;

  bool isTripActive = false;
  Slot? activeTripSlot;
  String? activeStartStationName;
  String? activeEndStationName;
  DateTime? tripStartTime;
  DateTime? tripEndTime;
  String? _activeRideId; // track the saved ride so we can update it later

  Future<void> startTrip({required Slot slot, required String stationName}) async {
    isTripActive = true;
    activeTripSlot = slot;
    activeStartStationName = stationName;
    activeEndStationName = null;
    tripStartTime = DateTime.now();
    tripEndTime = null;

    // Save ride to Firestore
    final ride = RideHistory(
      id: '',
      userId: userId,
      startStationName: stationName,
      startedAt: tripStartTime!,
    );
    _activeRideId = await _rideHistoryRepository.saveRide(ride);

    notifyListeners();
  }

  Future<void> endTrip({required String endStationName}) async {
    isTripActive = false;
    activeEndStationName = endStationName;
    tripEndTime = DateTime.now();

    // Complete the ride in Firestore
    if (_activeRideId != null) {
      await _rideHistoryRepository.completeRide(
        userId: userId,
        rideId: _activeRideId!,
        endStationName: endStationName,
        startedAt: tripStartTime!,
        endedAt: tripEndTime!,
      );
      _activeRideId = null;
    }

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
