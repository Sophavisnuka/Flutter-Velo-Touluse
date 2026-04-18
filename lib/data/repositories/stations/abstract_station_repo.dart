import 'package:velo_toulouse/model/station.dart';

abstract class AbstractStationRepository {
  Future<List<Station>> fetchAllStations();
  Future<Station> fetchStation(String stationId);
  Future<Station> fetchStationWithSlots(String stationId);
  Future<void> releaseBike(String stationId, String slotId);
  Future<void> returnBike(String stationId, String slotId);
}