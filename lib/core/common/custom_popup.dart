import 'package:flutter/material.dart';

import 'colors.dart';
import 'effects.dart';
import 'fontstyles.dart';

class CustomPopup extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool isLoading;
  final Color loadingColor;
  final Color loadingBackgroundColor;
  const CustomPopup({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.actions,
    this.isLoading = false,
    this.loadingColor = successMain,
    this.loadingBackgroundColor = successBorder,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: defaultSmoothRadius,
      ),
      backgroundColor: context.neutral10,
      surfaceTintColor: context.neutral10,
      titlePadding: const EdgeInsets.all(12),
      title: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: defaultSmoothRadius,
          color: context.backgroundCanvas,
        ),
        child: Column(
          children: [
            // Custom Icon
            Icon(
              icon,
              color: iconColor,
              size: 24,
            ),

            const SizedBox(height: 8),

            // Message Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: mediumTS.copyWith(fontSize: 18, color: context.neutral100),
            ),

            if (subtitle != null) ...[
              const SizedBox(height: 8),

              // Message subtitle
              Text(
                subtitle.toString(),
                textAlign: TextAlign.center,
                style: mediumTS.copyWith(fontSize: 14, color: context.neutral90),
              ),
            ],

            if (isLoading) ...[
              const SizedBox(height: 12),

              // Loading
              LinearProgressIndicator(
                color: loadingColor,
                backgroundColor: loadingBackgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
            ],
          ],
        ),
      ),

      // Actions (maybe some button)
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.all(8),
      actions: actions,
    );
  }
}
