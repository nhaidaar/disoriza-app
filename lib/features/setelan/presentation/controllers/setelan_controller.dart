import 'dart:typed_data';

import 'package:get/get.dart';

import '../../../../core/enums/status.dart';
import '../../../auth/data/models/user_model.dart';
import '../../../auth/domain/usecases/auth_usecase.dart';

class SetelanController extends GetxController {
  final AuthUsecase _authUsecase;

  SetelanController(this._authUsecase);

  final Rx<UserModel?> updatedProfile = Rx<UserModel?>(null);
  final Rx<Status> status = Status.initial.obs;
  final RxString errorMessage = ''.obs;
  final RxBool passwordChanged = false.obs;
  final RxBool emailChanged = false.obs;

  String _cleanError(dynamic error) {
    return error.toString().replaceFirst(RegExp(r'^[A-Za-z]+Exception: '), '').trim();
  }

  Future<void> changePassword({required String email}) async {
    try {
      status.value = Status.loading;
      errorMessage.value = '';
      passwordChanged.value = false;

      final result = await _authUsecase.resetPassword(email: email);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          passwordChanged.value = true;
          status.value = Status.success;
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }

  Future<void> changeEmail({required String email}) async {
    try {
      status.value = Status.loading;
      errorMessage.value = '';
      emailChanged.value = false;

      final result = await _authUsecase.changeEmail(email: email);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          emailChanged.value = true;
          status.value = Status.success;
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }

  Future<void> changeProfile({
    required String uid,
    String? name,
    Uint8List? image,
  }) async {
    try {
      status.value = Status.loading;
      errorMessage.value = '';

      final result = await _authUsecase.editProfile(
        uid: uid,
        name: name,
        image: image,
      );
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          updatedProfile.value = success;
          status.value = Status.success;
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }
}
