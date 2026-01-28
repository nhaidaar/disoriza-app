import 'package:disoriza/core/common/fontstyles.dart';
import 'package:flutter/material.dart';

import 'package:disoriza/core/common/colors.dart';

class AktivitasmuCategory extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  const AktivitasmuCategory({
    super.key,
    required this.title,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: InkWell(
        onTap: onTap,
        splashColor: isSelected ? accentOrangePressed : context.neutral50,
        highlightColor: isSelected ? accentOrangePressed : context.neutral50,
        borderRadius: BorderRadius.circular(40),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: isSelected ? accentOrangeMain : context.neutral10,
          ),
          child: Text(
            title,
            style: mediumTS.copyWith(color: isSelected ? context.neutral10 : context.neutral70),
          ),
        ),
      ),
    );
  }
}
