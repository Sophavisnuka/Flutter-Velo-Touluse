import 'package:cloud_firestore/cloud_firestore.dart';

class Station {
  final String stationId;
  final String name;
  final GeoPoint location;
  final int totalSlots;
  final String status; // e.g., active, inactive

  Station({
    required this.stationId,
    required this.name,
    required this.location,
    required this.totalSlots,
    required this.status,
  });
}