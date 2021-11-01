import 'package:flutter/material.dart';
import 'package:news_app/config/theme/theme.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    Key? key,
    required this.cardText,
    this.canBeSaved = false,
    this.isSaved,
    required this.onTap,
    this.onTapheart,
  }) : super(key: key);

  final String cardText;
  final bool? canBeSaved;
  final bool? isSaved;
  final VoidCallback onTap;
  final VoidCallback? onTapheart;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
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
              cardText,
              style: AppStyle.mediumText14
                  .copyWith(color: AppColors.darkBlueShade1),
            ),
          ),
          const Spacer(
            flex: 6,
          ),
          if (canBeSaved!)
            GestureDetector(
              onTap: onTapheart,
              child: Image(
                  image:
                      isSaved ?? false ? AppIcons.heartTapped : AppIcons.heart),
            ),
          GestureDetector(
            onTap: onTap,
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
