import 'package:flutter/material.dart';
import '../../../config/theme/app_icons.dart';
import '../../../config/theme/theme.dart';

class NewsDetailBottomSheet extends StatefulWidget {
  const NewsDetailBottomSheet(
      {Key? key, required this.onPlay, required this.shouldPlay})
      : super(key: key);

  final Function(bool) onPlay;
  final bool shouldPlay;

  @override
  _NewsDetailBottomSheetState createState() => _NewsDetailBottomSheetState();
}

class _NewsDetailBottomSheetState extends State<NewsDetailBottomSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
        value: widget.shouldPlay ? 1 : null);
  }

  @override
  Widget build(BuildContext context) {
    animationController.value = widget.shouldPlay ? 1 : 0;
    print('should play: ${widget.shouldPlay}');
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
          children: [
            const Icon(Icons.bookmark_outline,
                color: AppColors.blueShade3, size: 20),
            const Image(image: AppIcons.fontSize),
            InkWell(
                onTap: () {
                  final isPlaying = animationController.value == 0;
                  widget.onPlay(!isPlaying);
                  isPlaying
                      ? animationController.forward()
                      : animationController.reverse();
                },
                child: AnimatedIcon(
                  icon: AnimatedIcons.play_pause,
                  progress: animationController,
                  color: AppColors.appWhite,
                )),
            const Icon(
              AppIcons.share,
              color: AppColors.blueShade3,
              size: 20,
            ),
            const Icon(AppIcons.hamburger,
                color: AppColors.blueShade3, size: 20),
          ],
        ),
      ),
    );
  }
}
