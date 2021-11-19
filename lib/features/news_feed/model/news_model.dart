import 'dart:convert';

import '../../channels/models/channel_model.dart';

class News {
  final String? id;
  final String newsImage;
  final String title;
  final Channel channel;
  final String date;
  final String content;
  final String url;
  News({
    required this.id,
    required this.newsImage,
    required this.title,
    required this.channel,
    required this.date,
    required this.content,
    required this.url,
  });

  News copyWith({
    String? newsImage,
    String? title,
    Channel? channel,
    String? date,
    String? content,
    String? url,
  }) {
    return News(
      id: id ?? this.id,
      newsImage: newsImage ?? this.newsImage,
      title: title ?? this.title,
      channel: channel ?? this.channel,
      date: date ?? this.date,
      content: content ?? this.content,
      url: url ?? this.url,
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
    };
  }

  factory News.fromMap(Map<String, dynamic> map) {
    return News(
      id: map['id'],
      newsImage: map['newsImage'],
      title: map['title'],
      channel: Channel.fromMap(map['channel']),
      date: map['date'],
      content: map['content'],
      url: map['url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory News.fromJson(String source) => News.fromMap(json.decode(source));

  @override
  String toString() {
    return 'News(id: $id, newsImage: $newsImage, title: $title, date: $date, channel:$channel, content: $content, url: $url)';
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
        other.url == url;
  }

  @override
  int get hashCode {
    return newsImage.hashCode ^
        title.hashCode ^
        channel.hashCode ^
        date.hashCode ^
        content.hashCode ^
        url.hashCode;
  }
}
