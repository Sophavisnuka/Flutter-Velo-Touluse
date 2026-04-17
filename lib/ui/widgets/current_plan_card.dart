import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/ui/states/user_view_model.dart'; // 👈 updated import

class CurrentPlanCard extends StatelessWidget {
  const CurrentPlanCard({
    super.key,
    this.color,
    this.bgColor
  });

  final Color? color;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {

    final viewModel = context.watch<UserViewModel>();

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

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: pass.color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(pass.icon, size: 14, color: pass.color),
          const SizedBox(width: 6),
          Text(
            pass.label,
            style: TextStyle(
              color: pass.color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}