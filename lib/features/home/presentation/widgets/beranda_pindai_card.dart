import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/custom_button.dart';
import '../../../../core/common/fontstyles.dart';
import 'disoriza_logo.dart';

class BerandaPindaiCard extends StatelessWidget {
  final VoidCallback? onTap;
  const BerandaPindaiCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: const DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Logo
            const DisorizaLogo(),

            const SizedBox(height: 12),

            // Text
            Text(
              'Pindai dengan Disoriza AI ✨',
              style: mediumTS.copyWith(fontSize: 20, color: neutral10),
            ),
            const SizedBox(height: 4),
            Text(
              'Pindai untuk mengetahui penyakit pada padi.',
              style: mediumTS.copyWith(fontSize: 14, color: neutral10),
            ),

            const SizedBox(height: 24),

            // Button
            CustomButton(
              icon: IconsaxPlusBold.scan,
              text: 'Pindai',
              textColor: neutral10,
              onTap: onTap,
            ),
          ],
        ),
      ),
    );
  }
}
