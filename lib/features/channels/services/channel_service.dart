import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news_app/features/channels/models/channel_model.dart';
import 'package:news_app/features/news_feed/model/news_model.dart';
import 'package:news_app/features/news_feed/services/news_service.dart';

class ChannelService {
  final NewsService newsService;
  final CollectionReference channelRef =
      FirebaseFirestore.instance.collection('channel');
  final CollectionReference newsRef =
      FirebaseFirestore.instance.collection('news');

  ChannelService({required this.newsService});

  Future<List<Channel>> getChannelList() async {
    final channelDoc = await channelRef.get();
    final channelList = <Channel>[];
    channelDoc.docs.forEach((element) {
      final channelData = element.data() as Map<String, dynamic>;
      channelList.add(Channel.fromMap(channelData));
    });
    return channelList;
  }

  Future<List<News>> getNewsByChannel(String channelName) async {
    final newsDoc =
        await newsRef.where('channel', isEqualTo: channelName).get();
    final newsListId = [];
    newsDoc.docs.forEach((element) {
      final newsData = element.data() as Map<String, dynamic>;
      newsListId.add(newsData['id']);
    });
    final List<dynamic> listOfNewsMap = await newsService
        .getNewsModel(newsListId.map((e) => e.toString()).toList());
    return listOfNewsMap.map((e) => News.fromMap(e)).toList();
  }
}
