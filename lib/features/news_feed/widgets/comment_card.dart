import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/theme.dart';

class CommentCard extends StatefulWidget {
  CommentCard({
    Key? key,
    required this.commentor,
    required this.noOfLikes,
    required this.commentText,
    required this.onTapHeart,
    this.isLiked = false,
  }) : super(key: key);

  final String commentor;
  final int noOfLikes;
  final String commentText;
  bool isLiked;
  final VoidCallback onTapHeart;

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.yellowShade2,
                radius: 15,
                backgroundImage:
                    ExactAssetImage("assets/images/dummy_channel.png"),
              ),
              SizedBox(
                width: 10.w,
              ),
              Text(
                widget.commentor,
                style: AppStyle.regularText14
                    .copyWith(color: AppColors.darkBlueShade2),
              ),
              Spacer(
                flex: 6,
              ),
              Text(
                widget.noOfLikes.toString(),
                style: AppStyle.regularText12
                    .copyWith(color: AppColors.darkBlueShade3),
              ),
              SizedBox(
                width: 10.w,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    widget.isLiked = !widget.isLiked;
                  });
                  widget.onTapHeart;
                },
                child: Image(
                    image:
                        widget.isLiked ? AppIcons.heartTapped : AppIcons.heart),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              widget.commentText,
              style: AppStyle.regularText14
                  .copyWith(color: AppColors.darkBlueShade1),
            ),
          ),
          Divider(
            thickness: 2.h,
          ),
        ],
      ),
    );
  }
}
