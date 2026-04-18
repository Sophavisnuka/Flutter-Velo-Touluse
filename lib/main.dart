import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/config/map_box_config.dart';
import 'package:velo_toulouse/data/repositories/ride_history/ride_history_repository.dart';
import 'package:velo_toulouse/data/repositories/stations/station_repository.dart';
import 'package:velo_toulouse/data/repositories/users/user_repository.dart';
import 'package:velo_toulouse/data/storages/local_user_storage.dart';
import 'package:velo_toulouse/ui/my_app.dart';
import 'package:velo_toulouse/ui/screens/history_screen/view_models/ride_history_view_model.dart';
import 'package:velo_toulouse/ui/screens/map_screen/view_models/map_view_model.dart';
import 'package:velo_toulouse/ui/services/navigation_service.dart';
import 'package:velo_toulouse/ui/services/notification_service.dart';
import 'package:velo_toulouse/ui/states/user_global_state.dart';
import 'package:velo_toulouse/ui/states/trip_global_state.dart';
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
  final userId = await LocalUserStorage.getOrCreateUserId();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => StationRepository(firestore: firestore)),
        Provider(create: (_) => RideHistoryRepository(firestore: firestore)),
        ChangeNotifierProvider(create: (_) => NavigationService()),
        ChangeNotifierProvider(create: (_) => NotificationService()),
        ChangeNotifierProvider(create: (ctx) => MapViewModel(
          repo: ctx.read<StationRepository>())
        ),
        ChangeNotifierProvider(create: (ctx) => TripGlobalState(
          userId: userId,
          rideHistoryRepository: ctx.read<RideHistoryRepository>(),
        )),
        ChangeNotifierProvider(create: (ctx) => RideHistoryViewModel(
          userId: userId,
          repository: ctx.read<RideHistoryRepository>(),
        )),
        ChangeNotifierProvider(
          create: (ctx) => UserGlobalState(
            UserRepository(firestore: firestore),
          )..loadUser(userId),
        ),
      ],
      child: DevicePreview(
        enabled: true,
        builder: (context) => MyApp(),
      ),
    )
  );
}