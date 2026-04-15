import 'package:flutter/material.dart';

class SlideToAction extends StatefulWidget {
  final String label;
  final Color trackColor;
  final Color thumbColor;
  final VoidCallback onSlideComplete;

  const SlideToAction({
    super.key,
    required this.label,
    required this.onSlideComplete,
    this.trackColor = const Color(0xFFFF5722),
    this.thumbColor = Colors.white,
  });

  @override
  State<SlideToAction> createState() => _SlideToActionState();
}

class _SlideToActionState extends State<SlideToAction> {
  double _dragPosition = 0;
  bool _completed = false;

  static const double _trackHeight = 64;
  static const double _thumbSize = 52;
  static const double _threshold = 0.9;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final trackWidth = constraints.maxWidth;
        final maxDrag = trackWidth - _thumbSize - 12;
        final progress = _dragPosition / maxDrag;

        return GestureDetector(
          onHorizontalDragUpdate: _completed
              ? null
              : (details) {
                  setState(() {
                    _dragPosition =
                        (_dragPosition + details.delta.dx).clamp(0.0, maxDrag);
                  });
                  if (_dragPosition / maxDrag >= _threshold) {
                    setState(() => _completed = true);
                    widget.onSlideComplete();
                  }
                },
          onHorizontalDragEnd: _completed
              ? null
              : (_) {
                  if (_dragPosition / maxDrag < _threshold) {
                    setState(() => _dragPosition = 0);
                  }
                },
          child: Container(
            height: _trackHeight,
            decoration: BoxDecoration(
              color: widget.trackColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(_trackHeight / 2),
              border: Border.all(
                color: widget.trackColor.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                // Filled progress bar
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_trackHeight / 2),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: ((_dragPosition + _thumbSize / 2) / trackWidth)
                          .clamp(0.0, 1.0),
                      child: Container(color: widget.trackColor.withOpacity(0.25)),
                    ),
                  ),
                ),

                // Label text (fades as thumb moves)
                Center(
                  child: Opacity(
                    opacity: (1 - progress * 2).clamp(0.0, 1.0),
                    child: Text(
                      _completed ? 'Released!' : widget.label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: widget.trackColor,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),

                // Thumb
                Positioned(
                  left: 6 + _dragPosition,
                  top: (_trackHeight - _thumbSize) / 2,
                  child: Container(
                    width: _thumbSize,
                    height: _thumbSize,
                    decoration: BoxDecoration(
                      color: _completed ? widget.trackColor : widget.thumbColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.trackColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _completed
                          ? Icons.check_rounded
                          : Icons.directions_bike_rounded,
                      color: _completed ? Colors.white : widget.trackColor,
                      size: 24,
                    ),
                  ),
                ),

                // Arrow chevrons on the right (fade in as thumb moves right)
                Positioned(
                  right: 16,
                  top: 0,
                  bottom: 0,
                  child: Opacity(
                    opacity: (1 - progress * 2).clamp(0.0, 1.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chevron_right,
                            color: widget.trackColor.withOpacity(0.4), size: 20),
                        Icon(Icons.chevron_right,
                            color: widget.trackColor.withOpacity(0.6), size: 20),
                        Icon(Icons.chevron_right,
                            color: widget.trackColor.withOpacity(0.8), size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
