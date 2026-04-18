import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velo_toulouse/model/pass_type.dart';
import 'package:velo_toulouse/ui/states/user_global_state.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/view/widgets/select_pass_card.dart';
import 'package:velo_toulouse/ui/widgets/current_plan_card.dart';

class SelectPassContent extends StatelessWidget {
  final bool fromBikeFlow;

  const SelectPassContent({super.key, this.fromBikeFlow = false});

  @override
  Widget build(BuildContext context) {
    final userViewModel = context.watch<UserGlobalState>();
    final user = userViewModel.user;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      appBar: AppBar(
        title: const Text(
          'Your pass',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CurrentPlanCard(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: ListView(
          children: PassType.values.where((type) => type != PassType.none).map((type) {
            final isCurrent = user?.passType == type;
            final expiresAt = isCurrent && user?.activatedAt != null
              ? type.expiresAt(user!.activatedAt!)
              : null;
            return SelectPassCard(
              type: type,
              isCurrent: isCurrent,
              expiresAt: expiresAt,
              fromBikeFlow: fromBikeFlow,
              onSwitch: (at) => userViewModel.switchPlan(type, activatedAt: at),
            );
          }).toList(),
        ),
      ),
    );
  }
}