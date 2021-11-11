import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/news_model.dart';

class NewsService {
  CollectionReference category =
      FirebaseFirestore.instance.collection('category');
  CollectionReference channel =
      FirebaseFirestore.instance.collection('channel');
  CollectionReference news = FirebaseFirestore.instance.collection('news');

  Future<List<News>> getAllNews() async {
    final newsDocs = await news.get();
    List<News> result = [];
    for (var newsDoc in newsDocs.docs) {
      final newsData = newsDoc.data() as Map<String, dynamic>;

      result.add(News.fromMap({
        "title": newsData['title'],
        "newsImage": newsData['newsImage'],
        "content": newsData['content'],
        "url": newsData['url'],
        "date": newsData['date'],
        "channel":
            (await (newsData['channel'] as DocumentReference).get()).data()
      }));
    }

    return result;
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
