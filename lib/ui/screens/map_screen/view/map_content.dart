import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/model/station.dart';
import 'package:velo_toulouse/ui/screens/bike_screen/bike_screen.dart';
import 'package:velo_toulouse/ui/screens/map_screen/view/widgets/map_legend.dart';
import 'package:velo_toulouse/ui/screens/map_screen/view_models/map_view_model.dart';
import 'package:velo_toulouse/ui/screens/map_screen/view/widgets/station_marker.dart';
import 'package:velo_toulouse/ui/screens/map_screen/view/widgets/station_popup.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';
import 'package:velo_toulouse/ui/widgets/current_plan_card.dart';

class MapContent extends StatefulWidget {
  const MapContent({super.key});

  @override
  State<MapContent> createState() => _MapContentState();
}

class _MapContentState extends State<MapContent> {
  bool _initialized = false;
  bool _navigatingToDetails = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      context.read<MapViewModel>().loadStation();
    }
  }

  void _showStationPopup(Station station) {
    final viewModel = context.read<MapViewModel>();

    // Center the station between the search bar (~200px from top) and the popup (~260px from bottom).
    // Camera shift = (popupHeight - topAreaHeight) / 2
    const topAreaHeight = 200.0;
    final popupEstimatedHeight = 260.0 + MediaQuery.of(context).padding.bottom;
    final cameraShiftDown =
        ((popupEstimatedHeight - topAreaHeight) / 2).clamp(20.0, 200.0);
    viewModel.selectStation(station, cameraShiftDown: cameraShiftDown);

    // Use a transparent modal barrier so the selected marker (rendered in the
    // Stack above our custom dark overlay) is not covered by the Navigator-level barrier.
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      builder: (_) => StationDetailPopup(
        stations: station,
        onViewDetails: () {
          _navigatingToDetails = true;
          Navigator.pop(context);
          Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (_) => BikeScreen(station: station),
              ))
              .then((_) {
            _navigatingToDetails = false;
            if (mounted && viewModel.selectedStation != null) {
              _showStationPopup(viewModel.selectedStation!);
            }
          });
        },
        onGetDirections: () {
          Navigator.pop(context);
        },
      ),
    ).then((_) {
      if (!_navigatingToDetails && mounted) {
        viewModel.clearSelectedStation();
      }
    });
  }

  /// Renders the selected marker as a Positioned widget above the dark overlay
  /// so it appears fully colored while everything else is dimmed.
  List<Widget> _buildSelectedMarkerOverlay(MapViewModel viewModel) {
    final selected = viewModel.selectedStation;
    if (selected == null) return [];

    try {
      final screenOffset = viewModel.mapController.camera.latLngToScreenOffset(
        LatLng(selected.location.latitude, selected.location.longitude),
      );

      const markerWidth = 130.0;
      const markerHeight = 70.0;

      return [
        Positioned(
          left: screenOffset.dx - markerWidth / 2,
          top: screenOffset.dy - markerHeight / 2,
          width: markerWidth,
          height: markerHeight,
          // IgnorePointer: the modal barrier (above this layer) handles
          // tap-to-dismiss, so we don't need this marker to absorb taps.
          child: IgnorePointer(
            child: StationMarker(
              availableBike: selected.availableBike,
              isSelected: true,
            ),
          ),
        ),
      ];
    } catch (_) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MapViewModel>();
    final mapAccessToken = dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';
    final hasSelection = viewModel.selectedStation != null;

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
              urlTemplate:
                  'https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}?access_token={accessToken}',
              additionalOptions: {
                'accessToken': mapAccessToken,
              },
            ),
            // Exclude the selected station — it is rendered separately above the overlay.
            MarkerLayer(
              markers: viewModel.stations
                  .where((s) =>
                      !hasSelection ||
                      s.stationId != viewModel.selectedStation!.stationId)
                  .map((station) => Marker(
                        point: LatLng(
                          station.location.latitude,
                          station.location.longitude,
                        ),
                        width: 130,
                        height: 70,
                        child: GestureDetector(
                          onTap: () => _showStationPopup(station),
                          child: StationMarker(
                            availableBike: station.availableBike,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),

        // Dark overlay — covers the map and all non-selected markers.
        if (hasSelection)
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),

        // Selected marker rendered above the dark overlay so it stays fully colored.
        ..._buildSelectedMarkerOverlay(viewModel),

        // Map Legend
        Positioned(
          bottom: 95,
          left: 16,
          child: MapLegend(),
        ),

        // Search UI
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
        crossAxisAlignment: CrossAxisAlignment.end,
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

          // Current Plan (right aligned under search)
          CurrentPlanCard(
            bgColor: AppTheme.primary,
            color: AppTheme.surface,
          ),

          const SizedBox(height: 10),

          // Search Result List
          if (viewModel.filteredStations.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(10),
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
