import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/effects.dart';
import '../../../../core/common/fontstyles.dart';

class SetelanMenu extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool enableArrowRight;
  const SetelanMenu({
    super.key,
    required this.icon,
    this.iconColor,
    required this.title,
    this.subtitle,
    this.onTap,
    this.enableArrowRight = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: GestureDetector(
        onTap: onTap,
        // splashColor: context.neutral50,
        // highlightColor: context.neutral50,
        // customBorder: RoundedRectangleBorder(
        //   borderRadius: defaultSmoothRadius,
        // ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: defaultSmoothRadius,
            color: context.neutral10,
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: context.backgroundCanvas,
                child: Icon(
                  icon,
                  size: 20,
                  color: iconColor ?? context.neutral100,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: mediumTS.copyWith(
                        color: iconColor ?? context.neutral100,
                      ),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: mediumTS.copyWith(
                          fontSize: 12,
                          color: context.neutral60,
                        ),
                      ),
                  ],
                ),
              ),
              if (enableArrowRight)
                Icon(
                  IconsaxPlusLinear.arrow_right_3,
                  color: iconColor ?? context.neutral100,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
