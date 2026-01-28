import 'dart:typed_data';

import 'package:get/get.dart';

import '../../../../core/enums/status.dart';
import '../../data/models/comment_model.dart';
import '../../data/models/post_model.dart';
import '../../data/models/post_with_comment.dart';
import '../../domain/usecases/komunitas_usecase.dart';

/// Enum to track the last successful operation for specific UI feedback
enum KomunitasOperation {
  postCreated,
  postDeleted,
  postLiked,
  postUnliked,
  postReported,
  commentCreated,
  commentDeleted,
  commentLiked,
  commentUnliked,
  commentReported,
}

/// Unified controller for all Komunitas (Community) feature operations.
///
/// Consolidates functionality from the previous 4 controllers:
/// - KomunitasPostController
/// - KomunitasCommentController
/// - KomunitasSearchController
/// - KomunitasReportController
///
/// Uses separate status variables for different operation types to prevent
/// race conditions and status conflicts.
class KomunitasController extends GetxController {
  final KomunitasUsecase _usecase;

  KomunitasController(this._usecase);

  // === POSTS STATE ===
  final RxList<PostModel> posts = <PostModel>[].obs;
  final Rx<Status> postsStatus = Status.initial.obs;

  // === COMMENTS STATE ===
  final RxList<CommentModel> comments = <CommentModel>[].obs;
  final Rx<Status> commentsStatus = Status.initial.obs;

  // === SEARCH STATE ===
  final RxList<PostModel> searchResults = <PostModel>[].obs;
  final Rx<Status> searchStatus = Status.initial.obs;

  // === REPORTED CONTENT STATE ===
  final RxList<PostModel> reportedPosts = <PostModel>[].obs;
  final RxList<PostWithCommentModel> reportedComments = <PostWithCommentModel>[].obs;

  // === ACTION STATE (for like/unlike/report/create/delete operations) ===
  final Rx<Status> actionStatus = Status.initial.obs;

  // === SHARED ERROR STATE ===
  final RxString errorMessage = ''.obs;

  // === OPERATION FLAGS (for specific UI feedback) ===
  final Rx<KomunitasOperation?> lastOperation = Rx<KomunitasOperation?>(null);

  // === LEGACY COMPATIBILITY FLAGS ===
  // These are kept for backward compatibility with existing pages
  // that listen to these specific flags
  final RxBool postCreated = false.obs;
  final RxBool postDeleted = false.obs;
  final RxBool commentDeleted = false.obs;
  final RxBool postReported = false.obs;
  final RxBool commentReported = false.obs;

  // === HELPER ===
  String _cleanError(dynamic error) {
    return error
        .toString()
        .replaceFirst(RegExp(r'^(Exception: |[A-Za-z]+Exception: )'), '')
        .trim();
  }

  // ============================================================
  // POSTS OPERATIONS
  // ============================================================

  /// Fetches all posts from the community.
  ///
  /// [latest] - If true, sorts by date (newest first). Otherwise sorts by likes.
  /// [max] - Maximum number of posts to fetch.
  Future<void> fetchAllPosts({bool latest = false, int? max}) async {
    try {
      postsStatus.value = Status.loading;
      errorMessage.value = '';

      final result = await _usecase.fetchAllPosts(latest: latest, max: max);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          postsStatus.value = Status.error;
        },
        (success) {
          posts.value = success;
          postsStatus.value = Status.success;
        },
      );
    } catch (_) {
      postsStatus.value = Status.error;
      rethrow;
    }
  }

  /// Fetches posts that have been reported.
  Future<void> fetchReportedPosts() async {
    try {
      postsStatus.value = Status.loading;
      errorMessage.value = '';

      final result = await _usecase.fetchReportedPosts();
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          postsStatus.value = Status.error;
        },
        (success) {
          reportedPosts.value = success;
          postsStatus.value = Status.success;
        },
      );
    } catch (_) {
      postsStatus.value = Status.error;
      rethrow;
    }
  }

  /// Fetches comments that have been reported.
  Future<void> fetchReportedComments() async {
    try {
      commentsStatus.value = Status.loading;
      errorMessage.value = '';

      final result = await _usecase.fetchReportedComments();
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          commentsStatus.value = Status.error;
        },
        (success) {
          reportedComments.value = success;
          commentsStatus.value = Status.success;
        },
      );
    } catch (_) {
      commentsStatus.value = Status.error;
      rethrow;
    }
  }

  /// Fetches user activity based on filter.
  ///
  /// [uid] - User ID to fetch activity for.
  /// [filter] - Filter type: 'Postingan', 'Disukai', 'Komentar', 'Dilaporkan'
  Future<void> fetchAktivitas({required String uid, required String filter}) async {
    try {
      postsStatus.value = Status.loading;
      errorMessage.value = '';

      final result = await _usecase.fetchAktivitas(uid: uid, filter: filter);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          postsStatus.value = Status.error;
        },
        (success) {
          posts.value = success;
          postsStatus.value = Status.success;
        },
      );
    } catch (_) {
      postsStatus.value = Status.error;
      rethrow;
    }
  }

  /// Creates a new post.
  ///
  /// [title] - Post title.
  /// [description] - Post content/description.
  /// [uid] - User ID of the author.
  /// [image] - Optional image data.
  Future<void> createPost({
    required String title,
    required String description,
    required String uid,
    Uint8List? image,
  }) async {
    try {
      actionStatus.value = Status.loading;
      errorMessage.value = '';
      postCreated.value = false;

      final result = await _usecase.createPost(
        title: title,
        description: description,
        uid: uid,
        image: image,
      );
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          actionStatus.value = Status.error;
        },
        (success) {
          postCreated.value = true;
          lastOperation.value = KomunitasOperation.postCreated;
          actionStatus.value = Status.success;
        },
      );
    } catch (_) {
      actionStatus.value = Status.error;
      rethrow;
    }
  }

  /// Deletes a post.
  ///
  /// [postId] - ID of the post to delete.
  Future<void> deletePost({required String postId}) async {
    try {
      actionStatus.value = Status.loading;
      errorMessage.value = '';
      postDeleted.value = false;

      final result = await _usecase.deletePost(postId: postId);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          actionStatus.value = Status.error;
        },
        (success) {
          postDeleted.value = true;
          lastOperation.value = KomunitasOperation.postDeleted;
          actionStatus.value = Status.success;
        },
      );
    } catch (_) {
      actionStatus.value = Status.error;
      rethrow;
    }
  }

  /// Likes a post.
  ///
  /// [uid] - User ID who is liking.
  /// [postId] - ID of the post to like.
  Future<void> likePost({required String uid, required String postId}) async {
    try {
      actionStatus.value = Status.loading;
      errorMessage.value = '';

      final result = await _usecase.likePost(uid: uid, postId: postId);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          actionStatus.value = Status.error;
        },
        (success) {
          // Update local state for immediate UI feedback
          _updatePostLikeState(postId: postId, uid: uid, liked: true);
          lastOperation.value = KomunitasOperation.postLiked;
          actionStatus.value = Status.success;
        },
      );
    } catch (_) {
      actionStatus.value = Status.error;
      rethrow;
    }
  }

  /// Unlikes a post.
  ///
  /// [uid] - User ID who is unliking.
  /// [postId] - ID of the post to unlike.
  Future<void> unlikePost({required String uid, required String postId}) async {
    try {
      actionStatus.value = Status.loading;
      errorMessage.value = '';

      final result = await _usecase.unlikePost(uid: uid, postId: postId);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          actionStatus.value = Status.error;
        },
        (success) {
          // Update local state for immediate UI feedback
          _updatePostLikeState(postId: postId, uid: uid, liked: false);
          lastOperation.value = KomunitasOperation.postUnliked;
          actionStatus.value = Status.success;
        },
      );
    } catch (_) {
      actionStatus.value = Status.error;
      rethrow;
    }
  }

  /// Updates the like state of a post in all local lists.
  void _updatePostLikeState({
    required String postId,
    required String uid,
    required bool liked,
  }) {
    final postIdInt = int.tryParse(postId);
    if (postIdInt == null) return;

    // Update in posts list
    final postIndex = posts.indexWhere((p) => p.id == postIdInt);
    if (postIndex != -1) {
      final post = posts[postIndex];
      final updatedLikes = List<String>.from(post.likes ?? []);
      if (liked && !updatedLikes.contains(uid)) {
        updatedLikes.add(uid);
      } else if (!liked) {
        updatedLikes.remove(uid);
      }
      posts[postIndex] = post.copyWith(
        likes: updatedLikes,
        likesCount: updatedLikes.length,
      );
    }

    // Update in searchResults list
    final searchIndex = searchResults.indexWhere((p) => p.id == postIdInt);
    if (searchIndex != -1) {
      final post = searchResults[searchIndex];
      final updatedLikes = List<String>.from(post.likes ?? []);
      if (liked && !updatedLikes.contains(uid)) {
        updatedLikes.add(uid);
      } else if (!liked) {
        updatedLikes.remove(uid);
      }
      searchResults[searchIndex] = post.copyWith(
        likes: updatedLikes,
        likesCount: updatedLikes.length,
      );
    }

    // Update in reportedPosts list
    final reportedIndex = reportedPosts.indexWhere((p) => p.id == postIdInt);
    if (reportedIndex != -1) {
      final post = reportedPosts[reportedIndex];
      final updatedLikes = List<String>.from(post.likes ?? []);
      if (liked && !updatedLikes.contains(uid)) {
        updatedLikes.add(uid);
      } else if (!liked) {
        updatedLikes.remove(uid);
      }
      reportedPosts[reportedIndex] = post.copyWith(
        likes: updatedLikes,
        likesCount: updatedLikes.length,
      );
    }
  }

  // ============================================================
  // COMMENTS OPERATIONS
  // ============================================================

  /// Fetches comments for a specific post.
  ///
  /// [postId] - ID of the post to fetch comments for.
  /// [latest] - If true, sorts by date (newest first). Otherwise sorts by likes.
  Future<void> fetchComments({required String postId, bool latest = false}) async {
    try {
      commentsStatus.value = Status.loading;
      errorMessage.value = '';

      final result = await _usecase.fetchComments(postId: postId, latest: latest);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          commentsStatus.value = Status.error;
        },
        (success) {
          comments.value = success;
          commentsStatus.value = Status.success;
        },
      );
    } catch (_) {
      commentsStatus.value = Status.error;
      rethrow;
    }
  }

  /// Creates a new comment on a post.
  ///
  /// Automatically refreshes comments after successful creation.
  /// [comment] - The comment model to create.
  Future<void> createComment({required CommentModel comment}) async {
    try {
      commentsStatus.value = Status.loading;
      errorMessage.value = '';

      final result = await _usecase.createComment(comment: comment);
      await result.fold(
        (error) async {
          errorMessage.value = _cleanError(error);
          commentsStatus.value = Status.error;
        },
        (success) async {
          // FIXED: Properly await fetchComments to prevent race condition
          await fetchComments(postId: comment.idPost.toString());
          // Update comment count in posts list
          _updatePostCommentCount(
            postId: comment.idPost.toString(),
            uid: comment.idUser?.id,
            added: true,
          );
          lastOperation.value = KomunitasOperation.commentCreated;
          // Note: commentsStatus is set by fetchComments
        },
      );
    } catch (_) {
      commentsStatus.value = Status.error;
      rethrow;
    }
  }

  /// Deletes a comment.
  ///
  /// Automatically refreshes comments after successful deletion.
  /// [commentId] - ID of the comment to delete.
  /// [postId] - ID of the post the comment belongs to (for refresh).
  Future<void> deleteComment({required String commentId, required String postId}) async {
    try {
      commentsStatus.value = Status.loading;
      errorMessage.value = '';
      commentDeleted.value = false;

      final result = await _usecase.deleteComment(commentId: commentId);
      await result.fold(
        (error) async {
          errorMessage.value = _cleanError(error);
          commentsStatus.value = Status.error;
        },
        (success) async {
          commentDeleted.value = true;
          lastOperation.value = KomunitasOperation.commentDeleted;
          // FIXED: Properly await fetchComments to prevent race condition
          await fetchComments(postId: postId);
          // Update comment count in posts list (use actual count from comments list)
          _syncPostCommentCount(postId: postId);
          // Note: commentsStatus is set by fetchComments
        },
      );
    } catch (_) {
      commentsStatus.value = Status.error;
      rethrow;
    }
  }

  /// Updates the comment count of a post when a comment is added.
  void _updatePostCommentCount({
    required String postId,
    String? uid,
    required bool added,
  }) {
    final postIdInt = int.tryParse(postId);
    if (postIdInt == null) return;

    void updatePost(RxList<PostModel> list) {
      final index = list.indexWhere((p) => p.id == postIdInt);
      if (index != -1) {
        final post = list[index];
        final updatedComments = List<String>.from(post.comments ?? []);
        if (added && uid != null && !updatedComments.contains(uid)) {
          updatedComments.add(uid);
        }
        list[index] = post.copyWith(
          comments: updatedComments,
          commentsCount: comments.length, // Use actual comment count
        );
      }
    }

    updatePost(posts);
    updatePost(searchResults);
    updatePost(reportedPosts);
  }

  /// Syncs the comment count of a post with the actual comments list.
  void _syncPostCommentCount({required String postId}) {
    final postIdInt = int.tryParse(postId);
    if (postIdInt == null) return;

    void updatePost(RxList<PostModel> list) {
      final index = list.indexWhere((p) => p.id == postIdInt);
      if (index != -1) {
        final post = list[index];
        // Extract unique user IDs from comments
        final commentUserIds = comments
            .where((c) => c.idUser?.id != null)
            .map((c) => c.idUser!.id!)
            .toSet()
            .toList();
        list[index] = post.copyWith(
          comments: commentUserIds,
          commentsCount: comments.length,
        );
      }
    }

    updatePost(posts);
    updatePost(searchResults);
    updatePost(reportedPosts);
  }

  /// Likes a comment.
  ///
  /// [uid] - User ID who is liking.
  /// [commentId] - ID of the comment to like.
  /// Returns true on success, false on failure.
  Future<bool> likeComment({required String uid, required String commentId}) async {
    try {
      actionStatus.value = Status.loading;
      errorMessage.value = '';

      final result = await _usecase.likeComment(uid: uid, commentId: commentId);
      return result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          actionStatus.value = Status.error;
          return false;
        },
        (success) {
          lastOperation.value = KomunitasOperation.commentLiked;
          actionStatus.value = Status.success;
          return true;
        },
      );
    } catch (_) {
      actionStatus.value = Status.error;
      return false;
    }
  }

  /// Unlikes a comment.
  ///
  /// [uid] - User ID who is unliking.
  /// [commentId] - ID of the comment to unlike.
  /// Returns true on success, false on failure.
  Future<bool> unlikeComment({required String uid, required String commentId}) async {
    try {
      actionStatus.value = Status.loading;
      errorMessage.value = '';

      final result = await _usecase.unlikeComment(uid: uid, commentId: commentId);
      return result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          actionStatus.value = Status.error;
          return false;
        },
        (success) {
          lastOperation.value = KomunitasOperation.commentUnliked;
          actionStatus.value = Status.success;
          return true;
        },
      );
    } catch (_) {
      actionStatus.value = Status.error;
      return false;
    }
  }

  // ============================================================
  // SEARCH OPERATIONS
  // ============================================================

  /// Searches for posts matching the query.
  ///
  /// [search] - Search query string.
  Future<void> searchPost({required String search}) async {
    try {
      searchStatus.value = Status.loading;
      errorMessage.value = '';

      final result = await _usecase.searchPost(search: search);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          searchStatus.value = Status.error;
        },
        (success) {
          searchResults.value = success;
          searchStatus.value = Status.success;
        },
      );
    } catch (_) {
      searchStatus.value = Status.error;
      rethrow;
    }
  }

  /// Clears search results and resets search state.
  void clearSearch() {
    searchResults.clear();
    searchStatus.value = Status.initial;
    errorMessage.value = '';
  }

  // ============================================================
  // REPORT OPERATIONS
  // ============================================================

  /// Reports a post for moderation.
  ///
  /// [uid] - User ID who is reporting.
  /// [postId] - ID of the post to report.
  /// [reason] - Optional reason for the report.
  Future<void> reportPost({
    required String uid,
    required String postId,
    String? reason,
  }) async {
    try {
      actionStatus.value = Status.loading;
      errorMessage.value = '';
      postReported.value = false;

      final result = await _usecase.reportPost(uid: uid, postId: postId, reason: reason);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          actionStatus.value = Status.error;
        },
        (success) {
          postReported.value = true;
          lastOperation.value = KomunitasOperation.postReported;
          actionStatus.value = Status.success;
        },
      );
    } catch (_) {
      actionStatus.value = Status.error;
      rethrow;
    }
  }

  /// Reports a comment for moderation.
  ///
  /// [uid] - User ID who is reporting.
  /// [commentId] - ID of the comment to report.
  /// [reason] - Optional reason for the report.
  Future<void> reportComment({
    required String uid,
    required String commentId,
    String? reason,
  }) async {
    try {
      actionStatus.value = Status.loading;
      errorMessage.value = '';
      commentReported.value = false;

      final result = await _usecase.reportComment(uid: uid, commentId: commentId, reason: reason);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          actionStatus.value = Status.error;
        },
        (success) {
          commentReported.value = true;
          lastOperation.value = KomunitasOperation.commentReported;
          actionStatus.value = Status.success;
        },
      );
    } catch (_) {
      actionStatus.value = Status.error;
      rethrow;
    }
  }

  // ============================================================
  // LIFECYCLE
  // ============================================================

  @override
  void onClose() {
    // Clean up reactive variables
    posts.clear();
    comments.clear();
    searchResults.clear();
    reportedPosts.clear();
    reportedComments.clear();
    super.onClose();
  }

  /// Resets all state to initial values.
  /// Useful when user logs out or needs a fresh state.
  void resetState() {
    posts.clear();
    comments.clear();
    searchResults.clear();
    reportedPosts.clear();
    reportedComments.clear();

    postsStatus.value = Status.initial;
    commentsStatus.value = Status.initial;
    searchStatus.value = Status.initial;
    actionStatus.value = Status.initial;

    errorMessage.value = '';
    lastOperation.value = null;

    postCreated.value = false;
    postDeleted.value = false;
    commentDeleted.value = false;
    postReported.value = false;
    commentReported.value = false;
  }
}
