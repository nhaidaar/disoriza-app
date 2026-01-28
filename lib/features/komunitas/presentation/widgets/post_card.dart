import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../../../../core/common/colors.dart';
import '../../../../core/common/custom_avatar.dart';
import '../../../../core/common/effects.dart';
import '../../../../core/common/fontstyles.dart';
import '../../../auth/data/models/user_model.dart';
import '../../data/models/post_model.dart';
import '../controllers/komunitas_controller.dart';
import '../pages/detail_post_page.dart';
import 'components/user_details.dart';

class PostCard extends StatefulWidget {
  final UserModel user;
  final PostModel post;
  final bool isAktivitas;
  final bool isBerandaCard;

  const PostCard({
    super.key,
    required this.user,
    required this.post,
    this.isAktivitas = false,
    this.isBerandaCard = false,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final komunitasController = Get.find<KomunitasController>();

  /// Gets the current post from controller or falls back to widget.post.
  /// This ensures we always display the latest state.
  PostModel get currentPost {
    // Try to find the post in the controller's lists
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
  bool get isCommented => (currentPost.comments ?? []).contains(widget.user.id);
  bool get isReported => (currentPost.reports ?? []).contains(widget.user.id);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final post = currentPost;
      final liked = isLiked;
      final commented = isCommented;
      final reported = isReported;

      return GestureDetector(
        onTap: () =>
            Get.to(() => DetailPostPage(user: widget.user, post: post)),
        child: Container(
          margin: widget.isBerandaCard
              ? const EdgeInsets.symmetric(horizontal: 10)
              : const EdgeInsets.only(bottom: 8),
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
                name: post.author != null
                    ? post.author!.name.toString()
                    : 'Disoriza User',
                isAdmin: post.author?.isAdmin ?? false,
                date: post.date,
              ),

              const SizedBox(height: 12),

              Text(
                post.title.toString(),
                style: semiboldTS.copyWith(
                  fontSize: 16,
                  color: context.neutral100,
                ),
                maxLines: widget.isBerandaCard ? 1 : 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              Text(
                post.content.toString(),
                style: mediumTS.copyWith(color: context.neutral90),
                maxLines: widget.isBerandaCard ? 1 : 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              if (!widget.isBerandaCard && post.urlImage != null) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(imageUrl: post.urlImage.toString()),
                ),
              ],

              const SizedBox(height: 12),

              Row(
                children: [
                  GestureDetector(
                    onTap: () => handleLikePost(),
                    child: Icon(
                      liked ? IconsaxPlusBold.heart : IconsaxPlusLinear.heart,
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

                  if ((liked || commented || reported) &&
                      widget.isAktivitas) ...[
                    const Spacer(),
                    CustomAvatar(link: widget.user.profilePicture, radius: 10),
                    const SizedBox(width: 4),
                    CircleAvatar(radius: 2, backgroundColor: context.neutral30),
                    const SizedBox(width: 4),
                    Text(
                      'Kamu ${reported
                          ? 'melaporkan'
                          : commented
                          ? 'mengomentari'
                          : 'menyukai'} postingan ini',
                      style: mediumTS.copyWith(
                        fontSize: 12,
                        color: context.neutral70,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      );
    });
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

class PostLoadingCard extends StatelessWidget {
  const PostLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(5, (index) {
        return CardLoading(
          height: 170,
          margin: const EdgeInsets.only(bottom: 8),
          borderRadius: BorderRadius.circular(16),
          cardLoadingTheme: CardLoadingTheme(
            colorOne: context.neutral30,
            colorTwo: context.neutral40,
          ),
        );
      }),
    );
  }
}
