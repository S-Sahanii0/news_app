import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

import '../../channels/models/channel_model.dart';

import '../model/news_model.dart';

class NewsService {
  NewsService() {
    listenToChannelEvent();
  }
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  CollectionReference category =
      FirebaseFirestore.instance.collection('category');
  CollectionReference channel =
      FirebaseFirestore.instance.collection('channel');
  CollectionReference news = FirebaseFirestore.instance.collection('news');
  List<Channel> channelList = [];
  List<News> newsList = [];

  var uuid = Uuid();

  Future<void> addDataToFirebase() async {
    final String response =
        await rootBundle.loadString('assets/data/news_data.json');
    final data = await json.decode(response);

    List.from(data.keys).forEach((element) {
      final listOfNewsReference = [];
      List.from(data[element]).forEach((e) {
        final newsId = uuid.v4();
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
      });

      category.doc(element).set({"name": element, "news": listOfNewsReference});
    });
  }

  Stream<List<Channel>> listenToChannel() {
    return channel.snapshots().map((event) {
      return event.docs
          .map((e) => Channel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
    });
  }

  listenToChannelEvent() {
    listenToChannel().listen((event) {
      channelList.addAll(event);
    });
  }

  Stream<List<News>> getFirstNewsList() {
    return news.limit(20).snapshots().map((event) {
      newsList.addAll(event.docs.map((e) {
        final newsData = e.data() as Map<String, dynamic>;
        return News.fromMap({
          "id": newsData['id'],
          "title": newsData['title'],
          "newsImage": newsData['newsImage'],
          "content": newsData['content'],
          "url": newsData['url'],
          "date": newsData['date'],
          "channel": channelList
              .where((element) => element.channel == newsData['channel'])
              .first
              .toMap()
        });
      }).toList());
      return newsList;
    });
  }

  Future<Stream<List<News>>> getNextNewsList() async {
    final prevDocument = await news
        .where('title', isEqualTo: newsList[newsList.length - 1].title)
        .get();
    return news
        .startAfterDocument(prevDocument.docs.first)
        .limit(20)
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
          "channel": channelList
              .where((element) => element.channel == newsData['channel'])
              .first
              .toMap()
        });
      }).toList());
      return newsList;
    });
  }

  Future getNewsModel(List<String> idList) async {
    if (idList.isEmpty) {
      return [];
    } else {
      final result = await news.where('id', whereIn: idList).get();
      var resultNewsList = <Map<String, dynamic>>[];
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
          "channel": channelList
              .where((element) => element.channel == newsData['channel'])
              .first
              .toMap()
        }).toMap());
      }
      return resultNewsList;
    }
  }

  Future<void> addToBookmarks(News newsToBookmark, String uid) {
    final newsId = newsToBookmark.id!;
    return (userRef.doc(uid).update(
      {
        'bookmark': FieldValue.arrayUnion([newsId])
      },
    ));
  }

  Future<void> removeFromBookmarks(News newsToBookmark, String uid) {
    final newsId = newsToBookmark.id!;
    return (userRef.doc(uid).update(
      {
        'bookmark': FieldValue.arrayRemove([newsId])
      },
    ));
  }

  Future<List> getAllBookmarks(String uid) async {
    return ((await userRef.where('id', isEqualTo: uid).get()).docs.first.data()
        as Map<String, dynamic>)['bookmark'];
  }

  Future<void> addToHistory(News newsToAdd, String uid) {
    final newsId = newsToAdd.id!;
    return userRef.doc(uid).update({
      'history': FieldValue.arrayUnion([newsId])
    });
  }

  Future<void> removeFromHistory(News newsToAdd, String uid) {
    final newsId = newsToAdd.id!;
    return (userRef.doc(uid).update(
      {
        'history': FieldValue.arrayRemove([newsId])
      },
    ));
  }
}
