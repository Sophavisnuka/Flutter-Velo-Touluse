import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velo_toulouse/model/station.dart';

class StationDto {
  static const nameKey = 'name';
  static const locationKey = 'location';
  static const statusKey = 'status';
  static const totalSlotsKey = 'totalSlots';

  static Station fromFireStore(String id, Map<String, dynamic>json,) {
    final geoPoint = json[locationKey] as GeoPoint;
    return Station(
      stationId: id,
      name: json[nameKey],
      location: geoPoint,
      status: json[statusKey],
      totalSlots: json[totalSlotsKey]
    );
  }
  static Map<String, dynamic> toFirestore(Station station) {
    return {
      nameKey: station.name,
      locationKey: station.location,
      totalSlotsKey: station.totalSlots,
      statusKey: station.status,
    };
  }
}