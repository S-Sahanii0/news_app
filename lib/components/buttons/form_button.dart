import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/config/theme/theme.dart';

class FormButton extends StatelessWidget {
  const FormButton({Key? key, required this.onTap}) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.blueShade1,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 52, vertical: 7),
            child: Icon(
              Icons.chevron_right_outlined,
              color: AppColors.appWhite,
            ),
          )),
    );
  }
}
