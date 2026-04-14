import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/model/station.dart';
import 'package:velo_toulouse/ui/screens/bike_screen/view/bike_content.dart';
import 'package:velo_toulouse/ui/screens/bike_screen/view_models/bike_view_model.dart';

class BikeScreen extends StatelessWidget {
  final Station station;

  const BikeScreen({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    context.read<BikeViewModel>().selectStation(station);

    return BikeContent(stationName: station.name);
  }
}