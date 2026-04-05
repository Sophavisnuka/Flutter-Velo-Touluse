import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velo_toulouse/data/dto/station_dto.dart';
import 'package:velo_toulouse/model/station.dart';

class StationRepository {
  final FirebaseFirestore firestore;

  StationRepository({
    required this.firestore
  });

  Future<List<Station>> fetchStation() async {

    final data = await firestore.collection('stations').get();
    return data.docs.map((doc) {
      return StationDto.fromFireStore(doc.id, doc.data());
    }).toList();
  }
}