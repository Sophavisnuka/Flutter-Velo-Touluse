import 'package:flutter/material.dart';
import 'package:velo_toulouse/model/slot.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';
import 'package:velo_toulouse/ui/widgets/slide_to_action.dart';

class ReleaseConfirmationSheet extends StatefulWidget {
  final Slot slot;
  final String stationName;
  final VoidCallback onSlideComplete;
  final VoidCallback onCancel;

  const ReleaseConfirmationSheet({
    super.key,
    required this.slot,
    required this.stationName,
    required this.onSlideComplete,
    required this.onCancel,
  });

  @override
  State<ReleaseConfirmationSheet> createState() =>
      _ReleaseConfirmationSheetState();
}

class _ReleaseConfirmationSheetState extends State<ReleaseConfirmationSheet> {
  // Changing this key recreates the SlideToAction, resetting it to initial state.
  Key _sliderKey = UniqueKey();

  void _onSlide() {
    showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Confirm Release',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6A7282),
              height: 1.5,
            ),
            children: [
              const TextSpan(text: 'Unlock '),
              TextSpan(
                text: 'Slot #${widget.slot.slotNumber}',
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
                  text: '? You will have 20 seconds to take the bike out.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF6A7282),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Yes, Release'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true) {
        widget.onSlideComplete();
      } else {
        // Reset the slider so the user can try again.
        setState(() => _sliderKey = UniqueKey());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, 20 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 50,
            offset: Offset(0, 25),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 48,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Slot info row
          Row(
            children: [
              Container(
                width: 64,
                height: 74,
                decoration: BoxDecoration(
                  color: AppTheme.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.directions_bike_rounded,
                        color: Colors.white, size: 20),
                    const SizedBox(height: 6),
                    Text(
                      '#${widget.slot.slotNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 74,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Slot #${widget.slot.slotNumber}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF101828),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: const Text(
                              'Standard',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF4A5565),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Available',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF00A63E),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          const Text(
            'Release this bike?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF101828),
            ),
          ),
          const SizedBox(height: 8),

          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF6A7282),
                height: 1.5,
              ),
              children: [
                TextSpan(text: 'Slot #${widget.slot.slotNumber} at '),
                TextSpan(
                  text: widget.stationName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF364153),
                  ),
                ),
                const TextSpan(
                    text: " will unlock. Make sure you're ready to ride."),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Slide to release — key changes on cancel to reset the widget
          SlideToAction(
            key: _sliderKey,
            label: 'Slide to release  >>>',
            trackColor: AppTheme.primary,
            onSlideComplete: _onSlide,
          ),
          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: widget.onCancel,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFF3F4F6),
                foregroundColor: const Color(0xFF364153),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
