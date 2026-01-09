import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:get/get.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:disoriza/core/enums/status.dart';
import 'package:disoriza/features/auth/data/models/user_model.dart';
import 'package:disoriza/features/auth/domain/usecases/auth_usecase.dart';
import 'package:disoriza/features/auth/presentation/controllers/auth_controller.dart';

import 'auth_controller_test.mocks.dart';

void _registerFallbackValues() {
  provideDummy<Either<Exception, UserModel>>(Right(UserModel()));
  provideDummy<Either<Exception, void>>(const Right(null));
}

@GenerateMocks([AuthUsecase])
void main() {
  late AuthController controller;
  late MockAuthUsecase mockAuthUsecase;

  setUp(() {
    _registerFallbackValues();
    Get.testMode = true;
    mockAuthUsecase = MockAuthUsecase();
    controller = AuthController(mockAuthUsecase);
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

  group('checkSession', () {
    test('should set user and status to success when session is valid', () async {
      when(mockAuthUsecase.checkSession())
          .thenAnswer((_) async => Right(tUser));

      await controller.checkSession();

      expect(controller.user.value, tUser);
      expect(controller.status.value, Status.success);
      verify(mockAuthUsecase.checkSession()).called(1);
    });

    test('should set user to null and status to error when session is invalid', () async {
      when(mockAuthUsecase.checkSession())
          .thenAnswer((_) async => Left(Exception('No session')));

      await controller.checkSession();

      expect(controller.user.value, null);
      expect(controller.status.value, Status.error);
      verify(mockAuthUsecase.checkSession()).called(1);
    });
  });

  group('register', () {
    test('should set user, isFirstTime, and status to success on successful registration', () async {
      when(mockAuthUsecase.register(
        name: anyNamed('name'),
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => Right(tUser));

      await controller.register(
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123',
      );

      expect(controller.user.value, tUser);
      expect(controller.isFirstTime.value, true);
      expect(controller.status.value, Status.success);
    });

    test('should set errorMessage and status to error on failed registration', () async {
      when(mockAuthUsecase.register(
        name: anyNamed('name'),
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => Left(Exception('Email already exists')));

      await controller.register(
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123',
      );

      expect(controller.errorMessage.value, contains('Email already exists'));
      expect(controller.status.value, Status.error);
    });

    test('should set status to loading while registering', () async {
      when(mockAuthUsecase.register(
        name: anyNamed('name'),
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async {
        expect(controller.status.value, Status.loading);
        return Right(tUser);
      });

      await controller.register(
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123',
      );
    });
  });

  group('login', () {
    test('should set user and status to success on successful login', () async {
      when(mockAuthUsecase.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => Right(tUser));

      await controller.login(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(controller.user.value, tUser);
      expect(controller.isFirstTime.value, false);
      expect(controller.status.value, Status.success);
    });

    test('should set errorMessage and status to error on failed login', () async {
      when(mockAuthUsecase.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => Left(Exception('Invalid credentials')));

      await controller.login(
        email: 'test@example.com',
        password: 'wrong_password',
      );

      expect(controller.errorMessage.value, contains('Invalid credentials'));
      expect(controller.status.value, Status.error);
    });
  });

  group('logout', () {
    test('should set user to null and status to initial on successful logout', () async {
      controller.user.value = tUser;
      controller.status.value = Status.success;

      when(mockAuthUsecase.logout())
          .thenAnswer((_) async => const Right(null));

      await controller.logout();

      expect(controller.user.value, null);
      expect(controller.status.value, Status.initial);
    });

    test('should set errorMessage and status to error on failed logout', () async {
      when(mockAuthUsecase.logout())
          .thenAnswer((_) async => Left(Exception('Logout failed')));

      await controller.logout();

      expect(controller.errorMessage.value, contains('Logout failed'));
      expect(controller.status.value, Status.error);
    });
  });

  group('resetPassword', () {
    test('should set passwordReseted to true and status to success on successful reset', () async {
      when(mockAuthUsecase.resetPassword(email: anyNamed('email')))
          .thenAnswer((_) async => const Right(null));

      await controller.resetPassword(email: 'test@example.com');

      expect(controller.passwordReseted.value, true);
      expect(controller.status.value, Status.success);
    });

    test('should set errorMessage and status to error on failed reset', () async {
      when(mockAuthUsecase.resetPassword(email: anyNamed('email')))
          .thenAnswer((_) async => Left(Exception('Email not found')));

      await controller.resetPassword(email: 'test@example.com');

      expect(controller.errorMessage.value, contains('Email not found'));
      expect(controller.status.value, Status.error);
    });
  });

  group('updateUser', () {
    test('should update user value', () {
      final newUser = tUser.copyWith(name: 'Updated Name');

      controller.updateUser(newUser);

      expect(controller.user.value, newUser);
      expect(controller.user.value?.name, 'Updated Name');
    });
  });
}
