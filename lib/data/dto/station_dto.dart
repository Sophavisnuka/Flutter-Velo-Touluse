import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velo_toulouse/model/station.dart';

class StationDto {
  static const nameKey = 'name';
  static const locationKey = 'location';
  static const statusKey = 'status';
  static const totalSlotsKey = 'totalSlots';
  static const bikeCountKey = 'bikeCount';
  static const availableSlotsKey = 'availableSlots';

  static Station fromFireStore(String id, Map<String, dynamic>json,) {
    final geoPoint = json[locationKey] as GeoPoint;
    return Station(
      stationId: id,
      name: json[nameKey],
      location: geoPoint,
      totalSlots: json[totalSlotsKey],
      bikeCount: json[bikeCountKey],
      availableSlots: json[availableSlotsKey],
    );
  }
  static Map<String, dynamic> toFirestore(Station station) {
    return {
      nameKey: station.name,
      locationKey: station.location,
      totalSlotsKey: station.totalSlots,
      bikeCountKey: station.bikeCount,
      availableSlotsKey: station.availableSlots
    };
  }
}