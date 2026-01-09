import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:disoriza/core/enums/status.dart';
import 'package:disoriza/features/auth/data/models/user_model.dart';
import 'package:disoriza/features/auth/domain/usecases/auth_usecase.dart';
import 'package:disoriza/features/setelan/presentation/controllers/setelan_controller.dart';

import 'setelan_controller_test.mocks.dart';

void _registerFallbackValues() {
  provideDummy<Either<Exception, UserModel>>(Right(UserModel()));
  provideDummy<Either<Exception, void>>(const Right(null));
}

@GenerateMocks([AuthUsecase])
void main() {
  late SetelanController controller;
  late MockAuthUsecase mockAuthUsecase;

  setUp(() {
    _registerFallbackValues();
    Get.testMode = true;
    mockAuthUsecase = MockAuthUsecase();
    controller = SetelanController(mockAuthUsecase);
  });

  tearDown(() {
    Get.reset();
  });

  final tUser = UserModel(
    id: '123',
    email: 'test@example.com',
    name: 'Test User',
    isAdmin: false,
  );

  group('changePassword', () {
    test('should set passwordChanged to true and status to success on successful change', () async {
      when(mockAuthUsecase.resetPassword(email: anyNamed('email')))
          .thenAnswer((_) async => const Right(null));

      await controller.changePassword(email: 'test@example.com');

      expect(controller.passwordChanged.value, true);
      expect(controller.status.value, Status.success);
    });

    test('should set errorMessage and status to error on failed change', () async {
      when(mockAuthUsecase.resetPassword(email: anyNamed('email')))
          .thenAnswer((_) async => Left(Exception('Change failed')));

      await controller.changePassword(email: 'test@example.com');

      expect(controller.errorMessage.value, contains('Change failed'));
      expect(controller.status.value, Status.error);
    });
  });

  group('changeEmail', () {
    test('should set emailChanged to true and status to success on successful change', () async {
      when(mockAuthUsecase.changeEmail(email: anyNamed('email')))
          .thenAnswer((_) async => const Right(null));

      await controller.changeEmail(email: 'new@example.com');

      expect(controller.emailChanged.value, true);
      expect(controller.status.value, Status.success);
    });

    test('should set errorMessage and status to error on failed change', () async {
      when(mockAuthUsecase.changeEmail(email: anyNamed('email')))
          .thenAnswer((_) async => Left(Exception('Email change failed')));

      await controller.changeEmail(email: 'new@example.com');

      expect(controller.errorMessage.value, contains('Email change failed'));
      expect(controller.status.value, Status.error);
    });
  });

  group('changeProfile', () {
    test('should set updatedProfile and status to success on successful change', () async {
      when(mockAuthUsecase.editProfile(
        uid: anyNamed('uid'),
        name: anyNamed('name'),
        image: anyNamed('image'),
      )).thenAnswer((_) async => Right(tUser));

      await controller.changeProfile(uid: '123', name: 'New Name');

      expect(controller.updatedProfile.value, tUser);
      expect(controller.status.value, Status.success);
    });

    test('should set errorMessage and status to error on failed change', () async {
      when(mockAuthUsecase.editProfile(
        uid: anyNamed('uid'),
        name: anyNamed('name'),
        image: anyNamed('image'),
      )).thenAnswer((_) async => Left(Exception('Profile change failed')));

      await controller.changeProfile(uid: '123', name: 'New Name');

      expect(controller.errorMessage.value, contains('Profile change failed'));
      expect(controller.status.value, Status.error);
    });

    test('should accept image parameter', () async {
      final imageBytes = Uint8List.fromList([1, 2, 3]);
      when(mockAuthUsecase.editProfile(
        uid: anyNamed('uid'),
        name: anyNamed('name'),
        image: anyNamed('image'),
      )).thenAnswer((_) async => Right(tUser));

      await controller.changeProfile(uid: '123', image: imageBytes);

      verify(mockAuthUsecase.editProfile(
        uid: '123',
        name: null,
        image: imageBytes,
      )).called(1);
    });
  });
}
