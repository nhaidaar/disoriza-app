import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/fontstyles.dart';

class RiwayatDetailCard extends StatelessWidget {
  final AutoScrollController controller;
  final int index;
  final String title;
  final String content;
  const RiwayatDetailCard({
    super.key,
    required this.controller,
    required this.index,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AutoScrollTag(
      key: ValueKey(index),
      controller: controller,
      index: index,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: context.neutral10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: mediumTS.copyWith(color: context.neutral70),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: mediumTS.copyWith(color: context.neutral90),
            ),
          ],
        ),
      ),
    );
  }
}
