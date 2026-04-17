import 'package:flutter/material.dart';
import 'package:velo_toulouse/model/pass_type.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';
import 'package:velo_toulouse/util/formatter.dart';

class PassActivatedScreen extends StatefulWidget {
  final PassType newPass;
  final DateTime activatedAt;
  final bool fromBikeFlow;

  const PassActivatedScreen({
    super.key,
    required this.newPass,
    required this.activatedAt,
    this.fromBikeFlow = false,
  });

  @override
  State<PassActivatedScreen> createState() => _PassActivatedScreenState();
}

class _PassActivatedScreenState extends State<PassActivatedScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _checkScale;
  late final Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _checkScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.65, curve: Curves.elasticOut),
    );

    _contentFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.55, 1.0, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expiresAt = widget.newPass.expiresAt(widget.activatedAt);
    final expiryText = Formatter.expiry(expiresAt);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated checkmark
              ScaleTransition(
                scale: _checkScale,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.green,
                    size: 64,
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Fading content
              FadeTransition(
                opacity: _contentFade,
                child: Column(
                  children: [
                    const Text(
                      'Pass Activated!',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your ${widget.newPass.label} is now active. Enjoy your ride!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 32),

                    // Pass detail card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: widget.newPass.color.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: widget.newPass.color.withOpacity(0.25),
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(widget.newPass.icon,
                              color: widget.newPass.color, size: 36),
                          const SizedBox(height: 10),
                          Text(
                            widget.newPass.label,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 13, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Text(
                                'Activated: ${Formatter.expiry(widget.activatedAt)}',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.event_busy,
                                  size: 13, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Text(
                                'Expires: $expiryText',
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 36),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (widget.fromBikeFlow) {
                            // Pop PassActivatedScreen + SelectPassScreen to land on BikeScreen
                            int count = 0;
                            Navigator.of(context).popUntil((_) => count++ >= 2);
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          widget.fromBikeFlow ? 'Release My Bike' : 'Start Riding',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
