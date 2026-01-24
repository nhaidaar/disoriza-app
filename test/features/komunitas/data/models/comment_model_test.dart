import 'package:flutter_test/flutter_test.dart';

import 'package:disoriza/features/auth/data/models/user_model.dart';
import 'package:disoriza/features/komunitas/data/models/comment_model.dart';

void main() {
  group('CommentModel', () {
    final tUser = UserModel(
      id: 'user1',
      name: 'Test User',
      email: 'test@example.com',
      profilePicture: 'https://example.com/pic.jpg',
      isAdmin: false,
    );

    final tCommentModel = CommentModel(
      id: 1,
      idUser: tUser,
      idPost: 10,
      content: 'Test Comment',
      likes: ['user1', 'user2'],
      reports: ['user3'],
      date: DateTime(2024, 1, 1),
      likesCount: 2,
      reportsCount: 1,
    );

    group('fromMap', () {
      test('should return a valid CommentModel from map with all fields', () {
        final map = {
          'id': 1,
          'id_post': 10,
          'content': 'Test Comment',
          'users': {
            'id': 'user1',
            'name': 'Test User',
            'email': 'test@example.com',
            'profile_picture': 'https://example.com/pic.jpg',
            'is_admin': false,
          },
          'liked_comments': [
            {'id_user': 'user1'},
            {'id_user': 'user2'},
          ],
          'reported_comments': [
            {'id_user': 'user3'},
          ],
          'created_at': '2024-01-01T00:00:00.000',
          'likes_count': 2,
          'reports_count': 1,
        };

        final result = CommentModel.fromMap(map);

        expect(result.id, 1);
        expect(result.idPost, 10);
        expect(result.content, 'Test Comment');
        expect(result.idUser?.id, 'user1');
        expect(result.idUser?.name, 'Test User');
        expect(result.likes?.length, 2);
        expect(result.likes?.contains('user1'), true);
        expect(result.reports?.length, 1);
        expect(result.likesCount, 2);
        expect(result.reportsCount, 1);
      });

      test('should handle empty likes and reports lists', () {
        final map = {
          'id': 1,
          'id_post': 10,
          'content': 'Test Comment',
          'users': {
            'id': 'user1',
            'name': 'Test User',
            'email': 'test@example.com',
            'profile_picture': null,
            'is_admin': false,
          },
          'liked_comments': [],
          'reported_comments': [],
          'created_at': '2024-01-01T00:00:00.000',
          'likes_count': 0,
          'reports_count': 0,
        };

        final result = CommentModel.fromMap(map);

        expect(result.likes?.length, 0);
        expect(result.reports?.length, 0);
        expect(result.likesCount, 0);
        expect(result.reportsCount, 0);
      });

      test('should handle null fields in fromMap', () {
        final map = {
          'id': 1,
          'id_post': 10,
          'content': 'Test',
          'users': null,
          'liked_comments': null,
          'reported_comments': null,
          'created_at': null,
          'likes_count': null,
          'reports_count': null,
        };

        final result = CommentModel.fromMap(map);

        expect(result.idUser, null);
        expect(result.likes, null);
        expect(result.reports, null);
        expect(result.date, null);
        expect(result.likesCount, 0);
        expect(result.reportsCount, 0);
      });

      test('should parse nested user data correctly', () {
        final map = {
          'id': 1,
          'id_post': 10,
          'content': 'Admin Comment',
          'users': {
            'id': 'admin1',
            'name': 'Admin User',
            'email': 'admin@example.com',
            'profile_picture': 'https://example.com/admin.jpg',
            'is_admin': true,
          },
          'liked_comments': [],
          'reported_comments': [],
          'created_at': '2024-01-01T00:00:00.000',
        };

        final result = CommentModel.fromMap(map);

        expect(result.idUser?.id, 'admin1');
        expect(result.idUser?.name, 'Admin User');
        expect(result.idUser?.isAdmin, true);
        expect(result.idUser?.profilePicture, 'https://example.com/admin.jpg');
      });

      test('should extract user IDs from likes correctly', () {
        final map = {
          'id': 1,
          'id_post': 10,
          'content': 'Test',
          'users': {
            'id': 'user1',
            'name': 'Test',
            'email': 'test@test.com',
            'profile_picture': null,
            'is_admin': false,
          },
          'liked_comments': [
            {'id_user': 'user1'},
            {'id_user': 'user2'},
            {'id_user': 'user3'},
          ],
          'reported_comments': [],
          'created_at': '2024-01-01T00:00:00.000',
          'likes_count': 3,
        };

        final result = CommentModel.fromMap(map);

        expect(result.likes?.length, 3);
        expect(result.likes, contains('user1'));
        expect(result.likes, contains('user2'));
        expect(result.likes, contains('user3'));
        expect(result.likesCount, 3);
      });

      test('should extract user IDs from reports correctly', () {
        final map = {
          'id': 1,
          'id_post': 10,
          'content': 'Test',
          'users': {
            'id': 'user1',
            'name': 'Test',
            'email': 'test@test.com',
            'profile_picture': null,
            'is_admin': false,
          },
          'liked_comments': [],
          'reported_comments': [
            {'id_user': 'reporter1'},
            {'id_user': 'reporter2'},
          ],
          'created_at': '2024-01-01T00:00:00.000',
          'reports_count': 2,
        };

        final result = CommentModel.fromMap(map);

        expect(result.reports?.length, 2);
        expect(result.reports, contains('reporter1'));
        expect(result.reports, contains('reporter2'));
        expect(result.reportsCount, 2);
      });

      test('should parse date correctly', () {
        final map = {
          'id': 1,
          'id_post': 10,
          'content': 'Test',
          'users': {
            'id': 'user1',
            'name': 'Test',
            'email': 'test@test.com',
            'profile_picture': null,
            'is_admin': false,
          },
          'liked_comments': [],
          'reported_comments': [],
          'created_at': '2024-06-15T14:30:00.000',
        };

        final result = CommentModel.fromMap(map);

        expect(result.date?.year, 2024);
        expect(result.date?.month, 6);
        expect(result.date?.day, 15);
        expect(result.date?.hour, 14);
        expect(result.date?.minute, 30);
      });
    });

    group('toMap', () {
      test('should return a valid map from CommentModel', () {
        final result = tCommentModel.toMap();

        expect(result['id_user'], 'user1');
        expect(result['id_post'], 10);
        expect(result['content'], 'Test Comment');
      });

      test('should handle null values in toMap', () {
        const commentModel = CommentModel(
          id: 1,
          idUser: null,
          idPost: 10,
          content: 'Test',
        );

        final result = commentModel.toMap();

        expect(result['id_user'], null);
        expect(result['id_post'], 10);
        expect(result['content'], 'Test');
      });

      test('should only include id_user, id_post, and content in toMap', () {
        final result = tCommentModel.toMap();

        expect(result.keys.length, 3);
        expect(result.containsKey('id_user'), true);
        expect(result.containsKey('id_post'), true);
        expect(result.containsKey('content'), true);
        expect(result.containsKey('id'), false);
        expect(result.containsKey('likes'), false);
        expect(result.containsKey('reports'), false);
      });
    });

    group('copyWith', () {
      test('should return a copy with updated content', () {
        final result = tCommentModel.copyWith(content: 'New Content');

        expect(result.content, 'New Content');
        expect(result.id, tCommentModel.id);
        expect(result.idPost, tCommentModel.idPost);
      });

      test('should return a copy with updated idPost', () {
        final result = tCommentModel.copyWith(idPost: 20);

        expect(result.idPost, 20);
        expect(result.content, tCommentModel.content);
      });

      test('should return a copy with updated counts', () {
        final result = tCommentModel.copyWith(
          likesCount: 10,
          reportsCount: 5,
        );

        expect(result.likesCount, 10);
        expect(result.reportsCount, 5);
      });

      test('should return a copy with all fields updated', () {
        final newUser = UserModel(id: 'newUser', name: 'New User');
        final newDate = DateTime(2025, 1, 1);

        final result = tCommentModel.copyWith(
          id: 2,
          idUser: newUser,
          idPost: 20,
          content: 'New Content',
          likes: ['newUser1'],
          reports: [],
          date: newDate,
          likesCount: 1,
          reportsCount: 0,
        );

        expect(result.id, 2);
        expect(result.idUser?.id, 'newUser');
        expect(result.idPost, 20);
        expect(result.content, 'New Content');
        expect(result.likes?.length, 1);
        expect(result.reports?.length, 0);
        expect(result.date, newDate);
        expect(result.likesCount, 1);
        expect(result.reportsCount, 0);
      });

      test('should preserve original values when copyWith is called with no arguments', () {
        final result = tCommentModel.copyWith();

        expect(result.id, tCommentModel.id);
        expect(result.idUser?.id, tCommentModel.idUser?.id);
        expect(result.idPost, tCommentModel.idPost);
        expect(result.content, tCommentModel.content);
        expect(result.likes?.length, tCommentModel.likes?.length);
        expect(result.reports?.length, tCommentModel.reports?.length);
        expect(result.likesCount, tCommentModel.likesCount);
        expect(result.reportsCount, tCommentModel.reportsCount);
      });
    });

    group('null safety', () {
      test('should handle CommentModel with all null fields', () {
        const commentModel = CommentModel();

        expect(commentModel.id, null);
        expect(commentModel.idUser, null);
        expect(commentModel.idPost, null);
        expect(commentModel.content, null);
        expect(commentModel.likes, null);
        expect(commentModel.reports, null);
        expect(commentModel.date, null);
        expect(commentModel.likesCount, 0);
        expect(commentModel.reportsCount, 0);
      });

      test('should handle null profile_picture in user', () {
        final map = {
          'id': 1,
          'id_post': 10,
          'content': 'Test',
          'users': {
            'id': 'user1',
            'name': 'Test',
            'email': 'test@test.com',
            'profile_picture': null,
            'is_admin': false,
          },
          'liked_comments': [],
          'reported_comments': [],
          'created_at': '2024-01-01T00:00:00.000',
        };

        final result = CommentModel.fromMap(map);

        expect(result.idUser?.profilePicture, null);
      });
    });

    group('denormalized counts', () {
      test('should default counts to 0 when not provided in map', () {
        final map = {
          'id': 1,
          'id_post': 10,
          'content': 'Test',
          'users': null,
          'liked_comments': null,
          'reported_comments': null,
          'created_at': null,
        };

        final result = CommentModel.fromMap(map);

        expect(result.likesCount, 0);
        expect(result.reportsCount, 0);
      });

      test('should parse counts correctly from map', () {
        final map = {
          'id': 1,
          'id_post': 10,
          'content': 'Test',
          'users': null,
          'liked_comments': null,
          'reported_comments': null,
          'created_at': null,
          'likes_count': 50,
          'reports_count': 3,
        };

        final result = CommentModel.fromMap(map);

        expect(result.likesCount, 50);
        expect(result.reportsCount, 3);
      });
    });
  });
}
