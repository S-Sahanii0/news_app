import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/theme/theme.dart';

class AppButton extends StatelessWidget {
  const AppButton({Key? key, required this.onTap, required this.buttonText})
      : super(key: key);

  final VoidCallback onTap;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.blueShade1,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 7),
            child: Text(
              buttonText,
              style:
                  AppStyle.semiBoldText14.copyWith(color: AppColors.appWhite),
            ),
          ),
        ));
  }
}
