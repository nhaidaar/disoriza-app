import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/effects.dart';
import '../../../../core/common/fontstyles.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/models/post_model.dart';
import '../pages/detail_post_page.dart';
import 'components/user_details.dart';

class ReportedPostCard extends StatelessWidget {
  final UserModel user;
  final PostModel post;

  const ReportedPostCard({
    super.key,
    required this.user,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => DetailPostPage(user: user, post: post)),
      child: Container(
        padding: const EdgeInsets.all(12),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: defaultSmoothRadius,
          border: Border.all(color: context.neutral30),
          color: context.neutral10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserDetails(
              profilePicture: post.author?.profilePicture,
              name: post.author != null ? post.author!.name.toString() : 'Disoriza User',
              isAdmin: post.author?.isAdmin ?? false,
              date: post.date,
            ),

            const SizedBox(height: 12),

            Text(
              post.title.toString(),
              style: semiboldTS.copyWith(fontSize: 16, color: context.neutral100),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            Text(
              post.content.toString(),
              style: mediumTS.copyWith(color: context.neutral90),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),

            if (post.urlImage != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(imageUrl: post.urlImage.toString()),
              ),
            ],

            const SizedBox(height: 12),

            Text(
              'Dilaporkan oleh ${post.reports?.length} orang',
              style: mediumTS.copyWith(fontSize: 12, color: context.neutral80),
            )
          ],
        ),
      ),
    );
  }
}
