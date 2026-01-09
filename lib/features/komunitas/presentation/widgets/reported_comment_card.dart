import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/effects.dart';
import '../../../../core/common/fontstyles.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/models/comment_model.dart';
import '../../data/models/post_model.dart';
import '../pages/detail_post_page.dart';
import 'components/user_details.dart';

class ReportedCommentCard extends StatelessWidget {
  final UserModel user;
  final CommentModel comment;
  final PostModel post;

  const ReportedCommentCard({
    super.key,
    required this.user,
    required this.comment,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: defaultSmoothRadius,
        border: Border.all(color: neutral30),
        color: neutral10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserDetails(
            name: comment.idUser != null ? comment.idUser!.name.toString() : 'Disoriza User',
            profilePicture: comment.idUser?.profilePicture,
            date: comment.date,
            isAdmin: comment.idUser?.isAdmin ?? false,
          ),
          const SizedBox(height: 8),
          Text(
            comment.content.toString(),
            style: mediumTS.copyWith(color: neutral90),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Dilaporkan oleh ${comment.reports?.length} orang',
                style: mediumTS.copyWith(fontSize: 12, color: neutral80),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: CircleAvatar(radius: 2, backgroundColor: Color(0xFFD9D9D9)),
              ),
              GestureDetector(
                onTap: () => Get.to(() => DetailPostPage(user: user, post: post)),
                child: Text(
                  'Lihat di postingan',
                  style: mediumTS.copyWith(fontSize: 12, color: accentOrangeMain),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
