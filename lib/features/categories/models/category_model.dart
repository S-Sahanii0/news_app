import 'dart:convert';

import 'package:news_app/features/news_feed/model/news_model.dart';

class CategoryModel {
  final String categoryName;
  final News news;
  CategoryModel({
    required this.categoryName,
    required this.news,
  });

  CategoryModel copyWith({
    String? categoryName,
    News? news,
  }) {
    return CategoryModel(
      categoryName: categoryName ?? this.categoryName,
      news: news ?? this.news,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'categoryName': categoryName,
      'news': news.toMap(),
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      categoryName: map['categoryName'],
      news: News.fromMap(map['news']),
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
        other.news == news;
  }

  @override
  int get hashCode => categoryName.hashCode ^ news.hashCode;
}
