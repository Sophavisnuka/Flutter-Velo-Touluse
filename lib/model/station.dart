import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velo_toulouse/model/slot.dart';

class Station {
  final String stationId;
  final String name;
  final GeoPoint location;
  final int availableBike;
  final int availableSlots;
  final List<Slot> slot;

  Station({
    required this.stationId,
    required this.name,
    required this.location,
    required this.availableBike,
    required this.availableSlots,
    required this.slot
  });
}