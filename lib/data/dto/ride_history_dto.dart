import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velo_toulouse/model/ride_history.dart';

class RideHistoryDto {
  static RideHistory fromFirestore(String id, Map<String, dynamic> json) {
    return RideHistory(
      id: id,
      userId: json['userId'],
      startStationName: json['startStationName'],
      endStationName: json['endStationName'],
      startedAt: (json['startedAt'] as Timestamp).toDate(),
      endedAt: (json['endedAt'] as Timestamp?)?.toDate(),
      durationMinutes: json['durationMinutes'],
    );
  }

  static Map<String, dynamic> toFirestore(RideHistory ride) {
    return {
      'userId': ride.userId,
      'startStationName': ride.startStationName,
      'endStationName': ride.endStationName,
      'startedAt': Timestamp.fromDate(ride.startedAt),
      'endedAt': ride.endedAt != null ? Timestamp.fromDate(ride.endedAt!) : null,
      'durationMinutes': ride.durationMinutes,
    };
  }
}