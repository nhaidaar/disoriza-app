import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';

import '../../data/models/comment_model.dart';
import '../../data/models/post_with_comment.dart';
import '../../data/models/post_model.dart';
import '../repositories/komunitas_repository.dart';

class KomunitasUsecase {
  final KomunitasRepository _komunitasRepository;
  const KomunitasUsecase(this._komunitasRepository);

  Future<Either<Exception, List<PostModel>>> fetchAllPosts({
    bool latest = false,
    int? max,
  }) {
    return _komunitasRepository.fetchAllPosts(
      latest: latest,
      max: max,
    );
  }

  Future<Either<Exception, List<PostModel>>> fetchReportedPosts() {
    return _komunitasRepository.fetchReportedPosts();
  }

  Future<Either<Exception, List<PostModel>>> fetchAktivitas({
    required String uid,
    required String filter,
  }) {
    return _komunitasRepository.fetchAktivitas(
      uid: uid,
      filter: filter,
    );
  }

  Future<Either<Exception, List<PostModel>>> searchPost({required String search}) {
    return _komunitasRepository.searchPost(search: search);
  }

  Future<Either<Exception, void>> createPost({
    required String title,
    required String description,
    required String uid,
    Uint8List? image,
  }) {
    return _komunitasRepository.createPost(
      title: title,
      description: description,
      uid: uid,
      image: image,
    );
  }

  Future<Either<Exception, void>> deletePost({required String postId}) {
    return _komunitasRepository.deletePost(postId: postId);
  }

  Future<Either<Exception, void>> likePost({
    required String uid,
    required String postId,
  }) {
    return _komunitasRepository.likePost(
      uid: uid,
      postId: postId,
    );
  }

  Future<Either<Exception, void>> unlikePost({
    required String uid,
    required String postId,
  }) {
    return _komunitasRepository.unlikePost(
      uid: uid,
      postId: postId,
    );
  }

  Future<Either<Exception, void>> reportPost({
    required String uid,
    required String postId,
    String? reason,
  }) {
    return _komunitasRepository.reportPost(
      uid: uid,
      postId: postId,
      reason: reason,
    );
  }

  Future<Either<Exception, List<CommentModel>>> fetchComments({
    required String postId,
    bool latest = false,
  }) {
    return _komunitasRepository.fetchComments(
      postId: postId,
      latest: latest,
    );
  }

  Future<Either<Exception, List<PostWithCommentModel>>> fetchReportedComments() {
    return _komunitasRepository.fetchReportedComments();
  }

  Future<Either<Exception, void>> createComment({required CommentModel comment}) {
    return _komunitasRepository.createComment(comment: comment);
  }

  Future<Either<Exception, void>> deleteComment({required String commentId}) {
    return _komunitasRepository.deleteComment(commentId: commentId);
  }

  Future<Either<Exception, void>> likeComment({
    required String uid,
    required String commentId,
  }) {
    return _komunitasRepository.likeComment(
      uid: uid,
      commentId: commentId,
    );
  }

  Future<Either<Exception, void>> unlikeComment({
    required String uid,
    required String commentId,
  }) {
    return _komunitasRepository.unlikeComment(
      uid: uid,
      commentId: commentId,
    );
  }

  Future<Either<Exception, void>> reportComment({
    required String uid,
    required String commentId,
    String? reason,
  }) {
    return _komunitasRepository.reportComment(
      uid: uid,
      commentId: commentId,
      reason: reason,
    );
  }
}
