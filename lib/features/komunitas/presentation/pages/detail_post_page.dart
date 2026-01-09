import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/custom_button.dart';
import '../../../../core/common/custom_dropdown.dart';
import '../../../../core/common/custom_empty_state.dart';
import '../../../../core/common/custom_popup.dart';
import '../../../../core/common/custom_textfield.dart';
import '../../../../core/common/effects.dart';
import '../../../../core/common/fontstyles.dart';
import '../../../../core/enums/status.dart';
import '../../../../core/utils/snackbar.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/models/comment_model.dart';
import '../../data/models/post_model.dart';
import '../controllers/komunitas_comment_controller.dart';
import '../controllers/komunitas_post_controller.dart';
import '../controllers/komunitas_report_controller.dart';
import '../widgets/comment_card.dart';
import '../widgets/components/user_details.dart';
import '../widgets/post_card.dart';

class DetailPostPage extends StatefulWidget {
  final UserModel user;
  final PostModel post;
  const DetailPostPage({
    super.key,
    required this.user,
    required this.post,
  });

  @override
  State<DetailPostPage> createState() => _DetailPostPageState();
}

class _DetailPostPageState extends State<DetailPostPage> {
  final commentTextController = TextEditingController();
  final komunitasPostController = Get.find<KomunitasPostController>();
  final komunitasCommentController = Get.find<KomunitasCommentController>();
  final komunitasReportController = Get.find<KomunitasReportController>();

  bool isLiked = false;
  bool isLatest = false;

  @override
  void initState() {
    isLiked = (widget.post.likes ?? []).contains(widget.user.id);
    fetchComments();
    super.initState();

    ever(komunitasPostController.postDeleted, (deleted) {
      if (deleted) {
        handlePostDeleted(context);
        komunitasPostController.postDeleted.value = false;
      }
    });

    ever(komunitasCommentController.status, (status) {
      if (status == Status.success) {
        refreshCommentsCount();
      }
    });

    ever(komunitasCommentController.commentDeleted, (deleted) {
      if (deleted) {
        handleCommentDeleted(context);
        komunitasCommentController.commentDeleted.value = false;
      }
    });

    ever(komunitasReportController.postReported, (reported) {
      if (reported) {
        handlePostReported(context);
        komunitasReportController.postReported.value = false;
      }
    });

    ever(komunitasReportController.commentReported, (reported) {
      if (reported) {
        handleCommentReported(context);
        komunitasReportController.commentReported.value = false;
      }
    });
  }

  @override
  void dispose() {
    commentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: neutral10,
        surfaceTintColor: neutral10,
        shape: const Border(
          bottom: BorderSide(color: neutral30),
        ),

        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(IconsaxPlusLinear.arrow_left),
        ),

        title: Text(
          'Detail diskusi',
          style: mediumTS.copyWith(fontSize: 16, color: neutral100),
        ),
        centerTitle: true,

        actions: [
          widget.post.author?.id == widget.user.id || widget.user.isAdmin
              ? IconButton(
                  onPressed: () => handleDeletePost(context),
                  icon: const Icon(IconsaxPlusLinear.trash, color: dangerMain),
                )
              : IconButton(
                  onPressed: () => handleReportPost(context),
                  icon: const Icon(IconsaxPlusLinear.info_circle, color: neutral100),
                ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => fetchComments(),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8),
                child: Container(
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
                        name: widget.post.author != null ? widget.post.author!.name.toString() : 'Disoriza User',
                        isAdmin: widget.post.author?.isAdmin ?? false,
                        profilePicture: widget.post.author?.profilePicture,
                        date: widget.post.date,

                        canViewReport: widget.user.isAdmin && (widget.post.reports ?? []).isNotEmpty,
                        reports: widget.post.reports?.length,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        widget.post.title.toString(),
                        style: semiboldTS.copyWith(fontSize: 16, color: neutral100),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        widget.post.content.toString(),
                        style: mediumTS.copyWith(color: neutral90),
                      ),

                      const SizedBox(height: 4),

                      if (widget.post.urlImage != null) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl: widget.post.urlImage.toString(),
                          ),
                        ),
                      ],

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => handleLikePost(),
                            child: Icon(
                              isLiked ? IconsaxPlusBold.heart : IconsaxPlusLinear.heart,
                              color: isLiked ? dangerMain : neutral100,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            (widget.post.likes ?? []).length.toString(),
                            style: mediumTS.copyWith(fontSize: 12, color: neutral80),
                          ),

                          const SizedBox(width: 16),

                          const Icon(
                            IconsaxPlusLinear.message_text_1,
                            color: neutral100,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            (widget.post.comments ?? []).length.toString(),
                            style: mediumTS.copyWith(fontSize: 12, color: neutral80),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      const Divider(thickness: 1, color: neutral30),

                      Row(
                        children: [
                          Text(
                            'Komentar',
                            style: mediumTS.copyWith(fontSize: 16, color: neutral100),
                          ),
                          const Spacer(),
                          CustomDropdown(
                            items: const [
                              MapEntry('Terpopuler', false),
                              MapEntry('Terbaru', true),
                            ],
                            initialValue: const MapEntry('Terpopuler', false),
                            onChanged: (filter) async {
                              if (isLatest != filter.value) {
                                isLatest = !isLatest;
                                komunitasCommentController.fetchComments(
                                  postId: widget.post.id.toString(),
                                  latest: isLatest,
                                );
                              }
                            },
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Obx(() {
                        if (komunitasCommentController.status.value == Status.loading) {
                          return const PostLoadingCard();
                        } else if (komunitasCommentController.status.value == Status.success) {
                          return komunitasCommentController.comments.isNotEmpty
                              ? Column(
                                  children: komunitasCommentController.comments.map((comment) {
                                    return CommentCard(
                                      user: widget.user,
                                      comment: comment,
                                    );
                                  }).toList(),
                                )
                              : const Center(child: KomentarEmptyState());
                        }
                        return const Center(child: KomentarEmptyState());
                      }),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                border: Border.symmetric(horizontal: BorderSide(color: neutral30)),
                color: neutral10,
              ),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  CustomFormField(
                    controller: commentTextController,
                    backgroundColor: backgroundCanvas,
                    hint: 'Berikan komentar',
                  ),
                  IconButton(
                    onPressed: () {
                      if (commentTextController.text.isNotEmpty) {
                        final comment = CommentModel(
                          idPost: widget.post.id,
                          idUser: UserModel(id: widget.user.id),
                          content: commentTextController.text,
                        );

                        komunitasCommentController.createComment(comment: comment);
                        commentTextController.clear();
                      }
                    },
                    icon: const Icon(IconsaxPlusLinear.send_1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void handlePostDeleted(BuildContext context) {
    Get.back();
    Get.back();
    showSnackbar(context, message: 'Postingan berhasil dihapus!');
  }

  void handleCommentDeleted(BuildContext context) {
    Get.back();
    showSnackbar(context, message: 'Komentar berhasil dihapus!');
  }

  void handlePostReported(BuildContext context) {
    Get.back();
    showSnackbar(context, message: 'Postingan berhasil dilaporkan!');
  }

  void handleCommentReported(BuildContext context) {
    Get.back();
    showSnackbar(context, message: 'Komentar berhasil dilaporkan!');
  }

  void fetchComments() {
    komunitasCommentController.fetchComments(
      postId: widget.post.id.toString(),
      latest: isLatest,
    );
  }

  void refreshCommentsCount() {
    setState(() {
      (widget.post.comments ?? []).clear();
      (widget.post.comments ?? []).addAll(
        komunitasCommentController.comments.map((c) => c.idUser!.id!).toList(),
      );
    });
  }

  Future<void> handleDeletePost(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => CustomPopup(
        icon: IconsaxPlusLinear.trash,
        iconColor: dangerMain,
        title: 'Ingin menghapus diskusi ini?',
        subtitle: 'Setelah dihapus, data tidak dapat diurungkan.',
        actions: [
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  backgroundColor: dangerMain,
                  pressedColor: dangerPressed,
                  onTap: () => komunitasPostController.deletePost(postId: widget.post.id.toString()),
                  text: 'Ya, hapus',
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: CustomButton(
                  backgroundColor: neutral10,
                  pressedColor: neutral50,
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

  Future<void> handleReportPost(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => CustomPopup(
        icon: IconsaxPlusLinear.info_circle,
        iconColor: dangerMain,
        title: 'Ingin melaporkan diskusi ini?',
        actions: [
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  backgroundColor: dangerMain,
                  pressedColor: dangerPressed,
                  onTap: () => komunitasReportController.reportPost(
                    uid: widget.user.id.toString(),
                    postId: widget.post.id.toString(),
                  ),
                  text: 'Ya, laporkan',
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: CustomButton(
                  backgroundColor: neutral10,
                  pressedColor: neutral50,
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

  void handleLikePost() {
    setState(() {
      isLiked = !isLiked;
      isLiked
          ? (widget.post.likes ?? []).add(widget.user.id.toString())
          : (widget.post.likes ?? []).remove(widget.user.id.toString());
    });

    isLiked
        ? komunitasPostController.likePost(
            uid: widget.user.id.toString(),
            postId: widget.post.id.toString(),
          )
        : komunitasPostController.unlikePost(
            uid: widget.user.id.toString(),
            postId: widget.post.id.toString(),
          );
  }
}
