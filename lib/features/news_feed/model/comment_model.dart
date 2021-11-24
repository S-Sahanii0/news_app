import 'dart:convert';

class CommentModel {
  final String userId;
  final String comment;
  CommentModel({
    required this.userId,
    required this.comment,
  });

  CommentModel copyWith({
    String? userId,
    String? comment,
  }) {
    return CommentModel(
      userId: userId ?? this.userId,
      comment: comment ?? this.comment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'comment': comment,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      userId: map['userId'],
      comment: map['comment'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source));

  @override
  String toString() => 'CommentModel(userId: $userId, comment: $comment)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommentModel &&
        other.userId == userId &&
        other.comment == comment;
  }

  @override
  int get hashCode => userId.hashCode ^ comment.hashCode;
}
