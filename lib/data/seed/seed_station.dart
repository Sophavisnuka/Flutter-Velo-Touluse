import 'dart:io';
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
      'availableBike': 6,
      'availableSlots': 4,
    },
    {
      'name': 'Pub Street Station',
      'location': GeoPoint(13.3610, 103.8610),
      'availableBike': 5,
      'availableSlots': 5,
    },
    {
      'name': 'Angkor Night Market',
      'location': GeoPoint(13.3600, 103.8600),
      'availableBike': 4,
      'availableSlots': 6,
    },
    {
      'name': 'Wat Bo Station',
      'location': GeoPoint(13.3590, 103.8580),
      'availableBike': 7,
      'availableSlots': 3,
    },
    {
      'name': 'Royal Residence Station',
      'location': GeoPoint(13.3620, 103.8570),
      'availableBike': 3,
      'availableSlots': 7,
    },
  ];

  for (int i = 0; i < stations.length; i++) {
    final stationData = stations[i];
    final stationId = 'station_${i + 1}';
    final int availableBike = stationData['availableBike'] as int;
    final int availableSlots = stationData['availableSlots'] as int;
    final int totalSlots = availableBike + availableSlots;

    // Overwrite station document
    await firestore.collection('stations').doc(stationId).set({
      'name': stationData['name'],
      'location': stationData['location'],
      'availableBike': availableBike,
      'availableSlots': availableSlots,
    });

    print("Added station $stationId: ${stationData['name']}");

    // Delete old slots first
    final existingSlots = await firestore
        .collection('stations')
        .doc(stationId)
        .collection('slots')
        .get();

    for (final doc in existingSlots.docs) {
      await doc.reference.delete();
    }

    print("Cleared old slots for $stationId");

    // Create new slots
    for (int j = 1; j <= totalSlots; j++) {
      await firestore
          .collection('stations')
          .doc(stationId)
          .collection('slots')
          .doc('slot_$j')
          .set({
        'slotNumber': j,
        'hasBike': j <= availableBike,
      });
      print("Added slot_$j to $stationId");
    }
  }

  print("Seeding completed 🚲");
  exit(0);
}