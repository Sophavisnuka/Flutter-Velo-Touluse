import 'package:flutter/material.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';

class StationMarker extends StatelessWidget {
  final int availableBike;

  const StationMarker({
    super.key,
    required this.availableBike,
  });

  Color get _markerColor {
    if (availableBike == 0) return Color(0xFF9E9E9E);
    if (availableBike <= 5) return AppTheme.secondary;
    if (availableBike > 5) return AppTheme.primary; 
    return AppTheme.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _markerColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _markerColor.withOpacity(0.4),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(
                Icons.directions_bike,
                color: Colors.white,
                size: 26,
              ),
              // Bike count badge — top right
              Positioned(
                top: -25,
                right: -10,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: _markerColor, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$availableBike',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: _markerColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Pin triangle
        CustomPaint(
          size: const Size(12, 6),
          painter: _TrianglePainter(color: _markerColor),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  const _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}