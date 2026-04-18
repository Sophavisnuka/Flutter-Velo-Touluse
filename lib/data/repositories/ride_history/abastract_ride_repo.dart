import 'package:velo_toulouse/model/ride_history.dart';

abstract class AbstractRideRepo {
  Future<String> saveRide(RideHistory ride);
  Future<void> completeRide({
    required String userId,
    required String rideId,
    required String endStationName,
    required DateTime startedAt,
    required DateTime endedAt,
  });
  Future<List<RideHistory>> getRidesForUser(String userId);
}