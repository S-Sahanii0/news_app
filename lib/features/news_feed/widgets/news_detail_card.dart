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
    // TODO: implement initState
    // widget.isHeart = widget.isHeart;

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
          padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 126.h,
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
                              radius: 15,
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
                      Text(
                        widget.newsDescription,
                        style: AppStyle.boldText14
                            .copyWith(color: AppColors.darkBlueShade1),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
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
      required this.numberOfComments})
      : super(key: key);
  final VoidCallback onTapHeart;
  final VoidCallback onTapBookmark;
  final VoidCallback onTapComment;
  final VoidCallback onTapShare;
  final String numberOfLikes;
  final String numberOfComments;
  bool commentTapped;
  bool isHeart;
  bool isBookmark;

  @override
  __feedIconRowState createState() => __feedIconRowState();
}

class __feedIconRowState extends State<_feedIconRow> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,

      children: [
        InkWell(
          onTap: () {
            setState(() {
              widget.isHeart = !widget.isHeart;
            });
            widget.onTapHeart();
          },
          child: Image(
              image: widget.isHeart ? AppIcons.heartTapped : AppIcons.heart),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            widget.numberOfLikes,
            style: AppStyle.regularText12.copyWith(color: AppColors.greyShade2),
          ),
        ),
        SizedBox(
          width: 2.w,
        ),
        InkWell(
            onTap: widget.onTapComment,
            child: Image(
                image: widget.commentTapped
                    ? AppIcons.commentTapped
                    : AppIcons.comment)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            widget.numberOfComments,
            style: AppStyle.regularText12.copyWith(color: AppColors.greyShade2),
          ),
        ),
        const Spacer(
          flex: 4,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  widget.isBookmark = !widget.isBookmark;
                });
                widget.onTapBookmark();
              },
              child: Image(
                  image: widget.isBookmark
                      ? AppIcons.bookmarkTapped
                      : AppIcons.bookmark),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: InkWell(
                  onTap: () {
                    widget.onTapShare();
                  },
                  child: const Image(image: AppIcons.share)),
            ),
            InkWell(
                onTap: () {}, child: const Image(image: AppIcons.hamburger)),
          ],
        ),
      ],
    );
  }
}
