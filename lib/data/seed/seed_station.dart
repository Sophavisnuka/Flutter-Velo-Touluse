import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:velo_toulouse/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;

  final stations = [
    {
      'name': 'Station 1',
      'location': GeoPoint(40.7128, -74.0060),
      'status': 'active',
    },
    {
      'name': 'Station 2',
      'location': GeoPoint(41.2033, -77.1945),
      'status': 'active',
    },
    {
      'name': 'Station 3',
      'location': GeoPoint(39.9526, -75.1652),
      'status': 'inactive',
    },
    {
      'name': 'Station 4',
      'location': GeoPoint(34.0522, -118.2437),
      'status': 'active',
    },
    {
      'name': 'Station 5',
      'location': GeoPoint(37.7749, -122.4194),
      'status': 'inactive',
    },
  ];

  for (int i = 0; i < stations.length; i++) {
    String docId = 'station_${i + 1}';
    await firestore.collection('stations').doc(docId).set(stations[i]);
    print('Added $docId');
  }

  print('All stations added successfully!');
}