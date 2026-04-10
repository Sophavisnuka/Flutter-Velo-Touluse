import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:velo_toulouse/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;

  final stations = [
    {
      'name': 'Old Market Station',
      'location': GeoPoint(13.3615, 103.8590),
      'totalSlots': 10,
      'bikeCount': 6,
    },
    {
      'name': 'Pub Street Station',
      'location': GeoPoint(13.3610, 103.8610),
      'totalSlots': 10,
      'bikeCount': 5,
    },
    {
      'name': 'Angkor Night Market',
      'location': GeoPoint(13.3600, 103.8600),
      'totalSlots': 10,
      'bikeCount': 4,
    },
    {
      'name': 'Wat Bo Station',
      'location': GeoPoint(13.3590, 103.8580),
      'totalSlots': 10,
      'bikeCount': 7,
    },
    {
      'name': 'Royal Residence Station',
      'location': GeoPoint(13.3620, 103.8570),
      'totalSlots': 10,
      'bikeCount': 3,
    },
  ];

  for (var stationData in stations) {
    final int totalSlots = stationData['totalSlots'] as int;
    final int bikeCount = stationData['bikeCount'] as int;

    // Create station
    final stationRef = await firestore.collection('stations').add({
      'name': stationData['name'],
      'location': stationData['location'],
      'totalSlots': totalSlots,
      'bikeCount': bikeCount,
      'availableSlots': totalSlots - bikeCount,
    });

    print("Added station ${stationData['name']}");

    // Create bikes for the station
    for (int i = 0; i < bikeCount; i++) {
      final bikeRef = await firestore.collection('bikes').add({
        'status': 'available',
        'currentStationId': stationRef.id,
      });

      print("Added bike ${bikeRef.id} to ${stationData['name']}");
    }
  }

  print("Seeding completed 🚲");
}