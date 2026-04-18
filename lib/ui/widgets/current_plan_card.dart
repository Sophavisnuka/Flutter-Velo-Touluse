import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/ui/states/user_global_state.dart';

class CurrentPlanCard extends StatelessWidget {
  const CurrentPlanCard({
    super.key,
    this.color,
    this.bgColor,
    this.onTap,
  });

  final Color? color;
  final Color? bgColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<UserGlobalState>();

    if (viewModel.isLoading || viewModel.user == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.15),
          borderRadius: BorderRadius.circular(15),
        ),
        child: const SizedBox(
          width: 60,
          height: 14,
          child: LinearProgressIndicator(
            backgroundColor: Colors.transparent,
            color: Colors.grey,
          ),
        ),
      );
    }

    final pass = viewModel.currentPass;

    final card = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: (bgColor ?? pass.color).withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(pass.icon, size: 14, color: color ?? pass.color),
          const SizedBox(width: 6),
          Text(
            pass.label,
            style: TextStyle(
              color: color ?? pass.color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          if (onTap != null) ...[
            const SizedBox(width: 4),
            Icon(Icons.chevron_right, size: 14, color: color ?? pass.color),
          ],
        ],
      ),
    );

    if (onTap == null) return card;

    return GestureDetector(
      onTap: onTap,
      child: card,
    );
  }
}
