import 'package:get/get.dart';

import '../../../../core/enums/status.dart';
import '../../data/models/comment_model.dart';
import '../../domain/usecases/komunitas_usecase.dart';

class KomunitasCommentController extends GetxController {
  final KomunitasUsecase _komunitasUsecase;

  KomunitasCommentController(this._komunitasUsecase);

  final RxList<CommentModel> comments = <CommentModel>[].obs;
  final Rx<Status> status = Status.initial.obs;
  final RxString errorMessage = ''.obs;
  final RxBool commentDeleted = false.obs;

  String _cleanError(dynamic error) {
    return error.toString().replaceFirst(RegExp(r'^[A-Za-z]+Exception: '), '').trim();
  }

  Future<void> fetchComments({required String postId, bool latest = false}) async {
    try {
      status.value = Status.loading;
      errorMessage.value = '';

      final result = await _komunitasUsecase.fetchComments(postId: postId, latest: latest);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          comments.value = success;
          status.value = Status.success;
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }

  Future<void> createComment({required CommentModel comment}) async {
    try {
      status.value = Status.loading;
      errorMessage.value = '';

      final result = await _komunitasUsecase.createComment(comment: comment);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          fetchComments(postId: comment.idPost.toString());
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }

  Future<void> deleteComment({required String commentId, required String postId}) async {
    try {
      status.value = Status.loading;
      errorMessage.value = '';
      commentDeleted.value = false;

      final result = await _komunitasUsecase.deleteComment(commentId: commentId);
      result.fold(
        (error) {
          errorMessage.value = _cleanError(error);
          status.value = Status.error;
        },
        (success) {
          commentDeleted.value = true;
          fetchComments(postId: postId);
        },
      );
    } catch (_) {
      status.value = Status.error;
      rethrow;
    }
  }

  Future<void> likeComment({required String uid, required String commentId}) async {
    try {
      final result = await _komunitasUsecase.likeComment(uid: uid, commentId: commentId);
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

  Future<void> unlikeComment({required String uid, required String commentId}) async {
    try {
      final result = await _komunitasUsecase.unlikeComment(uid: uid, commentId: commentId);
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
