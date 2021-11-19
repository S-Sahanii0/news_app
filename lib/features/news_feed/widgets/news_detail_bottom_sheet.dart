import 'package:flutter/material.dart';
import '../../../config/theme/app_icons.dart';
import '../../../config/theme/theme.dart';

class NewsDetailBottomSheet extends StatefulWidget {
  const NewsDetailBottomSheet({Key? key}) : super(key: key);

  @override
  _NewsDetailBottomSheetState createState() => _NewsDetailBottomSheetState();
}

class _NewsDetailBottomSheetState extends State<NewsDetailBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: AppColors.blueShade1, boxShadow: [
        BoxShadow(
          blurRadius: 8,
          spreadRadius: 6,
          offset: Offset(0, 10),
        )
      ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: const [
            Icon(Icons.bookmark_outline, color: AppColors.blueShade3),
            Image(image: AppIcons.fontSize),
            Image(
              image: AppIcons.play,
            ),
            Image(
              image: AppIcons.share,
              color: AppColors.blueShade3,
            ),
            Image(image: AppIcons.hamburger, color: AppColors.blueShade3),
          ],
        ),
      ),
    );
  }
}
