import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:disoriza/core/enums/status.dart';
import 'package:disoriza/features/komunitas/data/models/comment_model.dart';
import 'package:disoriza/features/komunitas/domain/usecases/komunitas_usecase.dart';
import 'package:disoriza/features/komunitas/presentation/controllers/komunitas_comment_controller.dart';

import 'komunitas_comment_controller_test.mocks.dart';

void _registerFallbackValues() {
  provideDummy<Either<Exception, List<CommentModel>>>(const Right([]));
  provideDummy<Either<Exception, void>>(const Right(null));
}

@GenerateMocks([KomunitasUsecase])
void main() {
  late KomunitasCommentController controller;
  late MockKomunitasUsecase mockKomunitasUsecase;

  setUp(() {
    _registerFallbackValues();
    Get.testMode = true;
    mockKomunitasUsecase = MockKomunitasUsecase();
    controller = KomunitasCommentController(mockKomunitasUsecase);
  });

  tearDown(() {
    Get.reset();
  });

  final tCommentList = [
    CommentModel(id: 1, idPost: 1, content: 'Comment 1'),
    CommentModel(id: 2, idPost: 1, content: 'Comment 2'),
  ];

  group('fetchComments', () {
    test('should set comments and status to success on successful fetch', () async {
      when(mockKomunitasUsecase.fetchComments(
        postId: anyNamed('postId'),
        latest: anyNamed('latest'),
      )).thenAnswer((_) async => Right(tCommentList));

      await controller.fetchComments(postId: 'post1');

      expect(controller.comments.length, 2);
      expect(controller.status.value, Status.success);
    });

    test('should set errorMessage and status to error on failed fetch', () async {
      when(mockKomunitasUsecase.fetchComments(
        postId: anyNamed('postId'),
        latest: anyNamed('latest'),
      )).thenAnswer((_) async => Left(Exception('Failed to fetch')));

      await controller.fetchComments(postId: 'post1');

      expect(controller.errorMessage.value, contains('Failed to fetch'));
      expect(controller.status.value, Status.error);
    });
  });

  group('deleteComment', () {
    test('should set commentDeleted to true on successful delete', () async {
      when(mockKomunitasUsecase.deleteComment(commentId: anyNamed('commentId')))
          .thenAnswer((_) async => const Right(null));
      when(mockKomunitasUsecase.fetchComments(
        postId: anyNamed('postId'),
        latest: anyNamed('latest'),
      )).thenAnswer((_) async => Right(tCommentList));

      await controller.deleteComment(commentId: '1', postId: 'post1');

      expect(controller.commentDeleted.value, true);
    });

    test('should set errorMessage and status to error on failed delete', () async {
      when(mockKomunitasUsecase.deleteComment(commentId: anyNamed('commentId')))
          .thenAnswer((_) async => Left(Exception('Delete failed')));

      await controller.deleteComment(commentId: '1', postId: 'post1');

      expect(controller.errorMessage.value, contains('Delete failed'));
      expect(controller.status.value, Status.error);
    });
  });

  group('likeComment', () {
    test('should not set error on successful like', () async {
      when(mockKomunitasUsecase.likeComment(
        uid: anyNamed('uid'),
        commentId: anyNamed('commentId'),
      )).thenAnswer((_) async => const Right(null));

      await controller.likeComment(uid: 'user1', commentId: '1');

      expect(controller.errorMessage.value, '');
    });
  });

  group('unlikeComment', () {
    test('should not set error on successful unlike', () async {
      when(mockKomunitasUsecase.unlikeComment(
        uid: anyNamed('uid'),
        commentId: anyNamed('commentId'),
      )).thenAnswer((_) async => const Right(null));

      await controller.unlikeComment(uid: 'user1', commentId: '1');

      expect(controller.errorMessage.value, '');
    });
  });
}
