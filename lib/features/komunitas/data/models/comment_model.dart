import '../../../auth/data/models/user_model.dart';

class CommentModel {
  final int? id;
  final UserModel? idUser;
  final int? idPost;
  final String? content;
  final List<String>? likes;
  final List<String>? reports;
  final DateTime? date;

  /// Denormalized counts from database (optimized for sorting)
  final int likesCount;
  final int reportsCount;

  const CommentModel({
    this.id,
    this.idUser,
    this.idPost,
    this.content,
    this.likes,
    this.reports,
    this.date,
    this.likesCount = 0,
    this.reportsCount = 0,
  });

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'],
      idUser: map['users'] != null ? UserModel.fromMap(map['users']) : null,
      idPost: map['id_post'],
      content: map['content'],
      likes: map['liked_comments'] != null
          ? (map['liked_comments'] as List).map((like) {
              return like['id_user'].toString();
            }).toList()
          : null,
      reports: map['reported_comments'] != null
          ? (map['reported_comments'] as List).map((report) {
              return report['id_user'].toString();
            }).toList()
          : null,
      date: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
      // Use denormalized counts from database
      likesCount: map['likes_count'] ?? 0,
      reportsCount: map['reports_count'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id_user': idUser?.id,
      'id_post': idPost,
      'content': content,
    };
  }

  CommentModel copyWith({
    int? id,
    UserModel? idUser,
    int? idPost,
    String? content,
    List<String>? likes,
    List<String>? reports,
    DateTime? date,
    int? likesCount,
    int? reportsCount,
  }) {
    return CommentModel(
      id: id ?? this.id,
      idUser: idUser ?? this.idUser,
      idPost: idPost ?? this.idPost,
      content: content ?? this.content,
      likes: likes ?? this.likes,
      reports: reports ?? this.reports,
      date: date ?? this.date,
      likesCount: likesCount ?? this.likesCount,
      reportsCount: reportsCount ?? this.reportsCount,
    );
  }
}
