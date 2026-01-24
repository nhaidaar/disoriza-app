import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:disoriza/core/enums/status.dart';
import 'package:disoriza/features/komunitas/data/models/comment_model.dart';
import 'package:disoriza/features/komunitas/data/models/post_model.dart';
import 'package:disoriza/features/komunitas/data/models/post_with_comment.dart';
import 'package:disoriza/features/komunitas/domain/usecases/komunitas_usecase.dart';
import 'package:disoriza/features/komunitas/presentation/controllers/komunitas_controller.dart';

import 'komunitas_controller_test.mocks.dart';

void _registerFallbackValues() {
  provideDummy<Either<Exception, List<PostModel>>>(const Right([]));
  provideDummy<Either<Exception, List<CommentModel>>>(const Right([]));
  provideDummy<Either<Exception, List<PostWithCommentModel>>>(const Right([]));
  provideDummy<Either<Exception, void>>(const Right(null));
}

@GenerateMocks([KomunitasUsecase])
void main() {
  late KomunitasController controller;
  late MockKomunitasUsecase mockUsecase;

  setUp(() {
    _registerFallbackValues();
    Get.testMode = true;
    mockUsecase = MockKomunitasUsecase();
    controller = KomunitasController(mockUsecase);
  });

  tearDown(() {
    Get.reset();
  });

  // Test data
  final tPostList = [
    const PostModel(id: 1, title: 'Post 1'),
    const PostModel(id: 2, title: 'Post 2'),
  ];

  final tCommentList = [
    const CommentModel(id: 1, content: 'Comment 1'),
    const CommentModel(id: 2, content: 'Comment 2'),
  ];

  final tPostWithCommentList = [
    PostWithCommentModel(
      postModel: tPostList[0],
      commentModel: tCommentList[0],
    ),
  ];

  // ============================================================
  // POSTS OPERATIONS TESTS
  // ============================================================

  group('fetchAllPosts', () {
    test('should set posts and postsStatus to success on successful fetch', () async {
      when(mockUsecase.fetchAllPosts(
        latest: anyNamed('latest'),
        max: anyNamed('max'),
      )).thenAnswer((_) async => Right(tPostList));

      await controller.fetchAllPosts();

      expect(controller.posts.length, 2);
      expect(controller.postsStatus.value, Status.success);
      verify(mockUsecase.fetchAllPosts(latest: false, max: null)).called(1);
    });

    test('should set errorMessage and postsStatus to error on failed fetch', () async {
      when(mockUsecase.fetchAllPosts(
        latest: anyNamed('latest'),
        max: anyNamed('max'),
      )).thenAnswer((_) async => Left(Exception('Failed to fetch')));

      await controller.fetchAllPosts();

      expect(controller.errorMessage.value, contains('Failed to fetch'));
      expect(controller.postsStatus.value, Status.error);
    });

    test('should set postsStatus to loading while fetching', () async {
      when(mockUsecase.fetchAllPosts(
        latest: anyNamed('latest'),
        max: anyNamed('max'),
      )).thenAnswer((_) async {
        expect(controller.postsStatus.value, Status.loading);
        return Right(tPostList);
      });

      await controller.fetchAllPosts();
    });

    test('should pass latest and max parameters correctly', () async {
      when(mockUsecase.fetchAllPosts(
        latest: anyNamed('latest'),
        max: anyNamed('max'),
      )).thenAnswer((_) async => Right(tPostList));

      await controller.fetchAllPosts(latest: true, max: 5);

      verify(mockUsecase.fetchAllPosts(latest: true, max: 5)).called(1);
    });
  });

  group('fetchReportedPosts', () {
    test('should set reportedPosts and postsStatus to success on successful fetch', () async {
      when(mockUsecase.fetchReportedPosts())
          .thenAnswer((_) async => Right(tPostList));

      await controller.fetchReportedPosts();

      expect(controller.reportedPosts.length, 2);
      expect(controller.postsStatus.value, Status.success);
    });

    test('should set errorMessage and postsStatus to error on failed fetch', () async {
      when(mockUsecase.fetchReportedPosts())
          .thenAnswer((_) async => Left(Exception('Failed to fetch reported')));

      await controller.fetchReportedPosts();

      expect(controller.errorMessage.value, contains('Failed to fetch reported'));
      expect(controller.postsStatus.value, Status.error);
    });
  });

  group('fetchReportedComments', () {
    test('should set reportedComments and commentsStatus to success on successful fetch', () async {
      when(mockUsecase.fetchReportedComments())
          .thenAnswer((_) async => Right(tPostWithCommentList));

      await controller.fetchReportedComments();

      expect(controller.reportedComments.length, 1);
      expect(controller.commentsStatus.value, Status.success);
    });

    test('should set errorMessage and commentsStatus to error on failed fetch', () async {
      when(mockUsecase.fetchReportedComments())
          .thenAnswer((_) async => Left(Exception('Failed to fetch reported comments')));

      await controller.fetchReportedComments();

      expect(controller.errorMessage.value, contains('Failed to fetch reported comments'));
      expect(controller.commentsStatus.value, Status.error);
    });
  });

  group('fetchAktivitas', () {
    test('should set posts and postsStatus to success on successful fetch', () async {
      when(mockUsecase.fetchAktivitas(
        uid: anyNamed('uid'),
        filter: anyNamed('filter'),
      )).thenAnswer((_) async => Right(tPostList));

      await controller.fetchAktivitas(uid: 'user1', filter: 'Postingan');

      expect(controller.posts.length, 2);
      expect(controller.postsStatus.value, Status.success);
    });

    test('should set errorMessage and postsStatus to error on failed fetch', () async {
      when(mockUsecase.fetchAktivitas(
        uid: anyNamed('uid'),
        filter: anyNamed('filter'),
      )).thenAnswer((_) async => Left(Exception('Failed to fetch aktivitas')));

      await controller.fetchAktivitas(uid: 'user1', filter: 'Postingan');

      expect(controller.errorMessage.value, contains('Failed to fetch aktivitas'));
      expect(controller.postsStatus.value, Status.error);
    });

    test('should pass uid and filter parameters correctly', () async {
      when(mockUsecase.fetchAktivitas(
        uid: anyNamed('uid'),
        filter: anyNamed('filter'),
      )).thenAnswer((_) async => Right(tPostList));

      await controller.fetchAktivitas(uid: 'user123', filter: 'Disukai');

      verify(mockUsecase.fetchAktivitas(uid: 'user123', filter: 'Disukai')).called(1);
    });
  });

  group('createPost', () {
    test('should set postCreated to true and actionStatus to success on successful create', () async {
      when(mockUsecase.createPost(
        title: anyNamed('title'),
        description: anyNamed('description'),
        uid: anyNamed('uid'),
        image: anyNamed('image'),
      )).thenAnswer((_) async => const Right(null));

      await controller.createPost(
        title: 'Test Title',
        description: 'Test Description',
        uid: 'user1',
      );

      expect(controller.postCreated.value, true);
      expect(controller.actionStatus.value, Status.success);
      expect(controller.lastOperation.value, KomunitasOperation.postCreated);
    });

    test('should set errorMessage and actionStatus to error on failed create', () async {
      when(mockUsecase.createPost(
        title: anyNamed('title'),
        description: anyNamed('description'),
        uid: anyNamed('uid'),
        image: anyNamed('image'),
      )).thenAnswer((_) async => Left(Exception('Create failed')));

      await controller.createPost(
        title: 'Test Title',
        description: 'Test Description',
        uid: 'user1',
      );

      expect(controller.errorMessage.value, contains('Create failed'));
      expect(controller.actionStatus.value, Status.error);
      expect(controller.postCreated.value, false);
    });

    test('should set actionStatus to loading while creating', () async {
      when(mockUsecase.createPost(
        title: anyNamed('title'),
        description: anyNamed('description'),
        uid: anyNamed('uid'),
        image: anyNamed('image'),
      )).thenAnswer((_) async {
        expect(controller.actionStatus.value, Status.loading);
        return const Right(null);
      });

      await controller.createPost(
        title: 'Test',
        description: 'Test',
        uid: 'user1',
      );
    });
  });

  group('deletePost', () {
    test('should set postDeleted to true and actionStatus to success on successful delete', () async {
      when(mockUsecase.deletePost(postId: anyNamed('postId')))
          .thenAnswer((_) async => const Right(null));

      await controller.deletePost(postId: '1');

      expect(controller.postDeleted.value, true);
      expect(controller.actionStatus.value, Status.success);
      expect(controller.lastOperation.value, KomunitasOperation.postDeleted);
    });

    test('should set errorMessage and actionStatus to error on failed delete', () async {
      when(mockUsecase.deletePost(postId: anyNamed('postId')))
          .thenAnswer((_) async => Left(Exception('Delete failed')));

      await controller.deletePost(postId: '1');

      expect(controller.errorMessage.value, contains('Delete failed'));
      expect(controller.actionStatus.value, Status.error);
      expect(controller.postDeleted.value, false);
    });
  });

  group('likePost', () {
    test('should set actionStatus to success and lastOperation to postLiked on successful like', () async {
      when(mockUsecase.likePost(
        uid: anyNamed('uid'),
        postId: anyNamed('postId'),
      )).thenAnswer((_) async => const Right(null));

      await controller.likePost(uid: 'user1', postId: '1');

      expect(controller.actionStatus.value, Status.success);
      expect(controller.lastOperation.value, KomunitasOperation.postLiked);
      expect(controller.errorMessage.value, '');
    });

    test('should set errorMessage and actionStatus to error on failed like', () async {
      when(mockUsecase.likePost(
        uid: anyNamed('uid'),
        postId: anyNamed('postId'),
      )).thenAnswer((_) async => Left(Exception('Like failed')));

      await controller.likePost(uid: 'user1', postId: '1');

      expect(controller.errorMessage.value, contains('Like failed'));
      expect(controller.actionStatus.value, Status.error);
    });

    test('should set actionStatus to loading while liking', () async {
      when(mockUsecase.likePost(
        uid: anyNamed('uid'),
        postId: anyNamed('postId'),
      )).thenAnswer((_) async {
        expect(controller.actionStatus.value, Status.loading);
        return const Right(null);
      });

      await controller.likePost(uid: 'user1', postId: '1');
    });
  });

  group('unlikePost', () {
    test('should set actionStatus to success and lastOperation to postUnliked on successful unlike', () async {
      when(mockUsecase.unlikePost(
        uid: anyNamed('uid'),
        postId: anyNamed('postId'),
      )).thenAnswer((_) async => const Right(null));

      await controller.unlikePost(uid: 'user1', postId: '1');

      expect(controller.actionStatus.value, Status.success);
      expect(controller.lastOperation.value, KomunitasOperation.postUnliked);
      expect(controller.errorMessage.value, '');
    });

    test('should set errorMessage and actionStatus to error on failed unlike', () async {
      when(mockUsecase.unlikePost(
        uid: anyNamed('uid'),
        postId: anyNamed('postId'),
      )).thenAnswer((_) async => Left(Exception('Unlike failed')));

      await controller.unlikePost(uid: 'user1', postId: '1');

      expect(controller.errorMessage.value, contains('Unlike failed'));
      expect(controller.actionStatus.value, Status.error);
    });
  });

  // ============================================================
  // COMMENTS OPERATIONS TESTS
  // ============================================================

  group('fetchComments', () {
    test('should set comments and commentsStatus to success on successful fetch', () async {
      when(mockUsecase.fetchComments(
        postId: anyNamed('postId'),
        latest: anyNamed('latest'),
      )).thenAnswer((_) async => Right(tCommentList));

      await controller.fetchComments(postId: '1');

      expect(controller.comments.length, 2);
      expect(controller.commentsStatus.value, Status.success);
    });

    test('should set errorMessage and commentsStatus to error on failed fetch', () async {
      when(mockUsecase.fetchComments(
        postId: anyNamed('postId'),
        latest: anyNamed('latest'),
      )).thenAnswer((_) async => Left(Exception('Failed to fetch comments')));

      await controller.fetchComments(postId: '1');

      expect(controller.errorMessage.value, contains('Failed to fetch comments'));
      expect(controller.commentsStatus.value, Status.error);
    });

    test('should set commentsStatus to loading while fetching', () async {
      when(mockUsecase.fetchComments(
        postId: anyNamed('postId'),
        latest: anyNamed('latest'),
      )).thenAnswer((_) async {
        expect(controller.commentsStatus.value, Status.loading);
        return Right(tCommentList);
      });

      await controller.fetchComments(postId: '1');
    });
  });

  group('createComment', () {
    test('should refresh comments and set lastOperation on successful create', () async {
      final comment = CommentModel(idPost: 1, content: 'Test comment');

      when(mockUsecase.createComment(comment: anyNamed('comment')))
          .thenAnswer((_) async => const Right(null));
      when(mockUsecase.fetchComments(
        postId: anyNamed('postId'),
        latest: anyNamed('latest'),
      )).thenAnswer((_) async => Right(tCommentList));

      await controller.createComment(comment: comment);

      expect(controller.lastOperation.value, KomunitasOperation.commentCreated);
      verify(mockUsecase.fetchComments(postId: '1', latest: false)).called(1);
    });

    test('should set errorMessage and commentsStatus to error on failed create', () async {
      final comment = CommentModel(idPost: 1, content: 'Test comment');

      when(mockUsecase.createComment(comment: anyNamed('comment')))
          .thenAnswer((_) async => Left(Exception('Create comment failed')));

      await controller.createComment(comment: comment);

      expect(controller.errorMessage.value, contains('Create comment failed'));
      expect(controller.commentsStatus.value, Status.error);
    });
  });

  group('deleteComment', () {
    test('should set commentDeleted to true and refresh comments on successful delete', () async {
      when(mockUsecase.deleteComment(commentId: anyNamed('commentId')))
          .thenAnswer((_) async => const Right(null));
      when(mockUsecase.fetchComments(
        postId: anyNamed('postId'),
        latest: anyNamed('latest'),
      )).thenAnswer((_) async => Right(tCommentList));

      await controller.deleteComment(commentId: '1', postId: '1');

      expect(controller.commentDeleted.value, true);
      expect(controller.lastOperation.value, KomunitasOperation.commentDeleted);
      verify(mockUsecase.fetchComments(postId: '1', latest: false)).called(1);
    });

    test('should set errorMessage and commentsStatus to error on failed delete', () async {
      when(mockUsecase.deleteComment(commentId: anyNamed('commentId')))
          .thenAnswer((_) async => Left(Exception('Delete comment failed')));

      await controller.deleteComment(commentId: '1', postId: '1');

      expect(controller.errorMessage.value, contains('Delete comment failed'));
      expect(controller.commentsStatus.value, Status.error);
      expect(controller.commentDeleted.value, false);
    });
  });

  group('likeComment', () {
    test('should set actionStatus to success and lastOperation to commentLiked on successful like', () async {
      when(mockUsecase.likeComment(
        uid: anyNamed('uid'),
        commentId: anyNamed('commentId'),
      )).thenAnswer((_) async => const Right(null));

      await controller.likeComment(uid: 'user1', commentId: '1');

      expect(controller.actionStatus.value, Status.success);
      expect(controller.lastOperation.value, KomunitasOperation.commentLiked);
    });

    test('should set errorMessage and actionStatus to error on failed like', () async {
      when(mockUsecase.likeComment(
        uid: anyNamed('uid'),
        commentId: anyNamed('commentId'),
      )).thenAnswer((_) async => Left(Exception('Like comment failed')));

      await controller.likeComment(uid: 'user1', commentId: '1');

      expect(controller.errorMessage.value, contains('Like comment failed'));
      expect(controller.actionStatus.value, Status.error);
    });
  });

  group('unlikeComment', () {
    test('should set actionStatus to success and lastOperation to commentUnliked on successful unlike', () async {
      when(mockUsecase.unlikeComment(
        uid: anyNamed('uid'),
        commentId: anyNamed('commentId'),
      )).thenAnswer((_) async => const Right(null));

      await controller.unlikeComment(uid: 'user1', commentId: '1');

      expect(controller.actionStatus.value, Status.success);
      expect(controller.lastOperation.value, KomunitasOperation.commentUnliked);
    });

    test('should set errorMessage and actionStatus to error on failed unlike', () async {
      when(mockUsecase.unlikeComment(
        uid: anyNamed('uid'),
        commentId: anyNamed('commentId'),
      )).thenAnswer((_) async => Left(Exception('Unlike comment failed')));

      await controller.unlikeComment(uid: 'user1', commentId: '1');

      expect(controller.errorMessage.value, contains('Unlike comment failed'));
      expect(controller.actionStatus.value, Status.error);
    });
  });

  // ============================================================
  // SEARCH OPERATIONS TESTS
  // ============================================================

  group('searchPost', () {
    test('should set searchResults and searchStatus to success on successful search', () async {
      when(mockUsecase.searchPost(search: anyNamed('search')))
          .thenAnswer((_) async => Right(tPostList));

      await controller.searchPost(search: 'test');

      expect(controller.searchResults.length, 2);
      expect(controller.searchStatus.value, Status.success);
    });

    test('should set errorMessage and searchStatus to error on failed search', () async {
      when(mockUsecase.searchPost(search: anyNamed('search')))
          .thenAnswer((_) async => Left(Exception('Search failed')));

      await controller.searchPost(search: 'test');

      expect(controller.errorMessage.value, contains('Search failed'));
      expect(controller.searchStatus.value, Status.error);
    });

    test('should set searchStatus to loading while searching', () async {
      when(mockUsecase.searchPost(search: anyNamed('search')))
          .thenAnswer((_) async {
        expect(controller.searchStatus.value, Status.loading);
        return Right(tPostList);
      });

      await controller.searchPost(search: 'test');
    });
  });

  group('clearSearch', () {
    test('should clear searchResults, reset searchStatus and errorMessage', () async {
      // First populate search results
      when(mockUsecase.searchPost(search: anyNamed('search')))
          .thenAnswer((_) async => Right(tPostList));
      await controller.searchPost(search: 'test');

      expect(controller.searchResults.length, 2);

      // Now clear
      controller.clearSearch();

      expect(controller.searchResults.length, 0);
      expect(controller.searchStatus.value, Status.initial);
      expect(controller.errorMessage.value, '');
    });
  });

  // ============================================================
  // REPORT OPERATIONS TESTS
  // ============================================================

  group('reportPost', () {
    test('should set postReported to true and actionStatus to success on successful report', () async {
      when(mockUsecase.reportPost(
        uid: anyNamed('uid'),
        postId: anyNamed('postId'),
        reason: anyNamed('reason'),
      )).thenAnswer((_) async => const Right(null));

      await controller.reportPost(uid: 'user1', postId: '1');

      expect(controller.postReported.value, true);
      expect(controller.actionStatus.value, Status.success);
      expect(controller.lastOperation.value, KomunitasOperation.postReported);
    });

    test('should set errorMessage and actionStatus to error on failed report', () async {
      when(mockUsecase.reportPost(
        uid: anyNamed('uid'),
        postId: anyNamed('postId'),
        reason: anyNamed('reason'),
      )).thenAnswer((_) async => Left(Exception('Report failed')));

      await controller.reportPost(uid: 'user1', postId: '1');

      expect(controller.errorMessage.value, contains('Report failed'));
      expect(controller.actionStatus.value, Status.error);
      expect(controller.postReported.value, false);
    });

    test('should pass reason parameter correctly', () async {
      when(mockUsecase.reportPost(
        uid: anyNamed('uid'),
        postId: anyNamed('postId'),
        reason: anyNamed('reason'),
      )).thenAnswer((_) async => const Right(null));

      await controller.reportPost(uid: 'user1', postId: '1', reason: 'Spam content');

      verify(mockUsecase.reportPost(
        uid: 'user1',
        postId: '1',
        reason: 'Spam content',
      )).called(1);
    });
  });

  group('reportComment', () {
    test('should set commentReported to true and actionStatus to success on successful report', () async {
      when(mockUsecase.reportComment(
        uid: anyNamed('uid'),
        commentId: anyNamed('commentId'),
        reason: anyNamed('reason'),
      )).thenAnswer((_) async => const Right(null));

      await controller.reportComment(uid: 'user1', commentId: '1');

      expect(controller.commentReported.value, true);
      expect(controller.actionStatus.value, Status.success);
      expect(controller.lastOperation.value, KomunitasOperation.commentReported);
    });

    test('should set errorMessage and actionStatus to error on failed report', () async {
      when(mockUsecase.reportComment(
        uid: anyNamed('uid'),
        commentId: anyNamed('commentId'),
        reason: anyNamed('reason'),
      )).thenAnswer((_) async => Left(Exception('Report comment failed')));

      await controller.reportComment(uid: 'user1', commentId: '1');

      expect(controller.errorMessage.value, contains('Report comment failed'));
      expect(controller.actionStatus.value, Status.error);
      expect(controller.commentReported.value, false);
    });

    test('should pass reason parameter correctly', () async {
      when(mockUsecase.reportComment(
        uid: anyNamed('uid'),
        commentId: anyNamed('commentId'),
        reason: anyNamed('reason'),
      )).thenAnswer((_) async => const Right(null));

      await controller.reportComment(uid: 'user1', commentId: '1', reason: 'Offensive language');

      verify(mockUsecase.reportComment(
        uid: 'user1',
        commentId: '1',
        reason: 'Offensive language',
      )).called(1);
    });
  });

  // ============================================================
  // UTILITY TESTS
  // ============================================================

  group('resetState', () {
    test('should reset all state to initial values', () async {
      // Set non-list state values
      controller.postsStatus.value = Status.success;
      controller.commentsStatus.value = Status.success;
      controller.searchStatus.value = Status.success;
      controller.actionStatus.value = Status.success;
      controller.errorMessage.value = 'Some error';
      controller.lastOperation.value = KomunitasOperation.postCreated;
      controller.postCreated.value = true;
      controller.postDeleted.value = true;
      controller.commentDeleted.value = true;
      controller.postReported.value = true;
      controller.commentReported.value = true;

      // Verify state is set
      expect(controller.postsStatus.value, Status.success);
      expect(controller.errorMessage.value, 'Some error');
      expect(controller.postCreated.value, true);

      // Now reset
      controller.resetState();

      expect(controller.posts.length, 0);
      expect(controller.comments.length, 0);
      expect(controller.searchResults.length, 0);
      expect(controller.reportedPosts.length, 0);
      expect(controller.reportedComments.length, 0);
      expect(controller.postsStatus.value, Status.initial);
      expect(controller.commentsStatus.value, Status.initial);
      expect(controller.searchStatus.value, Status.initial);
      expect(controller.actionStatus.value, Status.initial);
      expect(controller.errorMessage.value, '');
      expect(controller.lastOperation.value, null);
      expect(controller.postCreated.value, false);
      expect(controller.postDeleted.value, false);
      expect(controller.commentDeleted.value, false);
      expect(controller.postReported.value, false);
      expect(controller.commentReported.value, false);
    });
  });

  group('error message cleaning', () {
    test('should clean exception prefix from error message', () async {
      when(mockUsecase.fetchAllPosts(
        latest: anyNamed('latest'),
        max: anyNamed('max'),
      )).thenAnswer((_) async => Left(Exception('Test error message')));

      await controller.fetchAllPosts();

      expect(controller.errorMessage.value, 'Test error message');
      expect(controller.errorMessage.value.contains('Exception:'), false);
    });
  });

  group('status isolation', () {
    test('postsStatus should not affect commentsStatus', () async {
      when(mockUsecase.fetchAllPosts(
        latest: anyNamed('latest'),
        max: anyNamed('max'),
      )).thenAnswer((_) async => Right(tPostList));

      controller.commentsStatus.value = Status.success;

      await controller.fetchAllPosts();

      expect(controller.postsStatus.value, Status.success);
      expect(controller.commentsStatus.value, Status.success);
    });

    test('searchStatus should not affect postsStatus', () async {
      when(mockUsecase.searchPost(search: anyNamed('search')))
          .thenAnswer((_) async => Right(tPostList));

      controller.postsStatus.value = Status.success;

      await controller.searchPost(search: 'test');

      expect(controller.searchStatus.value, Status.success);
      expect(controller.postsStatus.value, Status.success);
    });
  });

  group('empty list handling', () {
    test('should handle empty posts list', () async {
      when(mockUsecase.fetchAllPosts(
        latest: anyNamed('latest'),
        max: anyNamed('max'),
      )).thenAnswer((_) async => const Right([]));

      await controller.fetchAllPosts();

      expect(controller.posts.length, 0);
      expect(controller.postsStatus.value, Status.success);
    });

    test('should handle empty comments list', () async {
      when(mockUsecase.fetchComments(
        postId: anyNamed('postId'),
        latest: anyNamed('latest'),
      )).thenAnswer((_) async => const Right([]));

      await controller.fetchComments(postId: '1');

      expect(controller.comments.length, 0);
      expect(controller.commentsStatus.value, Status.success);
    });

    test('should handle empty search results', () async {
      when(mockUsecase.searchPost(search: anyNamed('search')))
          .thenAnswer((_) async => const Right([]));

      await controller.searchPost(search: 'nonexistent');

      expect(controller.searchResults.length, 0);
      expect(controller.searchStatus.value, Status.success);
    });
  });
}
