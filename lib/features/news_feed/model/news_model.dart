import 'dart:convert';

import 'package:news_app/features/channels/models/channel_model.dart';

class News {
  final String newsImage;
  final String title;
  final Channel channel;
  final String date;
  final String content;
  final String url;
  News({
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
    return 'News(newsImage: $newsImage, title: $title, channel: $channel, date: $date, content: $content, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is News &&
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
