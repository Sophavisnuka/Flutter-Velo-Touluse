import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/ui/screens/history_screen/view/widgets/ride_card.dart';
import 'package:velo_toulouse/ui/screens/history_screen/view_models/ride_history_view_model.dart';
import 'package:velo_toulouse/ui/widgets/current_plan_card.dart';

class RideHistoryContent extends StatefulWidget {
  const RideHistoryContent({super.key});

  @override
  State<RideHistoryContent> createState() => _RideHistoryContentState();
}

class _RideHistoryContentState extends State<RideHistoryContent> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<RideHistoryViewModel>().loadRides());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload every time user navigates back to this screen
    Future.microtask(() => context.read<RideHistoryViewModel>().loadRides());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Ride History', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CurrentPlanCard(),
          ),
        ],
      ),
      body: Consumer<RideHistoryViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.rides.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.directions_bike, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text('No rides yet', style: TextStyle(fontSize: 16, color: Colors.grey.shade500)),
                  const SizedBox(height: 8),
                  Text('Your ride history will appear here', style: TextStyle(fontSize: 13, color: Colors.grey.shade400)),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: ListView.builder(
              itemCount: vm.rides.length,
              itemBuilder: (context, index) => RideCard(ride: vm.rides[index]),
            ),
          );
        },
      ),
    );
  }
}