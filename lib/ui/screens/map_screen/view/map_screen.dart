import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/model/station.dart';
import 'package:velo_toulouse/ui/screens/map_screen/view_models/map_view_model.dart';
import 'package:velo_toulouse/ui/screens/map_screen/view/station_marker.dart';
import 'package:velo_toulouse/ui/screens/map_screen/view/station_popup.dart';

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

  void _showStationPopup(BuildContext context, Station station) {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StationDetailPopup(
        stations: station, // you can calculate real distance if you want
        onViewDetails: () {
          Navigator.pop(context);
          // TODO: navigate to detailed station page
        },
        onGetDirections: () {
          Navigator.pop(context);
          // TODO: open navigation map / Google Maps
        },
      ),
    );
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
            final availableSlot = station.totalSlots - station.bikeCount;

            return Marker(
              point: LatLng(
                station.location.latitude,
                station.location.longitude,
              ),
              width: 130,
              height: 70,
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  _showStationPopup(context, station);
                },
                child: StationMarker(
                  name: station.name,
                  availableSlots: availableSlot,
                  availableBike: station.bikeCount,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}