import 'package:flutter/material.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/view/select_pass_card.dart';

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
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.deepOrange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // important
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Current Plan', style: TextStyle(fontSize: 12, color: Colors.deepOrange)),
                    Text('Day Pass', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.deepOrange[800])),
                  ],
                ),
              ),
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