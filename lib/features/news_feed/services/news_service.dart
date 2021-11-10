import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:news_app/features/categories/models/category_model.dart';
import 'package:news_app/features/news_feed/model/news_model.dart';
import 'package:uuid/uuid.dart';

class NewsService {
  CollectionReference category =
      FirebaseFirestore.instance.collection('category');
  CollectionReference channel =
      FirebaseFirestore.instance.collection('channel');
  CollectionReference news = FirebaseFirestore.instance.collection('news');
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

//         //   news.add({
//         //     "id": uuid.v4(),
//         //     "title": e['title'],
//         //     "newsImage": e['newsImage'],
//         //     "date": e['date'],
//         //     "content": e['content'],
//         //     "url": e['url'],
//         //     "channel": channel.doc(e['channel'],
//         //     ),
//         //   });
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

}
