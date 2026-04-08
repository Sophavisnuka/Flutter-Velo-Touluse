import 'package:cloud_firestore/cloud_firestore.dart';

class Station {
  final String stationId;
  final String name;
  final GeoPoint location;
  final int totalSlots;
  final int bikeCount;
  final int availableSlots;

  Station({
    required this.stationId,
    required this.name,
    required this.location,
    required this.totalSlots,
    required this.bikeCount,
    required this.availableSlots,
  });
}