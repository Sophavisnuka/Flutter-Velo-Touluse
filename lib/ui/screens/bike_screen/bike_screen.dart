import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/data/repositories/station_repository.dart';
import 'package:velo_toulouse/model/station.dart';
import 'package:velo_toulouse/ui/screens/bike_screen/view/bike_content.dart';
import 'package:velo_toulouse/ui/screens/bike_screen/view_models/bike_view_model.dart';

class BikeScreen extends StatelessWidget {
  final Station station;

  const BikeScreen({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => BikeViewModel(
        repo: ctx.read<StationRepository>(),
      )..selectStation(station),
      child: BikeContent(stationName: station.name),
    );
  }
}