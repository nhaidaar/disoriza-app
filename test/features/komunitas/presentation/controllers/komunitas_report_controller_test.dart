import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:disoriza/core/enums/status.dart';
import 'package:disoriza/features/komunitas/domain/usecases/komunitas_usecase.dart';
import 'package:disoriza/features/komunitas/presentation/controllers/komunitas_report_controller.dart';

import 'komunitas_report_controller_test.mocks.dart';

void _registerFallbackValues() {
  provideDummy<Either<Exception, void>>(const Right(null));
}

@GenerateMocks([KomunitasUsecase])
void main() {
  late KomunitasReportController controller;
  late MockKomunitasUsecase mockKomunitasUsecase;

  setUp(() {
    _registerFallbackValues();
    Get.testMode = true;
    mockKomunitasUsecase = MockKomunitasUsecase();
    controller = KomunitasReportController(mockKomunitasUsecase);
  });

  tearDown(() {
    Get.reset();
  });

  group('reportPost', () {
    test('should set postReported to true and status to success on successful report', () async {
      when(mockKomunitasUsecase.reportPost(
        uid: anyNamed('uid'),
        postId: anyNamed('postId'),
      )).thenAnswer((_) async => const Right(null));

      await controller.reportPost(uid: 'user1', postId: '1');

      expect(controller.postReported.value, true);
      expect(controller.status.value, Status.success);
    });

    test('should set errorMessage and status to error on failed report', () async {
      when(mockKomunitasUsecase.reportPost(
        uid: anyNamed('uid'),
        postId: anyNamed('postId'),
      )).thenAnswer((_) async => Left(Exception('Report failed')));

      await controller.reportPost(uid: 'user1', postId: '1');

      expect(controller.errorMessage.value, contains('Report failed'));
      expect(controller.status.value, Status.error);
    });

    test('should reset postReported before reporting', () async {
      controller.postReported.value = true;

      when(mockKomunitasUsecase.reportPost(
        uid: anyNamed('uid'),
        postId: anyNamed('postId'),
      )).thenAnswer((_) async {
        expect(controller.postReported.value, false);
        return const Right(null);
      });

      await controller.reportPost(uid: 'user1', postId: '1');
    });
  });

  group('reportComment', () {
    test('should set commentReported to true and status to success on successful report', () async {
      when(mockKomunitasUsecase.reportComment(
        uid: anyNamed('uid'),
        commentId: anyNamed('commentId'),
      )).thenAnswer((_) async => const Right(null));

      await controller.reportComment(uid: 'user1', commentId: '1');

      expect(controller.commentReported.value, true);
      expect(controller.status.value, Status.success);
    });

    test('should set errorMessage and status to error on failed report', () async {
      when(mockKomunitasUsecase.reportComment(
        uid: anyNamed('uid'),
        commentId: anyNamed('commentId'),
      )).thenAnswer((_) async => Left(Exception('Report failed')));

      await controller.reportComment(uid: 'user1', commentId: '1');

      expect(controller.errorMessage.value, contains('Report failed'));
      expect(controller.status.value, Status.error);
    });
  });
}
