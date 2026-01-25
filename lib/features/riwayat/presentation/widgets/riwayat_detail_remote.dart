import 'package:flutter/material.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/fontstyles.dart';

class RiwayatDetailRemote extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;
  const RiwayatDetailRemote({
    super.key,
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? accentOrangeMain : context.backgroundCanvas,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(
            title,
            style: mediumTS.copyWith(color: isActive ? context.neutral10 : context.neutral70),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
