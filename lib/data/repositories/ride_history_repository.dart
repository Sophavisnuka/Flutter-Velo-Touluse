import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velo_toulouse/data/dto/ride_history_dto.dart';
import 'package:velo_toulouse/model/ride_history.dart';

class RideHistoryRepository {
  final _db = FirebaseFirestore.instance;

  CollectionReference _userRides(String userId) =>
      _db.collection('users').doc(userId).collection('rides');

  Future<String> saveRide(RideHistory ride) async {
    final doc = await _userRides(ride.userId).add(RideHistoryDto.toFirestore(ride));
    return doc.id; // return id so you can update it later when ride ends
  }

  Future<void> completeRide({
    required String userId,
    required String rideId,
    required String endStationName,
    required DateTime startedAt,
    required DateTime endedAt,
  }) async {
    await _userRides(userId).doc(rideId).update({
      'endStationName': endStationName,
      'endedAt': Timestamp.fromDate(endedAt),
      'durationMinutes': endedAt.difference(startedAt).inMinutes,
    });
  }

  Future<List<RideHistory>> getRidesForUser(String userId) async {
    final snapshot = await _userRides(userId)
        .orderBy('startedAt', descending: true) // no composite index needed now!
        .get();

    return snapshot.docs
        .map((doc) => RideHistoryDto.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }
}