import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/data/repositories/ride_history_repository.dart';
import 'package:velo_toulouse/ui/screens/history_screen/view/history_content.dart';
import 'package:velo_toulouse/ui/screens/history_screen/view_models/ride_history_view_model.dart';
import 'package:velo_toulouse/ui/states/user_view_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userVM = context.watch<UserViewModel>();

    if (userVM.user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return ChangeNotifierProvider(
      create: (context) => RideHistoryViewModel(
        userId: userVM.user!.userId,
        repository: context.read<RideHistoryRepository>(),
      )..loadRides(),
      child: RideHistoryContent(),
    );
  }
}