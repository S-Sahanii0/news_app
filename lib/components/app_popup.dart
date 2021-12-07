import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/theme/app_icons.dart';
import '../config/theme/theme.dart';

class AppPopUp extends StatefulWidget {
  const AppPopUp({
    Key? key,
    required this.onTrending,
    required this.onDescending,
    required this.onAscending,
    required this.onRead,
    required this.onUnread,
    required this.onChannel,
  }) : super(key: key);
  final VoidCallback onTrending;
  final VoidCallback onDescending;
  final VoidCallback onAscending;
  final VoidCallback onRead;
  final VoidCallback onUnread;
  final VoidCallback onChannel;

  @override
  _AppPopUpState createState() => _AppPopUpState();
}

class _AppPopUpState extends State<AppPopUp> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: const Offset(0, 45),
      shape: const TooltipShape(),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(
          AppIcons.filter,
          color: AppColors.darkBlueShade1,
          size: 20,
        ),
      ),
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            enabled: false, // DISABLED THIS ITEM
            child: Container(
              width: 135.w,
              child: IntrinsicWidth(
                child: _FilteringTab(
                  onAscending: widget.onAscending,
                  onDescending: widget.onDescending,
                  onTrending: widget.onTrending,
                  onChannel: widget.onChannel,
                  onRead: widget.onRead,
                  onUnread: widget.onUnread,
                ),
              ),
            ),
          ),
        ];
      },
    );
  }
}

class _FilteringTab extends StatefulWidget {
  const _FilteringTab(
      {Key? key,
      required this.onTrending,
      required this.onDescending,
      required this.onAscending,
      required this.onRead,
      required this.onUnread,
      required this.onChannel})
      : super(key: key);

  final VoidCallback onTrending;
  final VoidCallback onDescending;
  final VoidCallback onAscending;
  final VoidCallback onRead;
  final VoidCallback onUnread;
  final VoidCallback onChannel;

  @override
  __FilteringTabState createState() => __FilteringTabState();
}

class __FilteringTabState extends State<_FilteringTab> {
  int currentIndex = 0;
  int? currentOptionIndex;
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
              onTap: () => setState(() => currentIndex = 0),
              child: Text(
                "Sort",
                style: AppStyle.regularText12.copyWith(
                  color: currentIndex == 1
                      ? AppColors.darkBlueShade3
                      : AppColors.darkBlueShade1,
                ),
              ),
            ),
            SizedBox(width: 69.w),
            GestureDetector(
              onTap: () => setState(() => currentIndex = 1),
              child: Text(
                "Filter",
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
        currentIndex == 0
            ? SizedBox(
                height: 80.h,
                width: 170.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Option(
                      option: 'Newest to Oldest',
                      onTap: () => setState(() {
                        widget.onAscending();
                        currentOptionIndex = 0;
                      }),
                      isSelected: currentOptionIndex == 0,
                    ),
                    _Option(
                      option: 'Old to Newest',
                      onTap: () => setState(() {
                        widget.onDescending();
                        currentOptionIndex = 1;
                      }),
                      isSelected: currentOptionIndex == 1,
                    ),
                    _Option(
                      option: 'All',
                      onTap: () => setState(() {
                        widget.onTrending();
                        currentOptionIndex = 2;
                      }),
                      isSelected: currentOptionIndex == 2,
                    ),
                  ],
                ),
              )
            : SizedBox(
                height: 80.h,
                width: 170.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Option(
                      option: 'Read',
                      onTap: () => setState(() {
                        widget.onRead();
                        currentOptionIndex = 0;
                      }),
                      isSelected: currentOptionIndex == 0,
                    ),
                    _Option(
                      option: 'Unread',
                      onTap: () => setState(() {
                        widget.onUnread();
                        currentOptionIndex = 1;
                      }),
                      isSelected: currentOptionIndex == 1,
                    ),
                    _Option(
                      option: 'All',
                      onTap: () => setState(() {
                        widget.onChannel();
                        currentOptionIndex = 2;
                      }),
                      isSelected: currentOptionIndex == 2,
                    ),
                  ],
                ),
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
      {Key? key, required this.option, required this.onTap, required this.isSelected})
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
          color: widget.isSelected ? AppColors.darkBlueShade1 : AppColors.darkBlueShade3,
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
              color:
                  widget.isSelected ? AppColors.darkBlueShade1 : AppColors.darkBlueShade3,
            ),
          ),
        ),
      ],
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
    path.quadraticBezierTo(rrect.width, rrect.height, rrect.width - 10, rrect.height);
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
