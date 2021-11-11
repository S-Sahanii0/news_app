import 'package:news_app/features/news_feed/model/news_model.dart';

abstract class NewsRepository {
  Future<List<News>> getAllNews();
  Future<List<News>> getNewsByCategory();
  Future<void> addNewsToBookMark();
  Future<void> addNewsToLiked();
}
