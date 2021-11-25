import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/news_feed/model/news_model.dart';
import 'package:share_plus/share_plus.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/services/auth_service.dart';
import '../../news_feed/screens/my_feed.dart';
import '../../news_feed/services/news_service.dart';
import '../../news_feed/widgets/news_detail_card.dart';

class History extends StatefulWidget {
  final List<News> historyList;
  const History({Key? key, required this.historyList}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    final historyList = widget.historyList;
    return historyList.isEmpty
        ? const Center(
            child: Text("You dont liked news"),
          )
        : ListView.builder(
            itemCount: historyList.length,
            itemBuilder: (BuildContext context, int index) {
              return NewsDetailCard(
                channelName: historyList[index].channel.channel,
                newsDescription: historyList[index].content,
                newsTime: historyList[index].date,
                numberOfLikes: 10.toString(),
                numberOfComments: 10.toString(),
                onTapHeart: () {},
                onTapComment: () {},
                onTapBookmark: () {},
                onTapShare: () {
                  Share.share('check out this ${historyList[index].url}');
                },
                isBookmark: false,
                isHeart: true,
                onTapMenu: () {},
                channelImage: historyList[index].channel.channelImage,
                imageUrl: historyList[index].newsImage,
              );
            },
          );
  }
}
