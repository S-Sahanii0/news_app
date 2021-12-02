import 'dart:convert';

class CommentModel {
  final String? username;
  final String comment;
  CommentModel({
    required this.username,
    required this.comment,
  });

  CommentModel copyWith({
    String? username,
    String? comment,
  }) {
    return CommentModel(
      username: username ?? this.username,
      comment: comment ?? this.comment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'comment': comment,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      username: map['username'] == null ? "" : map['username'],
      comment: map['comment'] == null ? "" : map['comment'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source));

  @override
  String toString() => 'CommentModel(username: $username, comment: $comment)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CommentModel &&
        other.username == username &&
        other.comment == comment;
  }

  @override
  int get hashCode => username.hashCode ^ comment.hashCode;
}
