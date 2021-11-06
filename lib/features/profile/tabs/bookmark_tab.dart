import 'package:flutter/material.dart';
import 'package:news_app/features/news_feed/widgets/news_detail_card.dart';

class BookmarkTab extends StatelessWidget {
  const BookmarkTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NewsDetailCard(
        newsTitle: "Dummy",
        newsDescription: "Lorem  Lorem Lorem Lorem Lorem Lorem Lorem",
        newsTime: "6 hours ago",
        numberOfLikes: 10.toString(),
        numberOfComments: 10.toString(),
        onTapHeart: () {},
        onTapComment: () {},
        onTapBookmark: () {},
        onTapShare: () {},
        isBookmark: true,
        onTapMenu: () {});
  }
}
