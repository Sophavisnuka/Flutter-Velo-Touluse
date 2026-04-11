import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/ui/screens/map_screen/view_models/map_view_model.dart';

class BikeScreen extends StatelessWidget {
  const BikeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<MapViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: Text('Station'),
      ),
    );
  }
}