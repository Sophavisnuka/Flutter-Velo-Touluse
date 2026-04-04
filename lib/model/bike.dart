import 'package:velo_toulouse/model/station.dart';

class Bike {
  final String bikeId;
  final String status; // available, in-use, broken, maintenance
  final Station? currentStationId;

  Bike({
    required this.bikeId,
    required this.status,
    this.currentStationId,
  });
}