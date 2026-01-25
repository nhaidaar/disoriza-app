import 'package:disoriza/core/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../utils/network_image.dart';

class CustomAvatar extends StatelessWidget {
  final String? link;
  final double radius;
  const CustomAvatar({super.key, this.link, this.radius = 20});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: context.neutral10,
      backgroundImage: link != null ? getImageProvider(link.toString()) : null,
      child: link == null
          ? Icon(
              IconsaxPlusLinear.profile,
              color: context.neutral100,
              size: radius * 1.2,
            )
          : null,
    );
  }
}
