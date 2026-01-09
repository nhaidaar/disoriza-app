import 'package:get/get.dart';

import '../../../../core/enums/status.dart';
import '../../data/models/post_model.dart';
import '../../domain/usecases/komunitas_usecase.dart';

class KomunitasSearchController extends GetxController {
  final KomunitasUsecase _komunitasUsecase;

  KomunitasSearchController(this._komunitasUsecase);

  final RxList<PostModel> searchResults = <PostModel>[].obs;
  final Rx<Status> status = Status.initial.obs;
  final RxString errorMessage = ''.obs;

  String _cleanError(dynamic error) {
    return error.toString().replaceFirst(RegExp(r'^[A-Za-z]+Exception: '), '').trim();
  }

  Future<void> searchPost({required String search}) async {
    try {
      status.value = Status.loading;
      errorMessage.value = '';

      final result = await _komunitasUsecase.searchPost(search: search);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          searchResults.value = success;
          status.value = Status.success;
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }

  void clearSearch() {
    searchResults.clear();
    status.value = Status.initial;
  }
}
