import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/config/map_box_config.dart';
import 'package:velo_toulouse/ui/my_app.dart';
import 'package:velo_toulouse/ui/providers/bottom_nav_provider.dart';
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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BottomNavProvider(),
        )
      ],
      child: DevicePreview(
        enabled: true,
        builder: (context) => MyApp(),
      ),
    )
  );
}