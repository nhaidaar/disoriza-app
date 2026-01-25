import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/custom_button.dart';
import '../../../../core/common/custom_popup.dart';
import '../../../../core/common/effects.dart';
import '../../../../core/common/fontstyles.dart';
import '../../../../core/enums/status.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/models/comment_model.dart';
import '../controllers/komunitas_controller.dart';
import 'components/user_details.dart';

class CommentCard extends StatefulWidget {
  final UserModel user;
  final CommentModel comment;

  const CommentCard({super.key, required this.user, required this.comment});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  final komunitasController = Get.find<KomunitasController>();
  bool isLiked = false;

  @override
  void initState() {
    isLiked = (widget.comment.likes ?? []).contains(widget.user.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
            name: widget.comment.idUser != null
                ? widget.comment.idUser!.name.toString()
                : 'Disoriza User',
            profilePicture: widget.comment.idUser?.profilePicture,
            date: widget.comment.date,
            isAdmin: widget.comment.idUser?.isAdmin ?? false,
            widget: [
              const SizedBox(width: 16),

              Column(
                children: [
                  GestureDetector(
                    onTap: () => handleLikeComment(),
                    child: Icon(
                      isLiked ? IconsaxPlusBold.heart : IconsaxPlusLinear.heart,
                      color: isLiked ? dangerMain : context.neutral100,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    (widget.comment.likes ?? []).length.toString(),
                    style: mediumTS.copyWith(
                      fontSize: 12,
                      color: context.neutral80,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            widget.comment.content.toString(),
            style: mediumTS.copyWith(color: context.neutral90),
          ),

          const SizedBox(height: 8),

          widget.comment.idUser?.id == widget.user.id || widget.user.isAdmin
              ? Row(
                  children: [
                    GestureDetector(
                      onTap: () => handleDeleteComment(context),
                      child: Text(
                        'Hapus',
                        style: mediumTS.copyWith(
                          fontSize: 12,
                          color: context.neutral60,
                        ),
                      ),
                    ),
                    if ((widget.comment.reports ?? []).isNotEmpty) ...[
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: CircleAvatar(
                          radius: 2,
                          backgroundColor: Color(0xFFD9D9D9),
                        ),
                      ),
                      Text(
                        'Dilaporkan oleh ${widget.comment.reports?.length} orang',
                        style: mediumTS.copyWith(
                          fontSize: 12,
                          color: context.neutral80,
                        ),
                      ),
                    ],
                  ],
                )
              : GestureDetector(
                  onTap: () => handleReportComment(context),
                  child: Text(
                    'Laporkan',
                    style: mediumTS.copyWith(
                      fontSize: 12,
                      color: context.neutral60,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Future<void> handleDeleteComment(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => CustomPopup(
        icon: IconsaxPlusLinear.trash,
        iconColor: dangerMain,
        title: 'Ingin menghapus komentar ini?',
        subtitle: 'Setelah dihapus, data tidak dapat diurungkan.',
        actions: [
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  backgroundColor: dangerMain,
                  onTap: () => komunitasController.deleteComment(
                    postId: widget.comment.idPost.toString(),
                    commentId: widget.comment.id.toString(),
                  ),
                  text: 'Ya, hapus',
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: CustomButton(
                  backgroundColor: context.neutral10,
                  onTap: () => Navigator.of(context).pop(),
                  text: 'Batal',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> handleReportComment(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => CustomPopup(
        icon: IconsaxPlusLinear.info_circle,
        iconColor: dangerMain,
        title: 'Ingin melaporkan komentar ini?',
        actions: [
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  backgroundColor: dangerMain,
                  onTap: () => komunitasController.reportComment(
                    uid: widget.user.id.toString(),
                    commentId: widget.comment.id.toString(),
                  ),
                  text: 'Ya, laporkan',
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: CustomButton(
                  backgroundColor: context.neutral10,
                  onTap: () => Navigator.of(context).pop(),
                  text: 'Batal',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void handleLikeComment() async {
    final wasLiked = isLiked;
    final previousLikes = List<String>.from(widget.comment.likes ?? []);

    // Optimistic update
    setState(() {
      isLiked = !isLiked;
      isLiked
          ? (widget.comment.likes ?? []).add(widget.user.id.toString())
          : (widget.comment.likes ?? []).remove(widget.user.id.toString());
    });

    try {
      if (isLiked) {
        await komunitasController.likeComment(
          uid: widget.user.id.toString(),
          commentId: widget.comment.id.toString(),
        );
      } else {
        await komunitasController.unlikeComment(
          uid: widget.user.id.toString(),
          commentId: widget.comment.id.toString(),
        );
      }

      // Rollback on error
      if (komunitasController.actionStatus.value == Status.error) {
        setState(() {
          isLiked = wasLiked;
          (widget.comment.likes ?? []).clear();
          (widget.comment.likes ?? []).addAll(previousLikes);
        });
      }
    } catch (e) {
      // Rollback on exception
      setState(() {
        isLiked = wasLiked;
        (widget.comment.likes ?? []).clear();
        (widget.comment.likes ?? []).addAll(previousLikes);
      });
    }
  }
}
