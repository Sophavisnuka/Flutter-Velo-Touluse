import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velo_toulouse/model/ride_history.dart';

class RideHistoryDto {
  static RideHistory fromFirestore(String id, Map<String, dynamic> json) {
    // Support old records that stored durationMinutes instead of durationSeconds
    int? durationSeconds = json['durationSeconds'];
    if (durationSeconds == null && json['durationMinutes'] != null) {
      durationSeconds = (json['durationMinutes'] as int) * 60;
    }

    return RideHistory(
      id: id,
      userId: json['userId'],
      startStationName: json['startStationName'],
      endStationName: json['endStationName'],
      startedAt: (json['startedAt'] as Timestamp).toDate(),
      endedAt: (json['endedAt'] as Timestamp?)?.toDate(),
      durationSeconds: durationSeconds,
    );
  }

  static Map<String, dynamic> toFirestore(RideHistory ride) {
    return {
      'userId': ride.userId,
      'startStationName': ride.startStationName,
      'endStationName': ride.endStationName,
      'startedAt': Timestamp.fromDate(ride.startedAt),
      'endedAt': ride.endedAt != null ? Timestamp.fromDate(ride.endedAt!) : null,
      'durationSeconds': ride.durationSeconds,
    };
  }
}
