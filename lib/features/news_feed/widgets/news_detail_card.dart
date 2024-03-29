import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/app_icons.dart';
import '../../../config/theme/theme.dart';

class NewsDetailCard extends StatefulWidget {
  final String channelName;
  final String newsDescription;
  final String newsTime;
  final String numberOfLikes;
  final String numberOfComments;
  final String imageUrl;
  final String channelImage;
  bool? isHeart;
  bool? isBookmark;
  bool? commentTapped;
  final VoidCallback onTapHeart;
  final VoidCallback onTapComment;
  final VoidCallback onTapBookmark;
  final VoidCallback onTapShare;
  final VoidCallback onTapMenu;

  NewsDetailCard(
      {Key? key,
      required this.channelName,
      required this.newsDescription,
      required this.newsTime,
      required this.numberOfLikes,
      required this.numberOfComments,
      required this.onTapHeart,
      required this.onTapComment,
      required this.onTapBookmark,
      required this.onTapShare,
      required this.onTapMenu,
      required this.imageUrl,
      required this.channelImage,
      this.commentTapped = false,
      this.isHeart,
      this.isBookmark = false})
      : super(key: key);

  @override
  _NewsDetailCardState createState() => _NewsDetailCardState();
}

class _NewsDetailCardState extends State<NewsDetailCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      widthFactor: 10.sw,
      alignment: Alignment.topCenter,
      child: ColoredBox(
        color: AppColors.appWhite,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 120.h,
                width: 120.w,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: AppColors.yellowShade1, width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: NetworkImage(widget.imageUrl),
                      )),
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 8,
                            child: CircleAvatar(
                              backgroundColor: AppColors.yellowShade2,
                              radius: 10,
                              child: Image(
                                fit: BoxFit.contain,
                                image: NetworkImage(widget.channelImage),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Flexible(
                            flex: 18,
                            child: Text(widget.channelName,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyle.regularText12
                                    .copyWith(color: AppColors.darkBlueShade2)),
                          ),
                          const Spacer(
                            flex: 6,
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Text(widget.newsTime,
                                style: AppStyle.regularText12
                                    .copyWith(color: AppColors.darkBlueShade2)),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Text(
                        widget.newsDescription,
                        style: AppStyle.boldText14
                            .copyWith(color: AppColors.darkBlueShade1),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: _feedIconRow(
                          onTapHeart: widget.onTapHeart,
                          onTapBookmark: widget.onTapBookmark,
                          onTapComment: widget.onTapComment,
                          onTapShare: widget.onTapShare,
                          isHeart: widget.isHeart ?? false,
                          isBookmark: widget.isBookmark!,
                          commentTapped: widget.commentTapped!,
                          numberOfLikes: widget.numberOfLikes,
                          numberOfComments: widget.numberOfComments,
                          onTapMenu: widget.onTapMenu,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _feedIconRow extends StatefulWidget {
  _feedIconRow(
      {Key? key,
      required this.onTapHeart,
      required this.onTapBookmark,
      required this.onTapComment,
      required this.onTapShare,
      this.commentTapped = false,
      required this.isHeart,
      this.isBookmark = false,
      required this.numberOfLikes,
      required this.numberOfComments,
      required this.onTapMenu})
      : super(key: key);
  final VoidCallback onTapHeart;
  final VoidCallback onTapBookmark;
  final VoidCallback onTapComment;
  final String numberOfLikes;
  final VoidCallback onTapShare;
  final VoidCallback onTapMenu;
  final String numberOfComments;
  bool commentTapped;
  bool isHeart;
  bool isBookmark;

  @override
  __feedIconRowState createState() => __feedIconRowState();
}

class __feedIconRowState extends State<_feedIconRow> {
  late bool isLiked;
  @override
  void initState() {
    super.initState();
    isLiked = widget.isHeart;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  isLiked = !isLiked;
                });
                EasyDebounce.debounce('tag', Duration(milliseconds: 500), () {
                  widget.onTapHeart();
                });
              },
              child: Icon(isLiked ? AppIcons.heartTapped : AppIcons.heart,
                  color:
                      isLiked ? Colors.red.shade800 : AppColors.darkBlueShade2,
                  size: 23),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                widget.numberOfLikes,
                style: AppStyle.regularText12
                    .copyWith(color: AppColors.greyShade2),
              ),
            ),
          ],
        ),
        Row(
          children: [
            InkWell(
                onTap: widget.onTapComment,
                child: Icon(
                  widget.commentTapped
                      ? AppIcons.commentTapped
                      : AppIcons.comment,
                  color: AppColors.darkBlueShade2,
                  size: 20,
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                widget.numberOfComments,
                style: AppStyle.regularText12
                    .copyWith(color: AppColors.greyShade2),
              ),
            ),
          ],
        ),
        InkWell(
          onTap: () {
            setState(() {
              widget.isBookmark = !widget.isBookmark;
            });
            widget.onTapBookmark();
          },
          child: Icon(
            widget.isBookmark ? AppIcons.bookmarkTapped : AppIcons.bookmark,
            color: widget.isBookmark
                ? Colors.red.shade800
                : AppColors.darkBlueShade2,
            size: 20,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: InkWell(
              onTap: () {
                widget.onTapShare();
              },
              child: const Icon(
                AppIcons.share,
                color: AppColors.darkBlueShade2,
                size: 20,
              )),
        ),
        // InkWell(
        //     onTap: () {
        //       widget.onTapMenu;
        //     },
        //     child: const Icon(
        //       AppIcons.hamburger,
        //       color: AppColors.darkBlueShade2,
        //       size: 20,
        //     )),
      ],
    );
  }
}
