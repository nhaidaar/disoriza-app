import 'package:flutter/material.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/fontstyles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: accentGreenMain,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', scale: 1.25),
            const SizedBox(height: 12),
            Text(
              'Disoriza',
              style: mediumTS.copyWith(fontSize: 32, color: neutral10),
            ),
          ],
        ),
      ),
    );
  }
}
