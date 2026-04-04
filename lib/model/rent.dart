import 'package:velo_toulouse/model/bike.dart';
import 'package:velo_toulouse/model/station.dart';

class Rental {
  final String rentalId;
  final Bike bikeId;
  final Station startStationId;
  final Station? endStationId;
  final DateTime startTime;
  final DateTime? endTime;

  Rental({
    required this.rentalId,
    required this.bikeId,
    required this.startTime,
    required this.startStationId,
    this.endStationId,
    this.endTime,
  });
}