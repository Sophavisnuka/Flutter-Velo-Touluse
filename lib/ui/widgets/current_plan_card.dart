import 'package:flutter/material.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';

class CurrentPlanCard extends StatelessWidget {
  const CurrentPlanCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primary.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('Current Plan', style: TextStyle(fontSize: 12, color: AppTheme.primary)),
          Text('Day Pass', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppTheme.primary)),
        ],
      ),
    );
  }
}