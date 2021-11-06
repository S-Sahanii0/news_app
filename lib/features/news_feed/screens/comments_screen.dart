import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/components/app_bar/app_bar.dart';
import 'package:news_app/components/app_form_field.dart';
import 'package:news_app/config/theme/theme.dart';
import 'package:news_app/features/news_feed/widgets/comment_card.dart';
import 'package:news_app/features/news_feed/widgets/news_detail_card.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key}) : super(key: key);

  static const String route = "/kRouteComment";
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
                newsTitle: "DummyTitle",
                newsDescription:
                    "Lorem LORem Lorem Lorem Lorem Lorem Lorem Lorem Lorem",
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
