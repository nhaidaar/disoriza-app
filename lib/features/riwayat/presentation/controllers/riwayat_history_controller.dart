import 'package:get/get.dart';

import '../../../../core/enums/status.dart';
import '../../data/models/riwayat_model.dart';
import '../../domain/usecases/riwayat_usecase.dart';

class RiwayatHistoryController extends GetxController {
  final RiwayatUsecase _riwayatUsecase;

  RiwayatHistoryController(this._riwayatUsecase);

  final RxList<RiwayatModel> riwayat = <RiwayatModel>[].obs;
  final Rx<Status> status = Status.initial.obs;
  final RxString errorMessage = ''.obs;
  final RxBool riwayatDeleted = false.obs;

  String _cleanError(dynamic error) {
    return error.toString().replaceFirst(RegExp(r'^[A-Za-z]+Exception: '), '').trim();
  }

  Future<void> fetchRiwayat({required String uid, int? max}) async {
    try {
      status.value = Status.loading;
      errorMessage.value = '';

      final result = await _riwayatUsecase.fetchAllRiwayat(uid: uid, max: max);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          riwayat.value = success;
          status.value = Status.success;
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }

  Future<void> deleteRiwayat({required String riwayatId}) async {
    try {
      status.value = Status.loading;
      errorMessage.value = '';
      riwayatDeleted.value = false;

      final result = await _riwayatUsecase.deleteRiwayat(riwayatId: riwayatId);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          riwayatDeleted.value = true;
          status.value = Status.success;
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }
}
