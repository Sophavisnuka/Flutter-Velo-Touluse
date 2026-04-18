import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/model/slot.dart';
import 'package:velo_toulouse/ui/screens/map_screen/view_models/map_view_model.dart';
import 'package:velo_toulouse/ui/screens/trip_screen/trip_screen.dart';
import 'package:velo_toulouse/ui/screens/bike_screen/view_models/bike_view_model.dart';
import 'package:velo_toulouse/ui/states/trip_global_state.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';

class CountdownScreen extends StatefulWidget {
  final Slot slot;
  final String stationName;

  const CountdownScreen({
    super.key,
    required this.slot,
    required this.stationName,
  });

  @override
  State<CountdownScreen> createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen>
    with SingleTickerProviderStateMixin {
  static const int _totalSeconds = 20;
  int _remaining = _totalSeconds;
  Timer? _timer;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() => _remaining--);
      if (_remaining <= 0) {
        timer.cancel();
        _showTimerUpDialog();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _navigateToTripScreen() {
    _timer?.cancel();
    context.read<TripGlobalState>().startTrip(
          slot: widget.slot,
          stationName: widget.stationName,
        );
    context.read<MapViewModel>().clearSelectedStation();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const TripScreen()),
      (route) => route.isFirst,
    );
  }

  void _relockBike() async {
    _timer?.cancel();
    // Re-lock: revert the release
    final bikeVm = context.read<BikeViewModel>();
    final mapVm = context.read<MapViewModel>();
    await bikeVm.returnBike(widget.slot.slotId);
    if (bikeVm.selectedStation != null) {
      await mapVm.refreshStation(bikeVm.selectedStation!.stationId);
    }
    if (mounted) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  void _showTimerUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Did you take the bike?',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        content: const Text(
          'The slot has locked again. Let us know if you took the bike.',
          style: TextStyle(color: Color(0xFF6A7282), fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _relockBike();
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF6A7282),
            ),
            child: const Text('No, re-lock'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _navigateToTripScreen();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Yes, I have it"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _remaining / _totalSeconds;

    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 48),

              // Status label
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (_, __) => Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(
                              0.4 + 0.6 * _pulseController.value),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Slot Unlocked',
                      style: TextStyle(
                        color: AppTheme.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Countdown ring
              SizedBox(
                width: 200,
                height: 200,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox.expand(
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 10,
                        backgroundColor: const Color(0xFFE5E7EB),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _remaining > 5
                              ? AppTheme.primary
                              : Colors.redAccent,
                        ),
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$_remaining',
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: _remaining > 5
                                ? const Color(0xFF101828)
                                : Colors.redAccent,
                            height: 1,
                          ),
                        ),
                        const Text(
                          'seconds',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6A7282),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Title
              const Text(
                'Take your bike now!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF101828),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Slot info
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6A7282),
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(text: 'Slot '),
                    TextSpan(
                      text: '#${widget.slot.slotNumber}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF101828),
                      ),
                    ),
                    const TextSpan(text: ' at '),
                    TextSpan(
                      text: widget.stationName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF101828),
                      ),
                    ),
                    const TextSpan(
                        text:
                            ' is unlocked.\nPull the bike out before the timer runs out.'),
                  ],
                ),
              ),

              const Spacer(),

              // "I've taken my bike" button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _navigateToTripScreen,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.15),
                  ),
                  child: const Text(
                    "I've taken my bike",
                    style:
                        TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // "Actually, cancel" link
              TextButton(
                onPressed: _relockBike,
                child: const Text(
                  "Actually, re-lock the slot",
                  style: TextStyle(
                    color: Color(0xFF6A7282),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
