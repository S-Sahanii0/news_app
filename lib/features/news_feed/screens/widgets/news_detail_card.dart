import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/config/theme/app_icons.dart';
import 'package:news_app/config/theme/theme.dart';

class NewsDetailCard extends StatefulWidget {
  final String newsTitle;
  final String newsDescription;
  final String newsTime;
  final String numberOfLikes;
  final String numberOfComments;
  bool? isHeart;
  bool? isBookmark;
  final VoidCallback onTapHeart;
  final VoidCallback onTapComment;
  final VoidCallback onTapBookmark;
  final VoidCallback onTapShare;
  final VoidCallback onTapMenu;

  NewsDetailCard(
      {Key? key,
      required this.newsTitle,
      required this.newsDescription,
      required this.newsTime,
      required this.numberOfLikes,
      required this.numberOfComments,
      required this.onTapHeart,
      required this.onTapComment,
      required this.onTapBookmark,
      required this.onTapShare,
      required this.onTapMenu,
      this.isHeart = false,
      this.isBookmark = false})
      : super(key: key);

  @override
  _NewsDetailCardState createState() => _NewsDetailCardState();
}

class _NewsDetailCardState extends State<NewsDetailCard> {
  ImageProvider isHeart = AppIcons.heart;
  ImageProvider isComment = AppIcons.comment;
  ImageProvider isBookmark = AppIcons.bookmark;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.appWhite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: AppIcons.dummy,
              height: 126.h,
              width: 120.w,
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          backgroundColor: AppColors.yellowShade2,
                          radius: 12,
                          backgroundImage: ExactAssetImage(
                              "assets/images/dummy_channel.png"),
                        ),
                        SizedBox(
                          width: 10.h,
                        ),
                        Text(widget.newsTitle,
                            style: AppStyle.regularText12
                                .copyWith(color: AppColors.darkBlueShade2)),
                        const Spacer(),
                        Text(widget.newsTime,
                            style: AppStyle.regularText12
                                .copyWith(color: AppColors.darkBlueShade2)),
                      ],
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        widget.newsDescription,
                        style: AppStyle.boldText14
                            .copyWith(color: AppColors.darkBlueShade1),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    const Divider(
                      thickness: 2,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: widget.onTapHeart,
                          child: Image(
                              image: widget.isHeart!
                                  ? AppIcons.heartTapped
                                  : AppIcons.heart),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "100",
                            style: AppStyle.regularText12
                                .copyWith(color: AppColors.greyShade2),
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        InkWell(
                            onTap: widget.onTapComment,
                            child: const Image(image: AppIcons.comment)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            "100",
                            style: AppStyle.regularText12
                                .copyWith(color: AppColors.greyShade2),
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: widget.onTapBookmark,
                          child: const Image(image: AppIcons.bookmark),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: InkWell(
                              onTap: widget.onTapShare,
                              child: const Image(image: AppIcons.share)),
                        ),
                        InkWell(
                            onTap: () {},
                            child: const Image(image: AppIcons.hamburger)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
