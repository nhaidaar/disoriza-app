import 'package:flutter_test/flutter_test.dart';

import 'package:disoriza/features/auth/data/models/user_model.dart';
import 'package:disoriza/features/komunitas/data/models/post_model.dart';

void main() {
  group('PostModel', () {
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
      likesCount: 2,
      commentsCount: 1,
      reportsCount: 1,
    );

    group('fromMap', () {
      test('should return a valid PostModel from map with all fields', () {
        final map = {
          'id': 1,
          'title': 'Test Title',
          'content': 'Test Content',
          'url_image': 'https://example.com/image.jpg',
          'users': {
            'id': 'user1',
            'name': 'Test User',
            'email': 'test@example.com',
            'profile_picture': 'https://example.com/pic.jpg',
            'is_admin': false,
          },
          'liked_posts': [
            {'id_user': 'user1'},
            {'id_user': 'user2'},
          ],
          'comments': [
            {'id_user': 'user3'},
          ],
          'reported_posts': [
            {'id_user': 'user4'},
          ],
          'created_at': '2024-01-01T00:00:00.000',
          'likes_count': 2,
          'comments_count': 1,
          'reports_count': 1,
        };

        final result = PostModel.fromMap(map);

        expect(result.id, 1);
        expect(result.title, 'Test Title');
        expect(result.content, 'Test Content');
        expect(result.urlImage, 'https://example.com/image.jpg');
        expect(result.author?.id, 'user1');
        expect(result.author?.name, 'Test User');
        expect(result.likes?.length, 2);
        expect(result.likes?.contains('user1'), true);
        expect(result.comments?.length, 1);
        expect(result.reports?.length, 1);
        expect(result.likesCount, 2);
        expect(result.commentsCount, 1);
        expect(result.reportsCount, 1);
      });

      test('should handle empty likes, comments, and reports lists', () {
        final map = {
          'id': 1,
          'title': 'Test Title',
          'content': 'Test Content',
          'url_image': null,
          'users': {
            'id': 'user1',
            'name': 'Test User',
            'email': 'test@example.com',
            'profile_picture': null,
            'is_admin': false,
          },
          'liked_posts': [],
          'comments': [],
          'reported_posts': [],
          'created_at': '2024-01-01T00:00:00.000',
          'likes_count': 0,
          'comments_count': 0,
          'reports_count': 0,
        };

        final result = PostModel.fromMap(map);

        expect(result.likes?.length, 0);
        expect(result.comments?.length, 0);
        expect(result.reports?.length, 0);
        expect(result.likesCount, 0);
        expect(result.commentsCount, 0);
        expect(result.reportsCount, 0);
      });

      test('should handle null users field', () {
        final map = {
          'id': 1,
          'title': 'Test',
          'content': 'Content',
          'url_image': null,
          'users': null,
          'liked_posts': null,
          'comments': null,
          'reported_posts': null,
          'created_at': null,
          'likes_count': null,
          'comments_count': null,
          'reports_count': null,
        };

        final result = PostModel.fromMap(map);

        expect(result.author, null);
        expect(result.likes, null);
        expect(result.comments, null);
        expect(result.reports, null);
        expect(result.date, null);
        expect(result.likesCount, 0);
        expect(result.commentsCount, 0);
        expect(result.reportsCount, 0);
      });

      test('should parse nested user data correctly', () {
        final map = {
          'id': 1,
          'title': 'Test',
          'content': 'Content',
          'url_image': null,
          'users': {
            'id': 'admin1',
            'name': 'Admin User',
            'email': 'admin@example.com',
            'profile_picture': 'https://example.com/admin.jpg',
            'is_admin': true,
          },
          'liked_posts': [],
          'comments': [],
          'reported_posts': [],
          'created_at': '2024-01-01T00:00:00.000',
        };

        final result = PostModel.fromMap(map);

        expect(result.author?.id, 'admin1');
        expect(result.author?.name, 'Admin User');
        expect(result.author?.isAdmin, true);
        expect(result.author?.profilePicture, 'https://example.com/admin.jpg');
      });

      test('should extract user IDs from likes correctly', () {
        final map = {
          'id': 1,
          'title': 'Test',
          'content': 'Content',
          'url_image': null,
          'users': {
            'id': 'user1',
            'name': 'Test',
            'email': 'test@test.com',
            'profile_picture': null,
            'is_admin': false,
          },
          'liked_posts': [
            {'id_user': 'user1'},
            {'id_user': 'user2'},
            {'id_user': 'user3'},
          ],
          'comments': [],
          'reported_posts': [],
          'created_at': '2024-01-01T00:00:00.000',
          'likes_count': 3,
        };

        final result = PostModel.fromMap(map);

        expect(result.likes?.length, 3);
        expect(result.likes, contains('user1'));
        expect(result.likes, contains('user2'));
        expect(result.likes, contains('user3'));
        expect(result.likesCount, 3);
      });
    });

    group('toMap', () {
      test('should return a valid map from PostModel', () {
        final result = tPostModel.toMap();

        expect(result['title'], 'Test Title');
        expect(result['content'], 'Test Content');
        expect(result['url_image'], 'https://example.com/image.jpg');
        expect(result['id_user'], 'user1');
      });

      test('should handle null values in toMap', () {
        const postModel = PostModel(
          id: 1,
          title: 'Test',
          content: null,
          urlImage: null,
          author: null,
        );

        final result = postModel.toMap();

        expect(result['title'], 'Test');
        expect(result['content'], null);
        expect(result['url_image'], null);
        expect(result['id_user'], null);
      });
    });

    group('copyWith', () {
      test('should return a copy with updated title', () {
        final result = tPostModel.copyWith(title: 'New Title');

        expect(result.title, 'New Title');
        expect(result.content, tPostModel.content);
        expect(result.id, tPostModel.id);
      });

      test('should return a copy with updated content', () {
        final result = tPostModel.copyWith(content: 'New Content');

        expect(result.content, 'New Content');
        expect(result.title, tPostModel.title);
      });

      test('should return a copy with updated counts', () {
        final result = tPostModel.copyWith(
          likesCount: 10,
          commentsCount: 5,
          reportsCount: 2,
        );

        expect(result.likesCount, 10);
        expect(result.commentsCount, 5);
        expect(result.reportsCount, 2);
      });

      test('should return a copy with all fields updated', () {
        final newUser = UserModel(id: 'newUser', name: 'New User');
        final newDate = DateTime(2025, 1, 1);

        final result = tPostModel.copyWith(
          id: 2,
          title: 'New Title',
          content: 'New Content',
          urlImage: 'https://new.com/image.jpg',
          author: newUser,
          likes: ['newUser1'],
          comments: ['newUser2'],
          reports: [],
          date: newDate,
          likesCount: 1,
          commentsCount: 1,
          reportsCount: 0,
        );

        expect(result.id, 2);
        expect(result.title, 'New Title');
        expect(result.content, 'New Content');
        expect(result.urlImage, 'https://new.com/image.jpg');
        expect(result.author?.id, 'newUser');
        expect(result.likes?.length, 1);
        expect(result.comments?.length, 1);
        expect(result.reports?.length, 0);
        expect(result.date, newDate);
        expect(result.likesCount, 1);
        expect(result.commentsCount, 1);
        expect(result.reportsCount, 0);
      });

      test('should preserve original values when copyWith is called with no arguments', () {
        final result = tPostModel.copyWith();

        expect(result.id, tPostModel.id);
        expect(result.title, tPostModel.title);
        expect(result.content, tPostModel.content);
        expect(result.urlImage, tPostModel.urlImage);
        expect(result.author?.id, tPostModel.author?.id);
        expect(result.likesCount, tPostModel.likesCount);
        expect(result.commentsCount, tPostModel.commentsCount);
        expect(result.reportsCount, tPostModel.reportsCount);
      });
    });

    group('null safety', () {
      test('should handle PostModel with all null fields', () {
        const postModel = PostModel();

        expect(postModel.id, null);
        expect(postModel.title, null);
        expect(postModel.content, null);
        expect(postModel.urlImage, null);
        expect(postModel.author, null);
        expect(postModel.likes, null);
        expect(postModel.comments, null);
        expect(postModel.reports, null);
        expect(postModel.date, null);
        expect(postModel.likesCount, 0);
        expect(postModel.commentsCount, 0);
        expect(postModel.reportsCount, 0);
      });

      test('should handle null url_image in fromMap', () {
        final map = {
          'id': 1,
          'title': 'Test',
          'content': 'Content',
          'url_image': null,
          'users': {
            'id': 'user1',
            'name': 'Test',
            'email': 'test@test.com',
            'profile_picture': null,
            'is_admin': false,
          },
          'liked_posts': [],
          'comments': [],
          'reported_posts': [],
          'created_at': '2024-01-01T00:00:00.000',
        };

        final result = PostModel.fromMap(map);

        expect(result.urlImage, null);
      });
    });

    group('denormalized counts', () {
      test('should default counts to 0 when not provided in map', () {
        final map = {
          'id': 1,
          'title': 'Test',
          'content': 'Content',
          'url_image': null,
          'users': null,
          'liked_posts': null,
          'comments': null,
          'reported_posts': null,
          'created_at': null,
        };

        final result = PostModel.fromMap(map);

        expect(result.likesCount, 0);
        expect(result.commentsCount, 0);
        expect(result.reportsCount, 0);
      });

      test('should parse counts correctly from map', () {
        final map = {
          'id': 1,
          'title': 'Test',
          'content': 'Content',
          'url_image': null,
          'users': null,
          'liked_posts': null,
          'comments': null,
          'reported_posts': null,
          'created_at': null,
          'likes_count': 100,
          'comments_count': 50,
          'reports_count': 5,
        };

        final result = PostModel.fromMap(map);

        expect(result.likesCount, 100);
        expect(result.commentsCount, 50);
        expect(result.reportsCount, 5);
      });
    });
  });
}
