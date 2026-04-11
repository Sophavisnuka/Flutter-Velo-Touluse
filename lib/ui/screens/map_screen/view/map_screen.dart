import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/model/station.dart';
import 'package:velo_toulouse/ui/screens/bike_screen/view/bike_screen.dart';
import 'package:velo_toulouse/ui/screens/map_screen/view/widgets/map_legend.dart';
import 'package:velo_toulouse/ui/screens/map_screen/view_models/map_view_model.dart';
import 'package:velo_toulouse/ui/screens/map_screen/view/widgets/station_marker.dart';
import 'package:velo_toulouse/ui/screens/map_screen/view/widgets/station_popup.dart';
import 'package:velo_toulouse/ui/widgets/current_plan_card.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _initialized = false;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      context.read<MapViewModel>().loadStation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MapViewModel>();
    final mapAccessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';

    void showStationPopup(BuildContext context, Station station) {
      showModalBottomSheet(
        showDragHandle: true,
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => StationDetailPopup(
          stations: station,
          onViewDetails: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BikeScreen(station: station),
              ),
            );
          },
          onGetDirections: () {
            Navigator.pop(context);
          },
        ),
      );
    }

    return Stack(
      children: [
        FlutterMap(
          mapController: viewModel.mapController,
          options: const MapOptions(
            initialCenter: LatLng(13.3615, 103.8590),
            initialZoom: 14,
          ),
          children: [
            TileLayer(
              urlTemplate:'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}?access_token={accessToken}',
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
                  child: GestureDetector(
                    onTap: () {
                      showStationPopup(context, station);
                    },
                    child: StationMarker(
                      availableBike: station.availableBike
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        // Map Legend
        Positioned(
          bottom: 95,
          left: 16,
          child: MapLegend(),
        ),
        // search UI
        _buildSearchUI(viewModel),
      ],
    );
  }

  Widget _buildSearchUI(MapViewModel viewModel) {
    return Positioned(
      top: 70,
      left: 16,
      right: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end, // align right
        children: [
          // Search Bar (full width)
          Material(
            elevation: 1,
            borderRadius: BorderRadius.circular(30),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search station or location",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                viewModel.filterStations(value);
              },
            ),
          ),

          const SizedBox(height: 10),

          //Current Plan (right aligned under search)
          CurrentPlanCard(),

          const SizedBox(height: 10),

          // Search Result List
          if (viewModel.filteredStations.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                primary: false,
                shrinkWrap: true,
                itemCount: viewModel.filteredStations.length,
                itemBuilder: (context, index) {
                  final station = viewModel.filteredStations[index];
                  return ListTile(
                    leading: const Icon(Icons.directions_bike),
                    title: Text(station.name),
                    onTap: () {
                      viewModel.moveToStation(station);
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}