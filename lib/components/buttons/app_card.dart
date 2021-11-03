import 'package:flutter/material.dart';
import 'package:news_app/config/theme/theme.dart';

class AppCard extends StatefulWidget {
  AppCard({
    Key? key,
    required this.cardText,
    this.canBeSaved = false,
    this.isSaved = false,
    required this.onTap,
    this.onTapheart,
  }) : super(key: key);

  final String cardText;
  bool canBeSaved;
  bool isSaved;
  final VoidCallback onTap;
  final VoidCallback? onTapheart;

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
          if (widget.canBeSaved)
            GestureDetector(
              onTap: () {
                setState(() {
                  widget.isSaved = !widget.isSaved;
                });

                widget.onTapheart;
              },
              child: Image(
                  image:
                      widget.isSaved ? AppIcons.heartTapped : AppIcons.heart),
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
