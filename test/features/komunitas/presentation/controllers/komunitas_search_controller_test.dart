import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:disoriza/core/enums/status.dart';
import 'package:disoriza/features/komunitas/data/models/post_model.dart';
import 'package:disoriza/features/komunitas/domain/usecases/komunitas_usecase.dart';
import 'package:disoriza/features/komunitas/presentation/controllers/komunitas_search_controller.dart';

import 'komunitas_search_controller_test.mocks.dart';

void _registerFallbackValues() {
  provideDummy<Either<Exception, List<PostModel>>>(const Right([]));
}

@GenerateMocks([KomunitasUsecase])
void main() {
  late KomunitasSearchController controller;
  late MockKomunitasUsecase mockKomunitasUsecase;

  setUp(() {
    _registerFallbackValues();
    Get.testMode = true;
    mockKomunitasUsecase = MockKomunitasUsecase();
    controller = KomunitasSearchController(mockKomunitasUsecase);
  });

  tearDown(() {
    Get.reset();
  });

  final tPostList = [
    PostModel(id: 1, title: 'Post 1'),
    PostModel(id: 2, title: 'Post 2'),
  ];

  group('searchPost', () {
    test('should set searchResults and status to success on successful search', () async {
      when(mockKomunitasUsecase.searchPost(search: anyNamed('search')))
          .thenAnswer((_) async => Right(tPostList));

      await controller.searchPost(search: 'test');

      expect(controller.searchResults.length, 2);
      expect(controller.status.value, Status.success);
    });

    test('should set errorMessage and status to error on failed search', () async {
      when(mockKomunitasUsecase.searchPost(search: anyNamed('search')))
          .thenAnswer((_) async => Left(Exception('Search failed')));

      await controller.searchPost(search: 'test');

      expect(controller.errorMessage.value, contains('Search failed'));
      expect(controller.status.value, Status.error);
    });

    test('should set status to loading while searching', () async {
      when(mockKomunitasUsecase.searchPost(search: anyNamed('search')))
          .thenAnswer((_) async {
        expect(controller.status.value, Status.loading);
        return Right(tPostList);
      });

      await controller.searchPost(search: 'test');
    });
  });

  group('clearSearch', () {
    test('should clear searchResults and reset status to initial', () {
      controller.searchResults.value = tPostList;
      controller.status.value = Status.success;

      controller.clearSearch();

      expect(controller.searchResults.isEmpty, true);
      expect(controller.status.value, Status.initial);
    });
  });
}
