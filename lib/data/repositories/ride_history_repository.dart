import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velo_toulouse/data/dto/ride_history_dto.dart';
import 'package:velo_toulouse/model/ride_history.dart';

class RideHistoryRepository {
  final FirebaseFirestore firestore;

  const RideHistoryRepository({required this.firestore});

  Future<String> saveRide(RideHistory ride) async {
    final doc = await firestore
        .collection('users')
        .doc(ride.userId)
        .collection('rides')
        .add(RideHistoryDto.toFirestore(ride));
    return doc.id;
  }

  Future<void> completeRide({
    required String userId,
    required String rideId,
    required String endStationName,
    required DateTime startedAt,
    required DateTime endedAt,
  }) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('rides')
        .doc(rideId)
        .update({
      'endStationName': endStationName,
      'endedAt': Timestamp.fromDate(endedAt),
      'durationSeconds': endedAt.difference(startedAt).inSeconds,
    });
  }

  Future<List<RideHistory>> getRidesForUser(String userId) async {
    final snapshot = await firestore
      .collection('users')
      .doc(userId)
      .collection('rides')
      .orderBy('startedAt', descending: true)
      .get();

    return snapshot.docs
      .map((doc) => RideHistoryDto.fromFirestore(
        doc.id,
        doc.data(),
      ))
      .toList();
  }
}