import 'package:flutter/material.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Temporary mock data — swap this out when plan logic is added
  final String planName = 'Monthly Pass';
  final String planStatus = 'Active';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 20,
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Ronan the best',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // "Currently active" header
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 14,
                              color: Colors.green.shade600,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'CURRENTLY ACTIVE',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.green.shade600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Plan row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(
                                    Icons.calendar_month,
                                    size: 22,
                                    color: Colors.deepOrange.shade400,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  planName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                planStatus,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}