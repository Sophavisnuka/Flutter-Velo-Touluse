import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velo_toulouse/data/dto/slot_dto.dart';
import 'package:velo_toulouse/data/dto/station_dto.dart';
import 'package:velo_toulouse/data/repositories/stations/abstract_station_repo.dart';
import 'package:velo_toulouse/model/station.dart';

class StationRepository implements AbstractStationRepository {
  final FirebaseFirestore firestore;

  StationRepository({
    required this.firestore
  });

  @override
  Future<List<Station>> fetchAllStations() async {
    final data = await firestore.collection('stations').get();

    return data.docs.map((doc) => StationDto.fromFireStore(doc.id, [], doc.data())).toList();
  }

  @override
  Future<Station> fetchStation(String stationId) async {
    final doc = await firestore.collection('stations').doc(stationId).get();
    return StationDto.fromFireStore(doc.id, [], doc.data()!);
  }

  @override
  Future<Station> fetchStationWithSlots(String stationId) async {

    final stationData = await firestore.collection('stations').doc(stationId).get();

    final slotData = await firestore
      .collection('stations')
      .doc(stationId)
      .collection('slots')
      .orderBy('slotNumber')
      .get();

    final slots = slotData.docs.map((doc) => SlotDto.fromFirestore(doc.id, doc.data())).toList();

    return StationDto.fromFireStore(stationData.id, slots, stationData.data()!);
  }

  @override
  Future<void> releaseBike(String stationId, String slotId) async {
    final batch = firestore.batch();

    batch.update(
      firestore
          .collection('stations')
          .doc(stationId)
          .collection('slots')
          .doc(slotId),
      {'hasBike': false},
    );

    batch.update(
      firestore.collection('stations').doc(stationId),
      {
        'availableBike': FieldValue.increment(-1),
        'availableSlots': FieldValue.increment(1),
      },
    );

    await batch.commit();
  }

  @override
  Future<void> returnBike(String stationId, String slotId) async {
    final batch = firestore.batch();

    batch.update(
      firestore
          .collection('stations')
          .doc(stationId)
          .collection('slots')
          .doc(slotId),
      {'hasBike': true},
    );

    batch.update(
      firestore.collection('stations').doc(stationId),
      {
        'availableBike': FieldValue.increment(1),
        'availableSlots': FieldValue.increment(-1),
      },
    );

    await batch.commit();
  }
}