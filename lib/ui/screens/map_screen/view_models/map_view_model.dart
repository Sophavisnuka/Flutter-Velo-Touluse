import 'package:flutter/material.dart';
import 'package:velo_toulouse/data/repositories/station_repository.dart';
import 'package:velo_toulouse/model/station.dart';

class MapViewModel extends ChangeNotifier {

  final StationRepository repo;

  MapViewModel({
    required this.repo
  });

  List<Station> stations = [];
  bool isLoading = false;

  Future<void> loadStation() async {
    isLoading = true;
    notifyListeners();

    stations = await repo.fetchStation();
    
    isLoading = false;
    notifyListeners();
  }
}