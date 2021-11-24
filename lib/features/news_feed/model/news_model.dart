import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:news_app/features/news_feed/model/comment_model.dart';

import '../../channels/models/channel_model.dart';

class News {
  final String? id;
  final String newsImage;
  final String title;
  final Channel channel;
  final String date;
  final String content;
  final String url;
  final int? likes;
  final List<CommentModel>? comment;
  News({
    this.id,
    required this.newsImage,
    required this.title,
    required this.channel,
    required this.date,
    required this.content,
    required this.url,
    this.likes,
    this.comment,
  });

  News copyWith({
    String? id,
    String? newsImage,
    String? title,
    Channel? channel,
    String? date,
    String? content,
    String? url,
    int? likes,
    List<CommentModel>? comment,
  }) {
    return News(
      id: id ?? this.id,
      newsImage: newsImage ?? this.newsImage,
      title: title ?? this.title,
      channel: channel ?? this.channel,
      date: date ?? this.date,
      content: content ?? this.content,
      url: url ?? this.url,
      likes: likes ?? this.likes,
      comment: comment ?? this.comment,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'newsImage': newsImage,
      'title': title,
      'channel': channel.toMap(),
      'date': date,
      'content': content,
      'url': url,
      'likes': likes,
      'comment': comment?.map((x) => x.toMap()).toList(),
    };
  }

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      id: map['id'] != "" ? map['id'] : "",
      newsImage: map['newsImage'],
      title: map['title'],
      channel: Channel.fromMap(map['channel']),
      date: map['date'],
      content: map['content'],
      url: map['url'],
      likes: map['likes'] ?? "0",
      comment: map['comment'] != null
          ? List<CommentModel>.from(
              map['comment']?.map((x) => CommentModel.fromMap(x)))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory News.fromJson(String source) => News.fromMap(json.decode(source));

  @override
  String toString() {
    return 'News(id: $id, newsImage: $newsImage, title: $title, channel: $channel, date: $date, content: $content, url: $url, likes: $likes, comment: $comment)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is News &&
        other.id == id &&
        other.newsImage == newsImage &&
        other.title == title &&
        other.channel == channel &&
        other.date == date &&
        other.content == content &&
        other.url == url &&
        other.likes == likes &&
        listEquals(other.comment, comment);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        newsImage.hashCode ^
        title.hashCode ^
        channel.hashCode ^
        date.hashCode ^
        content.hashCode ^
        url.hashCode ^
        likes.hashCode ^
        comment.hashCode;
  }
}
