import 'package:flutter/material.dart';
import 'package:velo_toulouse/data/repositories/ride_history_repository.dart';
import 'package:velo_toulouse/model/ride_history.dart';

class RideHistoryViewModel extends ChangeNotifier {
  final RideHistoryRepository _repository;
  final String userId;

  RideHistoryViewModel({required this.userId, required RideHistoryRepository repository})
      : _repository = repository;

  List<RideHistory> rides = [];
  bool isLoading = false;

  Future<void> loadRides() async {
    isLoading = true;
    notifyListeners();

    rides = await _repository.getRidesForUser(userId);

    isLoading = false;
    notifyListeners();
  }
}