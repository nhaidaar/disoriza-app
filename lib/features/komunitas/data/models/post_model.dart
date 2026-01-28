import '../../../auth/data/models/user_model.dart';

class PostModel {
  final int? id;
  final String? title;
  final String? content;
  final String? urlImage;
  final UserModel? author;
  final List<String>? likes;
  final List<String>? comments;
  final List<String>? reports;
  final DateTime? date;

  /// Denormalized counts from database (optimized for sorting)
  final int likesCount;
  final int commentsCount;
  final int reportsCount;

  const PostModel({
    this.id,
    this.title,
    this.content,
    this.urlImage,
    this.author,
    this.likes,
    this.comments,
    this.reports,
    this.date,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.reportsCount = 0,
  });

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      urlImage: map['url_image'],
      author: map['users'] != null ? UserModel.fromMap(map['users']) : null,
      likes: map['liked_posts'] != null
          ? (map['liked_posts'] as List).map((like) {
              return like['id_user'].toString();
            }).toList()
          : null,
      comments: map['comments'] != null
          ? (map['comments'] as List).map((comment) {
              return comment['id_user'].toString();
            }).toList()
          : null,
      reports: map['reported_posts'] != null
          ? (map['reported_posts'] as List).map((report) {
              return report['id_user'].toString();
            }).toList()
          : null,
      date: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      // Use denormalized counts from database
      likesCount: map['likes_count'] ?? 0,
      commentsCount: map['comments_count'] ?? 0,
      reportsCount: map['reports_count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'url_image': urlImage,
      'id_user': author?.id,
    };
  }

  PostModel copyWith({
    int? id,
    String? title,
    String? content,
    String? urlImage,
    UserModel? author,
    List<String>? likes,
    List<String>? comments,
    List<String>? reports,
    DateTime? date,
    int? likesCount,
    int? commentsCount,
    int? reportsCount,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      urlImage: urlImage ?? this.urlImage,
      author: author ?? this.author,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      reports: reports ?? this.reports,
      date: date ?? this.date,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      reportsCount: reportsCount ?? this.reportsCount,
    );
  }
}
