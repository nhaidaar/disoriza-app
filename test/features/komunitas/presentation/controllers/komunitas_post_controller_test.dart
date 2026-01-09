import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:disoriza/core/enums/status.dart';
import 'package:disoriza/features/komunitas/data/models/post_model.dart';
import 'package:disoriza/features/komunitas/domain/usecases/komunitas_usecase.dart';
import 'package:disoriza/features/komunitas/presentation/controllers/komunitas_post_controller.dart';

import 'komunitas_post_controller_test.mocks.dart';

void _registerFallbackValues() {
  provideDummy<Either<Exception, List<PostModel>>>(const Right([]));
  provideDummy<Either<Exception, void>>(const Right(null));
}

@GenerateMocks([KomunitasUsecase])
void main() {
  late KomunitasPostController controller;
  late MockKomunitasUsecase mockKomunitasUsecase;

  setUp(() {
    _registerFallbackValues();
    Get.testMode = true;
    mockKomunitasUsecase = MockKomunitasUsecase();
    controller = KomunitasPostController(mockKomunitasUsecase);
  });

  tearDown(() {
    Get.reset();
  });

  final tPostList = [
    PostModel(id: 1, title: 'Post 1'),
    PostModel(id: 2, title: 'Post 2'),
  ];

  group('fetchAllPosts', () {
    test('should set posts and status to success on successful fetch', () async {
      when(mockKomunitasUsecase.fetchAllPosts(
        latest: anyNamed('latest'),
        max: anyNamed('max'),
      )).thenAnswer((_) async => Right(tPostList));

      await controller.fetchAllPosts();

      expect(controller.posts.length, 2);
      expect(controller.status.value, Status.success);
    });

    test('should set errorMessage and status to error on failed fetch', () async {
      when(mockKomunitasUsecase.fetchAllPosts(
        latest: anyNamed('latest'),
        max: anyNamed('max'),
      )).thenAnswer((_) async => Left(Exception('Failed to fetch')));

      await controller.fetchAllPosts();

      expect(controller.errorMessage.value, contains('Failed to fetch'));
      expect(controller.status.value, Status.error);
    });

    test('should set status to loading while fetching', () async {
      when(mockKomunitasUsecase.fetchAllPosts(
        latest: anyNamed('latest'),
        max: anyNamed('max'),
      )).thenAnswer((_) async {
        expect(controller.status.value, Status.loading);
        return Right(tPostList);
      });

      await controller.fetchAllPosts();
    });
  });

  group('createPost', () {
    test('should set postCreated to true and status to success on successful create', () async {
      when(mockKomunitasUsecase.createPost(
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
      expect(controller.status.value, Status.success);
    });

    test('should set errorMessage and status to error on failed create', () async {
      when(mockKomunitasUsecase.createPost(
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
      expect(controller.status.value, Status.error);
    });
  });

  group('deletePost', () {
    test('should set postDeleted to true and status to success on successful delete', () async {
      when(mockKomunitasUsecase.deletePost(postId: anyNamed('postId')))
          .thenAnswer((_) async => const Right(null));

      await controller.deletePost(postId: '1');

      expect(controller.postDeleted.value, true);
      expect(controller.status.value, Status.success);
    });

    test('should set errorMessage and status to error on failed delete', () async {
      when(mockKomunitasUsecase.deletePost(postId: anyNamed('postId')))
          .thenAnswer((_) async => Left(Exception('Delete failed')));

      await controller.deletePost(postId: '1');

      expect(controller.errorMessage.value, contains('Delete failed'));
      expect(controller.status.value, Status.error);
    });
  });

  group('likePost', () {
    test('should not set error on successful like', () async {
      when(mockKomunitasUsecase.likePost(
        uid: anyNamed('uid'),
        postId: anyNamed('postId'),
      )).thenAnswer((_) async => const Right(null));

      await controller.likePost(uid: 'user1', postId: '1');

      expect(controller.errorMessage.value, '');
    });

    test('should set errorMessage on failed like', () async {
      when(mockKomunitasUsecase.likePost(
        uid: anyNamed('uid'),
        postId: anyNamed('postId'),
      )).thenAnswer((_) async => Left(Exception('Like failed')));

      await controller.likePost(uid: 'user1', postId: '1');

      expect(controller.errorMessage.value, contains('Like failed'));
    });
  });

  group('unlikePost', () {
    test('should not set error on successful unlike', () async {
      when(mockKomunitasUsecase.unlikePost(
        uid: anyNamed('uid'),
        postId: anyNamed('postId'),
      )).thenAnswer((_) async => const Right(null));

      await controller.unlikePost(uid: 'user1', postId: '1');

      expect(controller.errorMessage.value, '');
    });

    test('should set errorMessage on failed unlike', () async {
      when(mockKomunitasUsecase.unlikePost(
        uid: anyNamed('uid'),
        postId: anyNamed('postId'),
      )).thenAnswer((_) async => Left(Exception('Unlike failed')));

      await controller.unlikePost(uid: 'user1', postId: '1');

      expect(controller.errorMessage.value, contains('Unlike failed'));
    });
  });

  group('fetchAktivitas', () {
    test('should set posts and status to success on successful fetch', () async {
      when(mockKomunitasUsecase.fetchAktivitas(
        uid: anyNamed('uid'),
        filter: anyNamed('filter'),
      )).thenAnswer((_) async => Right(tPostList));

      await controller.fetchAktivitas(uid: 'user1', filter: 'all');

      expect(controller.posts.length, 2);
      expect(controller.status.value, Status.success);
    });
  });
}
