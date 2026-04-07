import 'package:flutter/material.dart';

class StationMarker extends StatelessWidget {
  final String name;
  final int totalSlots;
  final String status;

  const StationMarker({
    super.key,
    required this.name,
    required this.totalSlots,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = status == 'active';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Total slots
                  const Icon(Icons.local_parking, size: 12, color: Colors.deepOrange),
                  const SizedBox(width: 2),
                  Text(
                    '$totalSlots slots',
                    style: const TextStyle(fontSize: 10, color: Colors.deepOrange),
                  ),
                  const SizedBox(width: 6),
                  // Status dot
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    status,
                    style: TextStyle(
                      fontSize: 10,
                      color: isActive ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        // Pin pointer triangle
        CustomPaint(
          size: const Size(12, 6),
          painter: _TrianglePainter(),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
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