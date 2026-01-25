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
import '../controllers/komunitas_controller.dart';
import '../widgets/comment_card.dart';
import '../widgets/components/user_details.dart';
import '../widgets/post_card.dart';

class DetailPostPage extends StatefulWidget {
  final UserModel user;
  final PostModel post;
  const DetailPostPage({super.key, required this.user, required this.post});

  @override
  State<DetailPostPage> createState() => _DetailPostPageState();
}

class _DetailPostPageState extends State<DetailPostPage> {
  final commentTextController = TextEditingController();
  final komunitasController = Get.find<KomunitasController>();

  bool isLatest = false;

  /// Gets the current post from controller or falls back to widget.post.
  /// This ensures we always display the latest state.
  PostModel get currentPost {
    final postId = widget.post.id;

    // Check posts list first
    final inPosts = komunitasController.posts.firstWhereOrNull(
      (p) => p.id == postId,
    );
    if (inPosts != null) return inPosts;

    // Check search results
    final inSearch = komunitasController.searchResults.firstWhereOrNull(
      (p) => p.id == postId,
    );
    if (inSearch != null) return inSearch;

    // Check reported posts
    final inReported = komunitasController.reportedPosts.firstWhereOrNull(
      (p) => p.id == postId,
    );
    if (inReported != null) return inReported;

    // Fall back to widget.post
    return widget.post;
  }

  bool get isLiked => (currentPost.likes ?? []).contains(widget.user.id);

  @override
  void initState() {
    fetchComments();
    super.initState();

    ever(komunitasController.postDeleted, (deleted) {
      if (deleted) {
        handlePostDeleted(context);
        komunitasController.postDeleted.value = false;
      }
    });

    ever(komunitasController.commentDeleted, (deleted) {
      if (deleted) {
        handleCommentDeleted(context);
        komunitasController.commentDeleted.value = false;
      }
    });

    ever(komunitasController.postReported, (reported) {
      if (reported) {
        handlePostReported(context);
        komunitasController.postReported.value = false;
      }
    });

    ever(komunitasController.commentReported, (reported) {
      if (reported) {
        handleCommentReported(context);
        komunitasController.commentReported.value = false;
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
        backgroundColor: context.neutral10,
        surfaceTintColor: context.neutral10,
        shape: Border(bottom: BorderSide(color: context.neutral30)),

        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(IconsaxPlusLinear.arrow_left),
        ),

        title: Text(
          'Detail diskusi',
          style: mediumTS.copyWith(fontSize: 16, color: context.neutral100),
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
                  icon: Icon(
                    IconsaxPlusLinear.info_circle,
                    color: context.neutral100,
                  ),
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
                    border: Border.all(color: context.neutral30),
                    color: context.neutral10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserDetails(
                        name: widget.post.author != null
                            ? widget.post.author!.name.toString()
                            : 'Disoriza User',
                        isAdmin: widget.post.author?.isAdmin ?? false,
                        profilePicture: widget.post.author?.profilePicture,
                        date: widget.post.date,

                        canViewReport:
                            widget.user.isAdmin &&
                            (widget.post.reports ?? []).isNotEmpty,
                        reports: widget.post.reports?.length,
                      ),

                      const SizedBox(height: 12),

                      Text(
                        widget.post.title.toString(),
                        style: semiboldTS.copyWith(
                          fontSize: 16,
                          color: context.neutral100,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        widget.post.content.toString(),
                        style: mediumTS.copyWith(color: context.neutral90),
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

                      Obx(() {
                        final post = currentPost;
                        final liked = isLiked;
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () => handleLikePost(),
                              child: Icon(
                                liked
                                    ? IconsaxPlusBold.heart
                                    : IconsaxPlusLinear.heart,
                                color: liked ? dangerMain : context.neutral100,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              post.likesCount.toString(),
                              style: mediumTS.copyWith(
                                fontSize: 12,
                                color: context.neutral80,
                              ),
                            ),

                            const SizedBox(width: 16),

                            Icon(
                              IconsaxPlusLinear.message_text_1,
                              color: context.neutral100,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              post.commentsCount.toString(),
                              style: mediumTS.copyWith(
                                fontSize: 12,
                                color: context.neutral80,
                              ),
                            ),
                          ],
                        );
                      }),

                      const SizedBox(height: 12),

                      Divider(thickness: 1, color: context.neutral30),

                      Row(
                        children: [
                          Text(
                            'Komentar',
                            style: mediumTS.copyWith(
                              fontSize: 16,
                              color: context.neutral100,
                            ),
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
                                komunitasController.fetchComments(
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
                        if (komunitasController.commentsStatus.value ==
                            Status.loading) {
                          return const PostLoadingCard();
                        } else if (komunitasController.commentsStatus.value ==
                            Status.success) {
                          return komunitasController.comments.isNotEmpty
                              ? Column(
                                  children: komunitasController.comments.map((
                                    comment,
                                  ) {
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
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(color: context.neutral30),
                ),
                color: context.neutral10,
              ),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  CustomFormField(
                    controller: commentTextController,
                    backgroundColor: context.backgroundCanvas,
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

                        komunitasController.createComment(comment: comment);
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
    komunitasController.fetchComments(
      postId: widget.post.id.toString(),
      latest: isLatest,
    );
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
                  onTap: () => komunitasController.deletePost(
                    postId: widget.post.id.toString(),
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
                  onTap: () => komunitasController.reportPost(
                    uid: widget.user.id.toString(),
                    postId: widget.post.id.toString(),
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

  void handleLikePost() async {
    final post = currentPost;
    final wasLiked = isLiked;

    // Call controller - it handles both API and local state update
    if (wasLiked) {
      await komunitasController.unlikePost(
        uid: widget.user.id.toString(),
        postId: post.id.toString(),
      );
    } else {
      await komunitasController.likePost(
        uid: widget.user.id.toString(),
        postId: post.id.toString(),
      );
    }
  }
}
