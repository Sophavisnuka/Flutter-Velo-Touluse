import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:velo_toulouse/firebase_options.dart';
import 'package:flutter/widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;

  // Example stations in Siem Reap (Krong Siem Reap)
  final stations = [
    {
      'name': 'Old Market Station',
      'location': GeoPoint(13.3615, 103.8590),
      'totalSlots': 5,
      'status': 'active',
    },
    {
      'name': 'Pub Street Station',
      'location': GeoPoint(13.3610, 103.8610),
      'totalSlots': 5,
      'status': 'active',
    },
    {
      'name': 'Angkor Night Market',
      'location': GeoPoint(13.3600, 103.8600),
      'totalSlots': 5,
      'status': 'active',
    },
    {
      'name': 'Wat Bo Station',
      'location': GeoPoint(13.3590, 103.8580),
      'totalSlots': 5,
      'status': 'active',
    },
    {
      'name': 'Royal Residence Station',
      'location': GeoPoint(13.3620, 103.8570),
      'totalSlots': 5,
      'status': 'active',
    },
  ];

  for (var stationData in stations) {
  // Add station
  final stationRef = await firestore.collection('stations').add(stationData);
  print('Added station ${stationData['name']} with ID: ${stationRef.id}');

  // Add bikes for this station
  final totalSlots = stationData['totalSlots'] as int;
  for (int i = 1; i <= totalSlots; i++) {
    final bikeData = {
      'status': 'available',
      'currentStationId': stationRef.id,
    };
    final bikeRef = await firestore.collection('bikes').add(bikeData);
    print('Added bike ${bikeRef.id} to ${stationData['name']}');
  }
}

  print('Seeding complete!');
}