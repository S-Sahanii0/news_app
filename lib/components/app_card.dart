import 'package:flutter/material.dart';
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
  }
  AppCard.hasNumber(
      {Key? key,
      required this.cardText,
      required this.onTap,
      required this.number})
      : super(key: key) {
    canBeSaved = false;
    hasNumber = true;
  }
  AppCard({
    Key? key,
    required this.cardText,
    required this.onTap,
  }) : super(key: key) {
    canBeSaved = false;
    hasNumber = false;
  }

  final String cardText;
  bool? canBeSaved;
  bool? isSaved;
  bool? hasNumber;
  int? number;
  final VoidCallback onTap;
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
          if (widget.canBeSaved!)
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.isSaved = !widget.isSaved!;
                });

                widget.onTapheart;
              },
              child: Image(
                  image:
                      widget.isSaved! ? AppIcons.heartTapped : AppIcons.heart),
            ),
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
