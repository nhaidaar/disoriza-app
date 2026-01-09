import 'package:get/get.dart';

import '../../../../core/enums/status.dart';
import '../../domain/usecases/komunitas_usecase.dart';

class KomunitasReportController extends GetxController {
  final KomunitasUsecase _komunitasUsecase;

  KomunitasReportController(this._komunitasUsecase);

  final Rx<Status> status = Status.initial.obs;
  final RxString errorMessage = ''.obs;
  final RxBool postReported = false.obs;
  final RxBool commentReported = false.obs;

  String _cleanError(dynamic error) {
    return error.toString().replaceFirst(RegExp(r'^[A-Za-z]+Exception: '), '').trim();
  }

  Future<void> reportPost({required String uid, required String postId}) async {
    try {
      status.value = Status.loading;
      errorMessage.value = '';
      postReported.value = false;

      final result = await _komunitasUsecase.reportPost(uid: uid, postId: postId);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          postReported.value = true;
          status.value = Status.success;
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }

  Future<void> reportComment({required String uid, required String commentId}) async {
    try {
      status.value = Status.loading;
      errorMessage.value = '';
      commentReported.value = false;

      final result = await _komunitasUsecase.reportComment(uid: uid, commentId: commentId);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          commentReported.value = true;
          status.value = Status.success;
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }
}
