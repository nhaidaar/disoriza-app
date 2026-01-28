import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/fontstyles.dart';
import '../../../auth/data/models/user_model.dart';
import '../pages/create_post_page.dart';

class CreatePostButton extends StatelessWidget {
  final UserModel user;
  const CreatePostButton({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.neutral10,
        border: Border.symmetric(
          horizontal: BorderSide(color: context.neutral40),
        ),
      ),
      child: GestureDetector(
        onTap: () => Get.to(() => CreatePostPage(user: user)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: context.backgroundCanvas,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Apa yang ingin kamu tanya atau bagikan?',
                style: mediumTS.copyWith(color: context.neutral70),
              ),

              const Icon(IconsaxPlusLinear.edit)
            ],
          ),
        ),
      ),
    );
  }
}
