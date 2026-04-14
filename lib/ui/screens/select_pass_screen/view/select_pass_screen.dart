import 'package:flutter/material.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/view/select_pass_card.dart';
import 'package:velo_toulouse/ui/theme/theme.dart';
import 'package:velo_toulouse/ui/widgets/current_plan_card.dart';

class SelectPassScreen extends StatelessWidget {
  const SelectPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 241, 241),
      appBar: AppBar(
        title: Text(
          'Your pass',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: CurrentPlanCard(
              bgColor: AppTheme.primary.withOpacity(0.15),
              color: AppTheme.primary
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: ListView(
          children: [
            SelectPassCard(type: PassType.day, isCurrent: true,),
            SelectPassCard(type: PassType.monthly,),
            SelectPassCard(type: PassType.yearly,),
          ],
        ),
      ),
    );
  }
}