import 'package:flutter/material.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';

class BikeTile extends StatelessWidget {
  final int slotId;
  final bool hasBike;
  final VoidCallback? onRelease;

  const BikeTile({
    super.key,
    required this.slotId,
    required this.hasBike,
    this.onRelease,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200, width: 0.5),
      ),
      clipBehavior: Clip.hardEdge,
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left accent bar
            Container(
              width: 3,
              color: hasBike ? AppTheme.primary : Colors.grey.shade200,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Row(
                  children: [
                    // Bike icon
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: hasBike ? const Color(0xFFFAEEDA) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: Icon(
                        Icons.directions_bike_rounded,
                        size: 18,
                        color: hasBike ? AppTheme.primary : Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Slot info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Slot #$slotId',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: hasBike ? Colors.black87 : Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: hasBike ? AppTheme.secondary : Colors.grey.shade300,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                hasBike ? 'Bike ready' : 'No bike',
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Action button
                    hasBike ? GestureDetector(
                      onTap: onRelease,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppTheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Release',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                    )
                    : 
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300, width: 0.5),
                      ),
                      child: Text(
                        'Empty',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}