import 'package:flutter_test/flutter_test.dart';

import 'package:disoriza/features/auth/data/models/user_model.dart';
import 'package:disoriza/features/komunitas/data/models/comment_model.dart';
import 'package:disoriza/features/komunitas/data/models/post_model.dart';
import 'package:disoriza/features/komunitas/data/models/post_with_comment.dart';

void main() {
  group('PostWithCommentModel', () {
    final tUser = UserModel(
      id: 'user1',
      name: 'Test User',
      email: 'test@example.com',
      profilePicture: 'https://example.com/pic.jpg',
      isAdmin: false,
    );

    final tPostModel = PostModel(
      id: 1,
      title: 'Test Title',
      content: 'Test Content',
      urlImage: 'https://example.com/image.jpg',
      author: tUser,
      likes: ['user1', 'user2'],
      comments: ['user3'],
      reports: ['user4'],
      date: DateTime(2024, 1, 1),
    );

    final tCommentModel = CommentModel(
      id: 1,
      idUser: tUser,
      idPost: 1,
      content: 'Test Comment',
      likes: ['user1', 'user2'],
      reports: ['user3'],
      date: DateTime(2024, 1, 1),
    );

    group('constructor', () {
      test('should create PostWithCommentModel with valid post and comment', () {
        final result = PostWithCommentModel(
          postModel: tPostModel,
          commentModel: tCommentModel,
        );

        expect(result.postModel, tPostModel);
        expect(result.commentModel, tCommentModel);
      });

      test('should correctly associate post and comment', () {
        final result = PostWithCommentModel(
          postModel: tPostModel,
          commentModel: tCommentModel,
        );

        expect(result.postModel.id, 1);
        expect(result.commentModel.idPost, 1);
        expect(result.postModel.title, 'Test Title');
        expect(result.commentModel.content, 'Test Comment');
      });

      test('should preserve all post properties', () {
        final result = PostWithCommentModel(
          postModel: tPostModel,
          commentModel: tCommentModel,
        );

        expect(result.postModel.id, tPostModel.id);
        expect(result.postModel.title, tPostModel.title);
        expect(result.postModel.content, tPostModel.content);
        expect(result.postModel.urlImage, tPostModel.urlImage);
        expect(result.postModel.author?.id, tPostModel.author?.id);
        expect(result.postModel.likes?.length, tPostModel.likes?.length);
        expect(result.postModel.comments?.length, tPostModel.comments?.length);
        expect(result.postModel.reports?.length, tPostModel.reports?.length);
      });

      test('should preserve all comment properties', () {
        final result = PostWithCommentModel(
          postModel: tPostModel,
          commentModel: tCommentModel,
        );

        expect(result.commentModel.id, tCommentModel.id);
        expect(result.commentModel.idUser?.id, tCommentModel.idUser?.id);
        expect(result.commentModel.idPost, tCommentModel.idPost);
        expect(result.commentModel.content, tCommentModel.content);
        expect(result.commentModel.likes?.length, tCommentModel.likes?.length);
        expect(result.commentModel.reports?.length, tCommentModel.reports?.length);
      });
    });

    group('null handling', () {
      test('should handle post with null fields', () {
        const postWithNulls = PostModel(
          id: 1,
          title: 'Test',
          content: null,
          urlImage: null,
          author: null,
        );

        final result = PostWithCommentModel(
          postModel: postWithNulls,
          commentModel: tCommentModel,
        );

        expect(result.postModel.content, null);
        expect(result.postModel.urlImage, null);
        expect(result.postModel.author, null);
      });

      test('should handle comment with null fields', () {
        const commentWithNulls = CommentModel(
          id: 1,
          idUser: null,
          idPost: 1,
          content: 'Test',
        );

        final result = PostWithCommentModel(
          postModel: tPostModel,
          commentModel: commentWithNulls,
        );

        expect(result.commentModel.idUser, null);
        expect(result.commentModel.likes, null);
        expect(result.commentModel.reports, null);
      });
    });

    group('equality', () {
      test('should have same postModel reference', () {
        final result = PostWithCommentModel(
          postModel: tPostModel,
          commentModel: tCommentModel,
        );

        expect(identical(result.postModel, tPostModel), true);
      });

      test('should have same commentModel reference', () {
        final result = PostWithCommentModel(
          postModel: tPostModel,
          commentModel: tCommentModel,
        );

        expect(identical(result.commentModel, tCommentModel), true);
      });
    });

    group('use cases', () {
      test('should be usable for reported comments display', () {
        // Simulate a reported comment scenario
        final reportedComment = CommentModel(
          id: 5,
          idUser: tUser,
          idPost: 1,
          content: 'This is a reported comment',
          likes: [],
          reports: ['reporter1', 'reporter2', 'reporter3'],
          date: DateTime(2024, 1, 15),
        );

        final result = PostWithCommentModel(
          postModel: tPostModel,
          commentModel: reportedComment,
        );

        // Verify we can access both post context and comment details
        expect(result.postModel.title, 'Test Title');
        expect(result.commentModel.content, 'This is a reported comment');
        expect(result.commentModel.reports?.length, 3);
      });

      test('should allow accessing author info from both post and comment', () {
        final postAuthor = UserModel(id: 'postAuthor', name: 'Post Author');
        final commentAuthor = UserModel(id: 'commentAuthor', name: 'Comment Author');

        final post = PostModel(
          id: 1,
          title: 'Test Post',
          content: 'Content',
          author: postAuthor,
        );

        final comment = CommentModel(
          id: 1,
          idUser: commentAuthor,
          idPost: 1,
          content: 'Test Comment',
        );

        final result = PostWithCommentModel(
          postModel: post,
          commentModel: comment,
        );

        expect(result.postModel.author?.name, 'Post Author');
        expect(result.commentModel.idUser?.name, 'Comment Author');
      });
    });
  });
}
