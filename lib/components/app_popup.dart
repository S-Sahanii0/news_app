import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/theme/app_icons.dart';
import '../config/theme/theme.dart';

class AppPopUp extends StatefulWidget {
  const AppPopUp({Key? key}) : super(key: key);

  @override
  _AppPopUpState createState() => _AppPopUpState();
}

class _AppPopUpState extends State<AppPopUp> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(0, 45),
      shape: const TooltipShape(),
      child: const Image(image: AppIcons.filter),
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            enabled: false, // DISABLED THIS ITEM
            child: IntrinsicWidth(child: _FilteringTab()),
          ),
        ];
      },
    );
  }
}

class TooltipShape extends ShapeBorder {
  const TooltipShape();

  final BorderSide _side = BorderSide.none;
  final BorderRadiusGeometry _borderRadius = BorderRadius.zero;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(_side.width);

  @override
  Path getInnerPath(
    Rect rect, {
    TextDirection? textDirection,
  }) {
    final Path path = Path();

    path.addRRect(
      _borderRadius.resolve(textDirection).toRRect(rect).deflate(_side.width),
    );

    return path;
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final Path path = Path();
    final RRect rrect = _borderRadius.resolve(textDirection).toRRect(rect);

    path.moveTo(0, 10);
    path.quadraticBezierTo(0, 0, 10, 0);
    path.lineTo(rrect.width - 30, 0);
    path.lineTo(rrect.width - 20, -10);
    path.lineTo(rrect.width - 10, 0);
    path.quadraticBezierTo(rrect.width, 0, rrect.width, 10);
    path.lineTo(rrect.width, rrect.height - 10);
    path.quadraticBezierTo(
        rrect.width, rrect.height, rrect.width - 10, rrect.height);
    path.lineTo(10, rrect.height);
    path.quadraticBezierTo(0, rrect.height, 0, rrect.height - 10);

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => RoundedRectangleBorder(
        side: _side.scale(t),
        borderRadius: _borderRadius * t,
      );
}

class _FilteringTab extends StatefulWidget {
  const _FilteringTab({Key? key}) : super(key: key);

  @override
  __FilteringTabState createState() => __FilteringTabState();
}

class __FilteringTabState extends State<_FilteringTab> {
  int currentIndex = 0;
  int? currentOptionIndex;
  List<String> option = ["Read", "UnRead", "Channel"];
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  currentIndex = 0;
                  option = ["Read", "UnRead", "Channel"];
                });
              },
              child: Text(
                "Filter",
                style: AppStyle.regularText12.copyWith(
                    color: currentIndex == 1
                        ? AppColors.darkBlueShade3
                        : AppColors.darkBlueShade1),
              ),
            ),
            SizedBox(width: 69.w),
            GestureDetector(
              onTap: () {
                setState(() {
                  currentIndex = 1;
                  option = ["Newest to Oldest", "Old To Newest", "Trending"];
                });
              },
              child: Text(
                "Sort",
                style: AppStyle.regularText12.copyWith(
                    color: currentIndex == 1
                        ? AppColors.darkBlueShade1
                        : AppColors.darkBlueShade3),
              ),
            )
          ],
        ),
        const Divider(
          thickness: 2,
        ),
        SizedBox(
          height: 80.h,
          width: 170.h,
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: option.length,
              itemBuilder: (context, index) {
                return _Option(
                  option: option[index],
                  onTap: () {
                    setState(() {
                      currentOptionIndex = index;
                    });
                  },
                  isSelected: currentOptionIndex == index,
                );
              }),
        )
      ],
    );
  }
}

class _Option extends StatefulWidget {
  final String option;

  final VoidCallback onTap;
  final bool isSelected;
  const _Option(
      {Key? key,
      required this.option,
      required this.onTap,
      required this.isSelected})
      : super(key: key);

  @override
  __OptionState createState() => __OptionState();
}

class __OptionState extends State<_Option> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.done,
          color: widget.isSelected
              ? AppColors.darkBlueShade1
              : AppColors.darkBlueShade3,
          size: 20,
        ),
        SizedBox(
          width: 15.w,
        ),
        GestureDetector(
          onTap: widget.onTap,
          child: Text(
            widget.option,
            style: AppStyle.regularText12.copyWith(
                color: widget.isSelected
                    ? AppColors.darkBlueShade1
                    : AppColors.darkBlueShade3),
          ),
        ),
      ],
    );
  }
}
