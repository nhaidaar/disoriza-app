import 'package:flutter/material.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../common/colors.dart';
import '../common/effects.dart';
import '../common/fontstyles.dart';

void showSnackbar(
  BuildContext context, {
  required String message,
  bool isError = false,
}) async {
  AnimatedSnackBar(
    duration: const Duration(seconds: 3),
    mobileSnackBarPosition: MobileSnackBarPosition.bottom,
    desktopSnackBarPosition: DesktopSnackBarPosition.topCenter,
    builder: (snackBarContext) {
      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: defaultSmoothRadius,
          border: Border.all(color: context.neutral30),
          color: context.neutral10,
          boxShadow: const [shadowEffect1],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              !isError ? IconsaxPlusBold.tick_circle : IconsaxPlusBold.close_circle,
              color: !isError ? successMain : dangerMain,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: mediumTS.copyWith(fontSize: 14, color: context.neutral100),
              ),
            ),
          ],
        ),
      );
    },
  ).show(context);
}
