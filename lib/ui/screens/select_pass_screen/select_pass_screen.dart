import 'package:flutter/material.dart';
import 'package:velo_toulouse/ui/screens/select_pass_screen/view/select_pass_content.dart';

class SelectPassScreen extends StatelessWidget {
  final bool fromBikeFlow;

  const SelectPassScreen({super.key, this.fromBikeFlow = false});

  @override
  Widget build(BuildContext context) {
    return SelectPassContent(fromBikeFlow: fromBikeFlow);
  }
}
