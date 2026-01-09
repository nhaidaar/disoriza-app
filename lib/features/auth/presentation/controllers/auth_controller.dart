import 'package:get/get.dart';

import '../../../../core/enums/status.dart';
import '../../data/models/user_model.dart';
import '../../domain/usecases/auth_usecase.dart';

class AuthController extends GetxController {
  final AuthUsecase _authUsecase;

  AuthController(this._authUsecase);

  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isFirstTime = false.obs;
  final Rx<Status> status = Status.initial.obs;
  final RxString errorMessage = ''.obs;
  final RxBool passwordReseted = false.obs;

  String _cleanError(dynamic error) {
    print(error);
    return error
        .toString()
        .replaceFirst(RegExp(r'^[A-Za-z]+Exception: '), '')
        .trim();
  }

  Future<void> checkSession() async {
    try {
      final result = await _authUsecase.checkSession();
      result.fold(
        (error) {
          user.value = null;
          status.value = Status.error;
        },
        (success) {
          user.value = success;
          status.value = Status.success;
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      status.value = Status.loading;
      errorMessage.value = '';

      final result = await _authUsecase.register(
        name: name,
        email: email,
        password: password,
      );
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          user.value = success;
          isFirstTime.value = true;
          status.value = Status.success;
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      status.value = Status.loading;
      errorMessage.value = '';

      final result = await _authUsecase.login(email: email, password: password);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          user.value = success;
          isFirstTime.value = false;
          status.value = Status.success;
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      final result = await _authUsecase.logout();
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          user.value = null;
          status.value = Status.initial;
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      status.value = Status.loading;
      errorMessage.value = '';
      passwordReseted.value = false;

      final result = await _authUsecase.resetPassword(email: email);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          passwordReseted.value = true;
          status.value = Status.success;
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }

  void updateUser(UserModel newUser) {
    user.value = newUser;
  }
}
