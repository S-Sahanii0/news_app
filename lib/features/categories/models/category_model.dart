import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../news_feed/model/news_model.dart';

class CategoryModel {
  final String categoryName;
  final List<News> news;
  CategoryModel({
    required this.categoryName,
    required this.news,
  });

  CategoryModel copyWith({
    String? categoryName,
    List<News>? news,
  }) {
    return CategoryModel(
      categoryName: categoryName ?? this.categoryName,
      news: news ?? this.news,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
      'news': news.map((x) => x.toMap()).toList(),
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryName: map['categoryName'],
      news: List<News>.from(map['news']?.map((x) => News.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryModel.fromJson(String source) =>
      CategoryModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'CategoryModel(categoryName: $categoryName, news: $news)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CategoryModel &&
        other.categoryName == categoryName &&
        listEquals(other.news, news);
  }

  @override
  int get hashCode => categoryName.hashCode ^ news.hashCode;
}
