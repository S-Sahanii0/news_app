import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/theme/theme.dart';

class AppCard extends StatefulWidget {
  AppCard.hasHeart({
    Key? key,
    required this.cardText,
    required this.isSaved,
    required this.onTap,
    required this.onTapheart,
  }) : super(key: key) {
    canBeSaved = true;
    hasNumber = false;
    canBeRemoved = false;
    hasArrow = true;
  }
  AppCard.hasNumber(
      {Key? key,
      required this.cardText,
      required this.onTap,
      required this.number})
      : super(key: key) {
    canBeSaved = false;
    hasNumber = true;
    canBeRemoved = false;
    hasArrow = true;
  }

  AppCard.hasRemoveButton({
    Key? key,
    required this.cardText,
    required this.onTapRemove,
  }) : super(key: key) {
    canBeSaved = false;
    hasNumber = false;
    canBeRemoved = true;
    hasArrow = false;
  }
  AppCard({
    Key? key,
    required this.cardText,
    required this.onTap,
  }) : super(key: key) {
    canBeSaved = false;
    hasNumber = false;
    canBeRemoved = false;
    hasArrow = true;
  }

  final String cardText;
  bool? canBeSaved;
  bool? isSaved;
  bool? hasNumber;
  bool? canBeRemoved;
  int? number;
  bool? hasArrow;
  VoidCallback? onTap;
  VoidCallback? onTapRemove;
  VoidCallback? onTapheart;

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppColors.yellowShade2,
            radius: 15,
            backgroundImage: ExactAssetImage("assets/images/dummy_channel.png"),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              widget.cardText,
              style: AppStyle.mediumText14
                  .copyWith(color: AppColors.darkBlueShade1),
            ),
          ),
          const Spacer(
            flex: 6,
          ),
          if (widget.hasNumber!)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                widget.number.toString(),
                style: AppStyle.mediumText16
                    .copyWith(color: AppColors.darkBlueShade1),
              ),
            ),
          if (widget.canBeRemoved!)
            GestureDetector(
                onTap: () => widget.onTapRemove!(),
                child:
                    const Icon(Icons.remove_circle_outline_rounded, size: 24)),
          if (widget.canBeSaved!)
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.isSaved = !widget.isSaved!;
                });

                widget.onTapheart!();
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Icon(
                  widget.isSaved! ? AppIcons.heartTapped : AppIcons.heart,
                  color: widget.isSaved!
                      ? Colors.red.shade800
                      : AppColors.darkBlueShade1,
                  size: 24,
                ),
              ),
            ),
          if (widget.hasArrow!)
            GestureDetector(
              onTap: widget.onTap,
              child: const Icon(
                Icons.chevron_right_outlined,
                color: AppColors.darkBlueShade2,
                size: 24,
              ),
            ),
        ],
      ),
    );
  }
}
