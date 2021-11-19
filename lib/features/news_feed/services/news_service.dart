import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import '../../categories/models/category_model.dart';
import '../../channels/models/channel_model.dart';
import 'package:uuid/uuid.dart';

import '../model/news_model.dart';

class NewsService {
  CollectionReference userRef = FirebaseFirestore.instance.collection('users');
  CollectionReference category =
      FirebaseFirestore.instance.collection('category');
  CollectionReference channel =
      FirebaseFirestore.instance.collection('channel');
  CollectionReference news = FirebaseFirestore.instance.collection('news');
  List<Channel> channelList = [];
  List<News> newsList = [];

  Stream<List<Channel>> listenToChannel() {
    return channel.snapshots().map((event) {
      channelList = event.docs
          .map((e) => Channel.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      return channelList;
    });
  }

  Stream<List<News>> getFirstNewsList() {
    listenToChannel().listen((event) {
      channelList = event;
    });
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
    listenToChannel().listen((event) {
      channelList = event;
    });
    if (idList.isEmpty) {
      return [];
    } else {
      final result = await news.where('id', whereIn: idList).get();
      print(result.docs.first.data());
      print(channelList);
      var resultNewsList = <Map<String, dynamic>>[];
      var listOfNewsSnapshot = result.docs;
      for (var e in listOfNewsSnapshot) {
        print(e.data());
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

  Future<List> getAllBookmarks(String uid) async {
    return ((await userRef.where('id', isEqualTo: uid).get()).docs.first.data()
        as Map<String, dynamic>)['bookmark'];
  }

  Future<void> addToHistory(News newsToBookmark, String uid) {
    final newsId = newsToBookmark.id!;
    return userRef.doc(uid).update({
      'history': FieldValue.arrayUnion([newsId])
    });
  }
}
  



//   var uuid = Uuid();

//   Future<void> addDataToFirebase() async {
//     final String response =
//         await rootBundle.loadString('assets/data/news_data.json');
//     final data = await json.decode(response);

//     List.from(data.keys).forEach((element) {
//       final listOfNewsReference = [];
//       List.from(data[element]).forEach((e) {
//         listOfNewsReference.add(news.doc(e['title']));
//         // channel
//         //     .doc(e['channel'])
//         //     .set({"channel": e['channel'], "channelImage": e['channelImage']});

//         news.add({
//           "id": uuid.v4(),
//           "title": e['title'],
//           "newsImage": e['newsImage'],
//           "date": e['date'],
//           "content": e['content'],
//           "url": e['url'],
//           "channel": e['channel'],
//         });
//         // final category_data = CategoryModel.fromMap(
//         //   {
//         //     "name":element,
//         //     "news": {
//         //       "title": e['title'],
//         //       "newsImage": e['newsImage'],
//         //       "date": e['date'],
//         //       "content": e['content'],
//         //       "url": e['url'],
//         //       "channel": {
//         //         "channel":e['channel'],
//         //         "channelImage":e['channelImage'],
//         //       }
//         //     }
//         //   }
//         // );
//       });

//       category.doc(element).set({"name": element, "news": listOfNewsReference});
//     });
//   }
// }
