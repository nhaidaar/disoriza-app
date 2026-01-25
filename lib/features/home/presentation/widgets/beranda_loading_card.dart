import 'package:card_loading/card_loading.dart';
import 'package:disoriza/core/common/colors.dart';
import 'package:flutter/material.dart';

class BerandaLoadingCard extends StatelessWidget {
  const BerandaLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CardLoading(
          height: 160,
          margin: const EdgeInsets.symmetric(horizontal: 14),
          borderRadius: BorderRadius.circular(16),
          cardLoadingTheme: CardLoadingTheme(
            colorOne: context.neutral30,
            colorTwo: context.neutral40,
          ),
        ),
        const SizedBox(height: 8),
        CardLoading(
          height: 16,
          width: 64,
          borderRadius: BorderRadius.circular(16),
          cardLoadingTheme: CardLoadingTheme(
            colorOne: context.neutral30,
            colorTwo: context.neutral40,
          ),
        ),
      ],
    );
  }
}
