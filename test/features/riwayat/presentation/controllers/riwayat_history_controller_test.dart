import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:disoriza/core/enums/status.dart';
import 'package:disoriza/features/riwayat/data/models/riwayat_model.dart';
import 'package:disoriza/features/riwayat/domain/usecases/riwayat_usecase.dart';
import 'package:disoriza/features/riwayat/presentation/controllers/riwayat_history_controller.dart';

import 'riwayat_history_controller_test.mocks.dart';

void _registerFallbackValues() {
  provideDummy<Either<Exception, List<RiwayatModel>>>(const Right([]));
  provideDummy<Either<Exception, void>>(const Right(null));
}

@GenerateMocks([RiwayatUsecase])
void main() {
  late RiwayatHistoryController controller;
  late MockRiwayatUsecase mockRiwayatUsecase;

  setUp(() {
    _registerFallbackValues();
    Get.testMode = true;
    mockRiwayatUsecase = MockRiwayatUsecase();
    controller = RiwayatHistoryController(mockRiwayatUsecase);
  });

  tearDown(() {
    Get.reset();
  });

  final tRiwayatList = [
    RiwayatModel(id: 1, idUser: 'user1'),
    RiwayatModel(id: 2, idUser: 'user1'),
  ];

  group('fetchRiwayat', () {
    test('should set riwayat list and status to success on successful fetch', () async {
      when(mockRiwayatUsecase.fetchAllRiwayat(
        uid: anyNamed('uid'),
        max: anyNamed('max'),
      )).thenAnswer((_) async => Right(tRiwayatList));

      await controller.fetchRiwayat(uid: 'user1');

      expect(controller.riwayat.length, 2);
      expect(controller.status.value, Status.success);
      verify(mockRiwayatUsecase.fetchAllRiwayat(uid: 'user1', max: null)).called(1);
    });

    test('should set errorMessage and status to error on failed fetch', () async {
      when(mockRiwayatUsecase.fetchAllRiwayat(
        uid: anyNamed('uid'),
        max: anyNamed('max'),
      )).thenAnswer((_) async => Left(Exception('Failed to fetch')));

      await controller.fetchRiwayat(uid: 'user1');

      expect(controller.errorMessage.value, contains('Failed to fetch'));
      expect(controller.status.value, Status.error);
    });

    test('should set status to loading while fetching', () async {
      when(mockRiwayatUsecase.fetchAllRiwayat(
        uid: anyNamed('uid'),
        max: anyNamed('max'),
      )).thenAnswer((_) async {
        expect(controller.status.value, Status.loading);
        return Right(tRiwayatList);
      });

      await controller.fetchRiwayat(uid: 'user1');
    });

    test('should pass max parameter when provided', () async {
      when(mockRiwayatUsecase.fetchAllRiwayat(
        uid: anyNamed('uid'),
        max: anyNamed('max'),
      )).thenAnswer((_) async => Right(tRiwayatList));

      await controller.fetchRiwayat(uid: 'user1', max: 5);

      verify(mockRiwayatUsecase.fetchAllRiwayat(uid: 'user1', max: 5)).called(1);
    });
  });

  group('deleteRiwayat', () {
    test('should set riwayatDeleted to true and status to success on successful delete', () async {
      when(mockRiwayatUsecase.deleteRiwayat(riwayatId: anyNamed('riwayatId')))
          .thenAnswer((_) async => const Right(null));

      await controller.deleteRiwayat(riwayatId: '1');

      expect(controller.riwayatDeleted.value, true);
      expect(controller.status.value, Status.success);
    });

    test('should set errorMessage and status to error on failed delete', () async {
      when(mockRiwayatUsecase.deleteRiwayat(riwayatId: anyNamed('riwayatId')))
          .thenAnswer((_) async => Left(Exception('Delete failed')));

      await controller.deleteRiwayat(riwayatId: '1');

      expect(controller.errorMessage.value, contains('Delete failed'));
      expect(controller.status.value, Status.error);
    });

    test('should reset riwayatDeleted to false before deleting', () async {
      controller.riwayatDeleted.value = true;

      when(mockRiwayatUsecase.deleteRiwayat(riwayatId: anyNamed('riwayatId')))
          .thenAnswer((_) async {
        expect(controller.riwayatDeleted.value, false);
        return const Right(null);
      });

      await controller.deleteRiwayat(riwayatId: '1');
    });
  });
}
