import 'dart:typed_data';

import 'package:get/get.dart';

import '../../../../core/enums/status.dart';
import '../../data/models/post_model.dart';
import '../../data/models/post_with_comment.dart';
import '../../domain/usecases/komunitas_usecase.dart';

class KomunitasPostController extends GetxController {
  final KomunitasUsecase _komunitasUsecase;

  KomunitasPostController(this._komunitasUsecase);

  final RxList<PostModel> posts = <PostModel>[].obs;
  final RxList<PostWithCommentModel> reportedComments = <PostWithCommentModel>[].obs;
  final Rx<Status> status = Status.initial.obs;
  final RxString errorMessage = ''.obs;
  final RxBool postCreated = false.obs;
  final RxBool postDeleted = false.obs;

  String _cleanError(dynamic error) {
    return error.toString().replaceFirst(RegExp(r'^[A-Za-z]+Exception: '), '').trim();
  }

  Future<void> fetchAllPosts({bool latest = false, int? max}) async {
    try {
      status.value = Status.loading;
      errorMessage.value = '';

      final result = await _komunitasUsecase.fetchAllPosts(latest: latest, max: max);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          posts.value = success;
          status.value = Status.success;
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }

  Future<void> fetchReportedPosts() async {
    try {
      status.value = Status.loading;
      errorMessage.value = '';

      final result = await _komunitasUsecase.fetchReportedPosts();
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          posts.value = success;
          status.value = Status.success;
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }

  Future<void> fetchReportedComments() async {
    try {
      status.value = Status.loading;
      errorMessage.value = '';

      final result = await _komunitasUsecase.fetchReportedComments();
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          reportedComments.value = success;
          status.value = Status.success;
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }

  Future<void> fetchAktivitas({required String uid, required String filter}) async {
    try {
      status.value = Status.loading;
      errorMessage.value = '';

      final result = await _komunitasUsecase.fetchAktivitas(uid: uid, filter: filter);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          posts.value = success;
          status.value = Status.success;
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }

  Future<void> createPost({
    required String title,
    required String description,
    required String uid,
    Uint8List? image,
  }) async {
    try {
      status.value = Status.loading;
      errorMessage.value = '';
      postCreated.value = false;

      final result = await _komunitasUsecase.createPost(
        title: title,
        description: description,
        uid: uid,
        image: image,
      );
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          postCreated.value = true;
          status.value = Status.success;
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }

  Future<void> deletePost({required String postId}) async {
    try {
      status.value = Status.loading;
      errorMessage.value = '';
      postDeleted.value = false;

      final result = await _komunitasUsecase.deletePost(postId: postId);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          postDeleted.value = true;
          status.value = Status.success;
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }

  Future<void> likePost({required String uid, required String postId}) async {
    try {
      final result = await _komunitasUsecase.likePost(uid: uid, postId: postId);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
        },
        (success) {},
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<void> unlikePost({required String uid, required String postId}) async {
    try {
      final result = await _komunitasUsecase.unlikePost(uid: uid, postId: postId);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
        },
        (success) {},
      );
    } catch (_) {
      rethrow;
    }
  }
}
