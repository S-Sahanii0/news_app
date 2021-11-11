import 'package:flutter/material.dart';
import 'package:news_app/features/news_feed/widgets/news_detail_card.dart';

class History extends StatelessWidget {
  const History({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      onTapMenu: () {},
      channelImage: '',
      imageUrl: '',
    );
  }
}
