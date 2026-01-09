import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:disoriza/core/enums/status.dart';
import 'package:disoriza/features/riwayat/data/models/riwayat_model.dart';
import 'package:disoriza/features/riwayat/domain/usecases/riwayat_usecase.dart';
import 'package:disoriza/features/riwayat/presentation/controllers/riwayat_scan_controller.dart';

import 'riwayat_scan_controller_test.mocks.dart';

void _registerFallbackValues() {
  provideDummy<Either<Exception, RiwayatModel?>>(const Right(null));
}

@GenerateMocks([RiwayatUsecase, XFile])
void main() {
  late RiwayatScanController controller;
  late MockRiwayatUsecase mockRiwayatUsecase;
  late MockXFile mockXFile;

  setUp(() {
    _registerFallbackValues();
    Get.testMode = true;
    mockRiwayatUsecase = MockRiwayatUsecase();
    mockXFile = MockXFile();
    controller = RiwayatScanController(mockRiwayatUsecase);
  });

  tearDown(() {
    Get.reset();
  });

  final tRiwayat = RiwayatModel(id: 1, idUser: 'user1');

  group('scanDisease', () {
    test('should set latestScan and status to success on successful scan', () async {
      when(mockRiwayatUsecase.scanDisease(
        uid: anyNamed('uid'),
        image: anyNamed('image'),
      )).thenAnswer((_) async => Right(tRiwayat));

      await controller.scanDisease(uid: 'user1', image: mockXFile);

      expect(controller.latestScan.value, tRiwayat);
      expect(controller.status.value, Status.success);
    });

    test('should set errorMessage and status to error on failed scan', () async {
      when(mockRiwayatUsecase.scanDisease(
        uid: anyNamed('uid'),
        image: anyNamed('image'),
      )).thenAnswer((_) async => Left(Exception('Scan failed')));

      await controller.scanDisease(uid: 'user1', image: mockXFile);

      expect(controller.errorMessage.value, contains('Scan failed'));
      expect(controller.status.value, Status.error);
    });

    test('should set status to loading while scanning', () async {
      when(mockRiwayatUsecase.scanDisease(
        uid: anyNamed('uid'),
        image: anyNamed('image'),
      )).thenAnswer((_) async {
        expect(controller.status.value, Status.loading);
        return Right(tRiwayat);
      });

      await controller.scanDisease(uid: 'user1', image: mockXFile);
    });
  });

  group('resetScan', () {
    test('should reset all values to initial state', () {
      controller.latestScan.value = tRiwayat;
      controller.status.value = Status.success;
      controller.errorMessage.value = 'Some error';

      controller.resetScan();

      expect(controller.latestScan.value, null);
      expect(controller.status.value, Status.initial);
      expect(controller.errorMessage.value, '');
    });
  });
}
