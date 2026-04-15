import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/config/map_box_config.dart';
import 'package:velo_toulouse/data/repositories/station_repository.dart';
import 'package:velo_toulouse/ui/my_app.dart';
import 'package:velo_toulouse/ui/screens/bike_screen/view_models/bike_view_model.dart';
import 'package:velo_toulouse/ui/screens/map_screen/view_models/map_view_model.dart';
import 'package:velo_toulouse/ui/states/pass_provider.dart';
import 'firebase_options.dart';

const bool enableDevicePreview = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  final token = MapBoxConfig.mapboxToken;
  if (token.isEmpty) {
    throw Exception('Missing MAPBOX_ACCESS_TOKEN in .env file');
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;
  final StationRepository stationRepo = StationRepository(firestore: firestore);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MapViewModel(repo: stationRepo)),
        ChangeNotifierProvider(create: (_) => BikeViewModel(repo: stationRepo)),
        ChangeNotifierProvider(create: (_) => PassProvider()),
      ],
      child: DevicePreview(
        enabled: true,
        builder: (context) => MyApp(),
      ),
    ),
  );
}