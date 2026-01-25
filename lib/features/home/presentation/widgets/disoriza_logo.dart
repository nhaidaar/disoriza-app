import 'package:flutter/material.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/effects.dart';

class DisorizaLogo extends StatelessWidget {
  const DisorizaLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: neutral10,
        boxShadow: const [shadowEffect0, shadowEffect1],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Image.asset(
        'assets/images/logo.png',
        scale: 3,
        color: accentGreenMain,
      ),
    );
  }
}
