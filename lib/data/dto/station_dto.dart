import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velo_toulouse/model/slot.dart';
import 'package:velo_toulouse/model/station.dart';

class StationDto {
  static const nameKey = 'name';
  static const locationKey = 'location';
  static const statusKey = 'status';
  static const availableBikeKey = 'availableBike';
  static const availableSlotsKey = 'availableSlots';

  static Station fromFireStore(String id, List<Slot> slots, Map<String, dynamic> json,) {
    final geoPoint = json[locationKey] as GeoPoint;
    return Station(
      stationId: id,
      name: json[nameKey],
      location: geoPoint,
      availableBike: json[availableBikeKey],
      availableSlots: json[availableSlotsKey],
      slot: slots
    );
  }
  static Map<String, dynamic> toFirestore(Station station) {
    return {
      nameKey: station.name,
      locationKey: station.location,
      availableBikeKey: station.availableBike,
      availableSlotsKey: station.availableSlots
    };
  }
}