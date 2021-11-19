import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/features/auth/bloc/auth_bloc.dart';
import 'package:news_app/features/auth/services/auth_service.dart';
import 'package:news_app/features/news_feed/screens/my_feed.dart';
import 'package:news_app/features/news_feed/services/news_service.dart';
import 'package:news_app/features/news_feed/widgets/news_detail_card.dart';

class BookmarkTab extends StatefulWidget {
  const BookmarkTab({Key? key}) : super(key: key);

  @override
  State<BookmarkTab> createState() => _BookmarkTabState();
}

class _BookmarkTabState extends State<BookmarkTab> {
  late String uid;
  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: NewsService().getAllBookmarks(uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return (snapshot.data)!.isEmpty
                ? const Center(
                    child: Text('You don\'t have any bookmarks'),
                  )
                : ListView.builder(
                    itemCount: (snapshot.data)!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return NewsDetailCard(
                        channelName: "Dummy",
                        newsDescription: "Lorem  Lorem Lorem Lorem Lorem Lorem Lorem",
                        newsTime: "6 hours ago",
                        numberOfLikes: 10.toString(),
                        numberOfComments: 10.toString(),
                        onTapHeart: () {},
                        onTapComment: () {},
                        onTapBookmark: () {},
                        onTapShare: () {},
                        isBookmark: true,
                        onTapMenu: () {},
                        channelImage: '',
                        imageUrl: '',
                      );
                    },
                  );
          }
          return const AppLoadingIndicator();
          // return NewsDetailCard(
          //   channelName: "Dummy",
          //   newsDescription: "Lorem  Lorem Lorem Lorem Lorem Lorem Lorem",
          //   newsTime: "6 hours ago",
          //   numberOfLikes: 10.toString(),
          //   numberOfComments: 10.toString(),
          //   onTapHeart: () {},
          //   onTapComment: () {},
          //   onTapBookmark: () {},
          //   onTapShare: () {},
          //   isBookmark: true,
          //   onTapMenu: () {},
          //   channelImage: '',
          //   imageUrl: '',
          // );
        });
  }
}
