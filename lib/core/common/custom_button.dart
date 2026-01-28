import 'package:flutter/material.dart';

import 'colors.dart';
import 'fontstyles.dart';

class CustomButton extends StatelessWidget {
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final IconData? icon;
  final String text;
  final bool disabled;
  final VoidCallback? onTap;
  const CustomButton({
    super.key,
    this.icon,
    this.textColor,
    this.backgroundColor = accentOrangeMain,
    this.borderColor,
    required this.text,
    this.disabled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isNeutralBg =
        backgroundColor == neutral10 || backgroundColor == neutral10Light;
    return InkWell(
      onTap: !disabled ? onTap : null,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: !disabled ? backgroundColor : context.neutral30,
          borderRadius: BorderRadius.circular(40),
          border: borderColor != null
              ? Border.all(color: borderColor!)
              : (isNeutralBg ? Border.all(color: context.neutral30) : null),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color:
                    textColor ??
                    (isNeutralBg ? context.neutral100 : context.neutral10),
                size: 20,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: mediumTS.copyWith(
                fontSize: 16,
                color:
                    textColor ??
                    (isNeutralBg ? context.neutral100 : context.neutral10),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomLoadingButton extends StatelessWidget {
  final Color backgroundColor;
  const CustomLoadingButton({
    super.key,
    this.backgroundColor = accentOrangeMain,
  });

  @override
  Widget build(BuildContext context) {
    final isNeutralBg =
        backgroundColor == neutral10 || backgroundColor == neutral10Light;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(40),
        border: isNeutralBg ? Border.all(color: context.neutral30) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 23,
            width: 23,
            child: CircularProgressIndicator(
              color: isNeutralBg ? context.neutral30 : context.neutral10,
            ),
          ),
        ],
      ),
    );
  }
}
