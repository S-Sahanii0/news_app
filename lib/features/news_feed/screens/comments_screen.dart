import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/app_bar/app_bar.dart';
import '../../../components/app_form_field.dart';
import '../model/news_model.dart';
import '../widgets/comment_card.dart';
import '../widgets/news_detail_card.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key, required this.newsModel}) : super(key: key);

  static const String route = "/kRouteComment";
  final News newsModel;
  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  bool isHeart = false;
  bool isBookmark = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar()
            .appBarWithBack(context: context, pageTitle: "Comments"),
        body: SingleChildScrollView(
          child: Column(
            children: [
              NewsDetailCard(
                channelName: widget.newsModel.channel.channel,
                newsDescription: widget.newsModel.content,
                newsTime: "6 hours ago",
                numberOfLikes: "100",
                numberOfComments: "100",
                commentTapped: true,
                isHeart: isHeart,
                isBookmark: isBookmark,
                onTapHeart: () {
                  setState(() {
                    isHeart = !isHeart;
                  });
                },
                onTapComment: () {},
                onTapBookmark: () {
                  setState(() {
                    isBookmark = !isBookmark;
                  });
                },
                onTapShare: () {},
                onTapMenu: () {},
                channelImage: '',
                imageUrl: widget.newsModel.newsImage,
              ),
              Divider(
                thickness: 2.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: AppFormField(
                    fieldTitle: "",
                    fieldName: "comment",
                    hintText: "Add your comment",
                    suffixIcon: Icons.send,
                    textInputAction: TextInputAction.done),
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return CommentCard(
                        commentor: "John",
                        noOfLikes: 1,
                        commentText: "Haha good one",
                        onTapHeart: () {});
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
