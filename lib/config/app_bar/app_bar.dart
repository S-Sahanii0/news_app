import 'package:flutter/material.dart';
import 'package:news_app/config/theme/theme.dart';
import 'package:news_app/utils/app_popup.dart';

class CustomAppBar {
  AppBar primaryAppBar({required String pageTitle}) {
    return AppBar(
      backgroundColor: AppColors.appWhite,
      title: Center(
        child: Text(
          pageTitle,
          style:
              AppStyle.semiBoldText16.copyWith(color: AppColors.darkBlueShade2),
        ),
      ),
      actions: const [
        Icon(
          Icons.search_outlined,
          size: 20,
          color: AppColors.darkBlueShade3,
        ),
        AppPopUp(),
      ],
    );
  }

  AppBar appBarWithBack(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appWhite,
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: const Icon(
          Icons.chevron_left_outlined,
          color: AppColors.appBlack,
          size: 20,
        ),
      ),
    );
  }
}
