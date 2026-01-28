import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/enums/status.dart';
import '../../data/models/riwayat_model.dart';
import '../../domain/usecases/riwayat_usecase.dart';

class RiwayatScanController extends GetxController {
  final RiwayatUsecase _riwayatUsecase;

  RiwayatScanController(this._riwayatUsecase);

  final Rx<RiwayatModel?> latestScan = Rx<RiwayatModel?>(null);
  final Rx<Status> status = Status.initial.obs;
  final RxString errorMessage = ''.obs;

  String _cleanError(dynamic error) {
    return error
        .toString()
        .replaceFirst(RegExp(r'^[A-Za-z]*Exception: '), '')
        .trim();
  }

  Future<void> scanDisease({required String uid, required XFile image}) async {
    try {
      status.value = Status.loading;
      errorMessage.value = '';

      final result = await _riwayatUsecase.scanDisease(uid: uid, image: image);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          latestScan.value = success;
          status.value = Status.success;
        },
      );
    } catch (e) {
      errorMessage.value = _cleanError(e);
      status.value = Status.error;
    }
  }

  void resetScan() {
    latestScan.value = null;
    status.value = Status.initial;
    errorMessage.value = '';
  }
}
