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

class BookmarkTab extends StatefulWidget {
  final List<News> bookmarkList;
  const BookmarkTab({Key? key, required this.bookmarkList}) : super(key: key);

  @override
  State<BookmarkTab> createState() => _BookmarkTabState();
}

class _BookmarkTabState extends State<BookmarkTab> {
  @override
  Widget build(BuildContext context) {
    var bookmarks = widget.bookmarkList;
    return bookmarks.isEmpty
        ? const Center(
            child: Text("You dont have any bookmarks"),
          )
        : ListView.builder(
            itemCount: bookmarks.length,
            itemBuilder: (BuildContext context, int index) {
              return NewsDetailCard(
                channelName: bookmarks[index].channel.channel,
                newsDescription: bookmarks[index].content,
                newsTime: bookmarks[index].date,
                numberOfLikes: 10.toString(),
                numberOfComments: 10.toString(),
                onTapHeart: () {},
                onTapComment: () {},
                onTapBookmark: () {},
                onTapShare: () {
                  Share.share('check out this ${bookmarks[index].url}');
                },
                isBookmark: true,
                onTapMenu: () {},
                channelImage: bookmarks[index].channel.channelImage,
                imageUrl: bookmarks[index].newsImage,
              );
            },
          );
  }
}
