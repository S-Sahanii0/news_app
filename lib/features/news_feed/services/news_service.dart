import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:news_app/features/categories/services/category_service.dart';
import 'package:news_app/features/news_feed/model/comment_model.dart';
import 'package:uuid/uuid.dart';

import '../../channels/models/channel_model.dart';

import '../model/news_model.dart';

class NewsService {
  NewsService({required this.categoryService}) {
    listenToChannelEvent();
  }
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  CollectionReference category = FirebaseFirestore.instance.collection('category');
  CollectionReference channel = FirebaseFirestore.instance.collection('channel');
  CollectionReference news = FirebaseFirestore.instance.collection('news');
  List<Channel> channelList = [];
  List<News> newsList = [];
  final CategoryService categoryService;
  var uuid = Uuid();

  Future<List<News>> getNewsByCategory(String category) async {
    final categoryDocument = await this.category.doc(category).get();
    final categoryData = categoryDocument.data() as Map<String, dynamic>;
    final listOfNews = await getNewsModel(
        (categoryData["news"] as List<dynamic>).map((e) => e.toString()).toList());
    final result = <News>[];
    for (var i in listOfNews) {
      result.add(News.fromMap(i));
    }
    return result;
  }

  Future<List<News>> getNewsByListOfCategory(List<String> categoryList) async {
    final resultCategoryList = <News>[];
    for (var i = 0; i < categoryList.length; i++) {
      resultCategoryList.addAll(await getNewsByCategory(categoryList[i]));
    }
    return resultCategoryList;
  }

  Future<void> addDataToFirebase() async {
    final String response = await rootBundle.loadString('assets/data/news_data.json');
    final data = await json.decode(response);

    for (var element in List.from(data.keys)) {
      final listOfNewsReference = [];
      final listOfNewsTitle = []; //To avoid duplicate titles
      for (var e in List.from(data[element])) {
        if (!listOfNewsTitle.contains(e['title'])) {
          final newsId = uuid.v4();
          listOfNewsTitle.add(e['title']);
          listOfNewsReference.add(newsId);
          news.doc(newsId).set({
            "id": newsId,
            "title": e['title'],
            "newsImage": e['newsImage'],
            "date": e['date'],
            "content": e['content'],
            "url": e['url'],
            "channel": e['channel'],
            "likes": 0,
            "comments": [],
          });
        }
      }

      category.doc(element).set({"name": element, "news": listOfNewsReference});
    }
  }

  Stream<List<Channel>> listenToChannel() {
    return channel.snapshots().map((event) {
      return event.docs
          .map((e) => Channel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    });
  }

  Future<News> updateLike(String newsId) async {
    await news.doc(newsId).update({"likes": FieldValue.increment(1)});
    return News.fromMap((await getNewsModel([newsId])).first);
  }

  Future<News> unlikeNews(String newsId) async {
    await news.doc(newsId).update({"likes": FieldValue.increment(-1)});
    return News.fromMap((await getNewsModel([newsId])).first);
  }

  listenToChannelEvent() {
    listenToChannel().listen((event) {
      channelList.addAll(event);
    });
  }

  Stream<List<News>> getFirstNewsList(List<String> userCategories) {
    var tempList = <News>[];
    return news.limit(50).snapshots().map((event) {
      tempList.addAll(event.docs.map((e) {
        final newsData = e.data() as Map<String, dynamic>;
        return News.fromMap({
          "id": newsData['id'],
          "title": newsData['title'],
          "newsImage": newsData['newsImage'],
          "content": newsData['content'],
          "url": newsData['url'],
          "date": newsData['date'],
          "likes": newsData['likes'],
          "comment": newsData['comments'],
          "channel": channelList
              .where((element) => element.channel == newsData['channel'])
              .first
              .toMap()
        });
      }));

      newsList = tempList;

      return newsList;
    });
  }

  // Future<bool> checkIfNewsExists(String id, List<String> categoryName) async {
  //   final categoryDocument = await category.doc(categoryName).get();
  //   return (((categoryDocument.data() as Map<String, dynamic>)['news'] as List)
  //       .contains(id));
  // }

  Future<Stream<List<News>>> getNextNewsList() async {
    final prevDocument =
        await news.where('title', isEqualTo: newsList[newsList.length - 1].title).get();
    return news
        .startAfterDocument(prevDocument.docs.first)
        .limit(50)
        .snapshots()
        .map((event) {
      newsList.addAll(event.docs.map((e) {
        final newsData = e.data() as Map<String, dynamic>;
        return News.fromMap({
          "id": newsData['id'],
          "title": newsData['title'],
          "newsImage": newsData['newsImage'],
          "content": newsData['content'],
          "url": newsData['url'],
          "date": newsData['date'],
          "likes": newsData['likes'],
          "comment": newsData['comments'],
          "channel": channelList
              .where((element) => element.channel == newsData['channel'])
              .first
              .toMap()
        });
      }).toList());
      return newsList;
    });
  }

  Future<List> getNewsModel(List<String> idList) async {
    if (idList.isEmpty) {
      return [];
    } else {
      var resultNewsList = <Map<String, dynamic>>[];
      for (var element in idList) {
        final result = await news.where('id', isEqualTo: element).get();
        var listOfNewsSnapshot = result.docs;
        for (var e in listOfNewsSnapshot) {
          final newsData = e.data() as Map<String, dynamic>;
          resultNewsList.add(News.fromMap({
            "id": newsData['id'],
            "title": newsData['title'],
            "newsImage": newsData['newsImage'],
            "content": newsData['content'],
            "url": newsData['url'],
            "date": newsData['date'],
            "likes": newsData['likes'],
            "comment": newsData['comments'],
            "channel": channelList
                .where((element) => element.channel == newsData['channel'])
                .first
                .toMap()
          }).toMap());
        }
      }

      return resultNewsList;
    }
  }

  Future<News> addComments(CommentModel commentModel, String newsId) async {
    news.doc(newsId).update({
      "comments": FieldValue.arrayUnion([commentModel.toMap()])
    });
    final newsDoc = await news.where("id", isEqualTo: newsId).get();
    final newsData = newsDoc.docs.first.data() as Map<String, dynamic>;
    return News.fromMap({
      "id": newsData['id'],
      "title": newsData['title'],
      "newsImage": newsData['newsImage'],
      "content": newsData['content'],
      "url": newsData['url'],
      "date": newsData['date'],
      "likes": newsData['likes'],
      "comment": newsData['comments'],
      "channel": channelList
          .where((element) => element.channel == newsData['channel'])
          .first
          .toMap()
    });
  }

  Future<void> addToBookmarks(News newsToBookmark, String uid) {
    final newsId = newsToBookmark.id!;
    return (userRef.doc(uid).update(
      {
        'bookmark': FieldValue.arrayUnion([newsId])
      },
    ));
  }
}
