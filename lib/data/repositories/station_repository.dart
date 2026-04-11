import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velo_toulouse/data/dto/slot_dto.dart';
import 'package:velo_toulouse/data/dto/station_dto.dart';
import 'package:velo_toulouse/model/station.dart';

class StationRepository {
  final FirebaseFirestore firestore;

  StationRepository({
    required this.firestore
  });

  Future<List<Station>> fetchAllStations() async {
    final data = await firestore.collection('stations').get();

    return data.docs.map((doc) => StationDto.fromFireStore(doc.id, [], doc.data())).toList();
  }

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
}