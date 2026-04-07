import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/ui/screens/map_screen/view_models/map_view_model.dart';
import 'package:velo_toulouse/ui/widgets/station_marker.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MapViewModel>().loadStation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MapViewModel>();
    final mapAccessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';

    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(13.3615, 103.8590),
        initialZoom: 14,
      ),
      children: [
        TileLayer(
          urlTemplate:
            'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}?access_token={accessToken}',
          additionalOptions: {
            'accessToken': mapAccessToken,
          },
        ),
        MarkerLayer(
          markers: viewModel.stations.map((station) {
            return Marker(
              point: LatLng(
                station.location.latitude,
                station.location.longitude,
              ),
              width: 130,
              height: 70,
              alignment: Alignment.bottomCenter,
              child: StationMarker(
                name: station.name,
                totalSlots: station.totalSlots,
                status: station.status,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}