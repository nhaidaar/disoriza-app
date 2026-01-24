import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:disoriza/features/komunitas/data/models/comment_model.dart';
import 'package:disoriza/features/komunitas/data/models/post_model.dart';
import 'package:disoriza/features/komunitas/data/models/post_with_comment.dart';
import 'package:disoriza/features/komunitas/domain/repositories/komunitas_repository.dart';
import 'package:disoriza/features/komunitas/domain/usecases/komunitas_usecase.dart';

import 'komunitas_usecase_test.mocks.dart';

void _registerFallbackValues() {
  provideDummy<Either<Exception, List<PostModel>>>(const Right([]));
  provideDummy<Either<Exception, List<CommentModel>>>(const Right([]));
  provideDummy<Either<Exception, List<PostWithCommentModel>>>(const Right([]));
  provideDummy<Either<Exception, void>>(const Right(null));
}

@GenerateMocks([KomunitasRepository])
void main() {
  late KomunitasUsecase usecase;
  late MockKomunitasRepository mockRepository;

  setUp(() {
    _registerFallbackValues();
    mockRepository = MockKomunitasRepository();
    usecase = KomunitasUsecase(mockRepository);
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

  final tComment = CommentModel(idPost: 1, content: 'Test comment');
  final tImage = Uint8List.fromList([1, 2, 3, 4]);

  group('fetchAllPosts', () {
    test('should delegate to repository with correct parameters', () async {
      when(mockRepository.fetchAllPosts(
        latest: anyNamed('latest'),
        max: anyNamed('max'),
      )).thenAnswer((_) async => Right(tPostList));

      final result = await usecase.fetchAllPosts(latest: true, max: 5);

      verify(mockRepository.fetchAllPosts(latest: true, max: 5)).called(1);
      expect(result.isRight(), true);
    });

    test('should return repository result unchanged', () async {
      when(mockRepository.fetchAllPosts(
        latest: anyNamed('latest'),
        max: anyNamed('max'),
      )).thenAnswer((_) async => Right(tPostList));

      final result = await usecase.fetchAllPosts();

      result.fold(
        (l) => fail('Should not return Left'),
        (r) => expect(r, tPostList),
      );
    });
  });

  group('fetchReportedPosts', () {
    test('should delegate to repository', () async {
      when(mockRepository.fetchReportedPosts())
          .thenAnswer((_) async => Right(tPostList));

      final result = await usecase.fetchReportedPosts();

      verify(mockRepository.fetchReportedPosts()).called(1);
      expect(result.isRight(), true);
    });
  });

  group('fetchAktivitas', () {
    test('should delegate to repository with correct parameters', () async {
      when(mockRepository.fetchAktivitas(
        uid: anyNamed('uid'),
        filter: anyNamed('filter'),
      )).thenAnswer((_) async => Right(tPostList));

      final result = await usecase.fetchAktivitas(uid: 'user1', filter: 'Postingan');

      verify(mockRepository.fetchAktivitas(uid: 'user1', filter: 'Postingan')).called(1);
      expect(result.isRight(), true);
    });
  });

  group('searchPost', () {
    test('should delegate to repository with correct parameters', () async {
      when(mockRepository.searchPost(search: anyNamed('search')))
          .thenAnswer((_) async => Right(tPostList));

      final result = await usecase.searchPost(search: 'test query');

      verify(mockRepository.searchPost(search: 'test query')).called(1);
      expect(result.isRight(), true);
    });
  });

  group('createPost', () {
    test('should delegate to repository with correct parameters', () async {
      when(mockRepository.createPost(
        title: anyNamed('title'),
        description: anyNamed('description'),
        uid: anyNamed('uid'),
        image: anyNamed('image'),
      )).thenAnswer((_) async => const Right(null));

      final result = await usecase.createPost(
        title: 'Test Title',
        description: 'Test Description',
        uid: 'user1',
        image: tImage,
      );

      verify(mockRepository.createPost(
        title: 'Test Title',
        description: 'Test Description',
        uid: 'user1',
        image: tImage,
      )).called(1);
      expect(result.isRight(), true);
    });

    test('should handle null image', () async {
      when(mockRepository.createPost(
        title: anyNamed('title'),
        description: anyNamed('description'),
        uid: anyNamed('uid'),
        image: anyNamed('image'),
      )).thenAnswer((_) async => const Right(null));

      final result = await usecase.createPost(
        title: 'Test Title',
        description: 'Test Description',
        uid: 'user1',
        image: null,
      );

      verify(mockRepository.createPost(
        title: 'Test Title',
        description: 'Test Description',
        uid: 'user1',
        image: null,
      )).called(1);
      expect(result.isRight(), true);
    });
  });

  group('deletePost', () {
    test('should delegate to repository with correct parameters', () async {
      when(mockRepository.deletePost(postId: anyNamed('postId')))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase.deletePost(postId: '123');

      verify(mockRepository.deletePost(postId: '123')).called(1);
      expect(result.isRight(), true);
    });
  });

  group('likePost', () {
    test('should delegate to repository with correct parameters', () async {
      when(mockRepository.likePost(
        uid: anyNamed('uid'),
        postId: anyNamed('postId'),
      )).thenAnswer((_) async => const Right(null));

      final result = await usecase.likePost(uid: 'user1', postId: '123');

      verify(mockRepository.likePost(uid: 'user1', postId: '123')).called(1);
      expect(result.isRight(), true);
    });
  });

  group('unlikePost', () {
    test('should delegate to repository with correct parameters', () async {
      when(mockRepository.unlikePost(
        uid: anyNamed('uid'),
        postId: anyNamed('postId'),
      )).thenAnswer((_) async => const Right(null));

      final result = await usecase.unlikePost(uid: 'user1', postId: '123');

      verify(mockRepository.unlikePost(uid: 'user1', postId: '123')).called(1);
      expect(result.isRight(), true);
    });
  });

  group('reportPost', () {
    test('should delegate to repository with correct parameters', () async {
      when(mockRepository.reportPost(
        uid: anyNamed('uid'),
        postId: anyNamed('postId'),
        reason: anyNamed('reason'),
      )).thenAnswer((_) async => const Right(null));

      final result = await usecase.reportPost(uid: 'user1', postId: '123');

      verify(mockRepository.reportPost(uid: 'user1', postId: '123', reason: null)).called(1);
      expect(result.isRight(), true);
    });

    test('should pass reason parameter to repository', () async {
      when(mockRepository.reportPost(
        uid: anyNamed('uid'),
        postId: anyNamed('postId'),
        reason: anyNamed('reason'),
      )).thenAnswer((_) async => const Right(null));

      final result = await usecase.reportPost(
        uid: 'user1',
        postId: '123',
        reason: 'Spam content',
      );

      verify(mockRepository.reportPost(
        uid: 'user1',
        postId: '123',
        reason: 'Spam content',
      )).called(1);
      expect(result.isRight(), true);
    });
  });

  group('fetchComments', () {
    test('should delegate to repository with correct parameters', () async {
      when(mockRepository.fetchComments(
        postId: anyNamed('postId'),
        latest: anyNamed('latest'),
      )).thenAnswer((_) async => Right(tCommentList));

      final result = await usecase.fetchComments(postId: '123', latest: true);

      verify(mockRepository.fetchComments(postId: '123', latest: true)).called(1);
      expect(result.isRight(), true);
    });
  });

  group('fetchReportedComments', () {
    test('should delegate to repository', () async {
      when(mockRepository.fetchReportedComments())
          .thenAnswer((_) async => Right(tPostWithCommentList));

      final result = await usecase.fetchReportedComments();

      verify(mockRepository.fetchReportedComments()).called(1);
      expect(result.isRight(), true);
    });
  });

  group('createComment', () {
    test('should delegate to repository with correct parameters', () async {
      when(mockRepository.createComment(comment: anyNamed('comment')))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase.createComment(comment: tComment);

      verify(mockRepository.createComment(comment: tComment)).called(1);
      expect(result.isRight(), true);
    });
  });

  group('deleteComment', () {
    test('should delegate to repository with correct parameters', () async {
      when(mockRepository.deleteComment(commentId: anyNamed('commentId')))
          .thenAnswer((_) async => const Right(null));

      final result = await usecase.deleteComment(commentId: '456');

      verify(mockRepository.deleteComment(commentId: '456')).called(1);
      expect(result.isRight(), true);
    });
  });

  group('likeComment', () {
    test('should delegate to repository with correct parameters', () async {
      when(mockRepository.likeComment(
        uid: anyNamed('uid'),
        commentId: anyNamed('commentId'),
      )).thenAnswer((_) async => const Right(null));

      final result = await usecase.likeComment(uid: 'user1', commentId: '456');

      verify(mockRepository.likeComment(uid: 'user1', commentId: '456')).called(1);
      expect(result.isRight(), true);
    });
  });

  group('unlikeComment', () {
    test('should delegate to repository with correct parameters', () async {
      when(mockRepository.unlikeComment(
        uid: anyNamed('uid'),
        commentId: anyNamed('commentId'),
      )).thenAnswer((_) async => const Right(null));

      final result = await usecase.unlikeComment(uid: 'user1', commentId: '456');

      verify(mockRepository.unlikeComment(uid: 'user1', commentId: '456')).called(1);
      expect(result.isRight(), true);
    });
  });

  group('reportComment', () {
    test('should delegate to repository with correct parameters', () async {
      when(mockRepository.reportComment(
        uid: anyNamed('uid'),
        commentId: anyNamed('commentId'),
        reason: anyNamed('reason'),
      )).thenAnswer((_) async => const Right(null));

      final result = await usecase.reportComment(uid: 'user1', commentId: '456');

      verify(mockRepository.reportComment(uid: 'user1', commentId: '456', reason: null)).called(1);
      expect(result.isRight(), true);
    });

    test('should pass reason parameter to repository', () async {
      when(mockRepository.reportComment(
        uid: anyNamed('uid'),
        commentId: anyNamed('commentId'),
        reason: anyNamed('reason'),
      )).thenAnswer((_) async => const Right(null));

      final result = await usecase.reportComment(
        uid: 'user1',
        commentId: '456',
        reason: 'Offensive language',
      );

      verify(mockRepository.reportComment(
        uid: 'user1',
        commentId: '456',
        reason: 'Offensive language',
      )).called(1);
      expect(result.isRight(), true);
    });
  });

  group('error propagation', () {
    test('should propagate repository errors unchanged', () async {
      final exception = Exception('Repository error');
      when(mockRepository.fetchAllPosts(
        latest: anyNamed('latest'),
        max: anyNamed('max'),
      )).thenAnswer((_) async => Left(exception));

      final result = await usecase.fetchAllPosts();

      result.fold(
        (l) => expect(l.toString(), contains('Repository error')),
        (r) => fail('Should return Left'),
      );
    });
  });
}
