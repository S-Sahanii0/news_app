import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../app_popup.dart';
import '../../config/theme/theme.dart';
import '../../features/news_feed/screens/search_screen.dart';

class CustomAppBar {
  AppBar primaryAppBar({
    required String pageTitle,
    required BuildContext context,
    required VoidCallback onPressSearch,
    required VoidCallback onAscendingSort,
    required VoidCallback onDescendingSort,
    required VoidCallback onTrendingSort,
    required VoidCallback onChannelFilter,
    required VoidCallback onReadFilter,
    required VoidCallback onUnreadFilter,
  }) {
    return AppBar(
      backgroundColor: AppColors.appWhite,
      centerTitle: true,
      title: Text(
        pageTitle,
        style:
            AppStyle.semiBoldText16.copyWith(color: AppColors.darkBlueShade2),
      ),
      actions: [
        GestureDetector(
          onTap: onPressSearch,
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.search_outlined,
              size: 20,
              color: AppColors.darkBlueShade2,
            ),
          ),
        ),
        AppPopUp(
          onAscending: onAscendingSort,
          onDescending: onDescendingSort,
          onTrending: onTrendingSort,
          onChannel: onChannelFilter,
          onRead: onReadFilter,
          onUnread: onUnreadFilter,
        ),
      ],
    );
  }

  AppBar primaryAppBarNoFilter(
      {required String pageTitle, required BuildContext context}) {
    return AppBar(
      centerTitle: true,
      backgroundColor: AppColors.appWhite,
      title: Text(
        pageTitle,
        style:
            AppStyle.semiBoldText16.copyWith(color: AppColors.darkBlueShade2),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(SearchScreen.route);
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 17),
            child: Icon(
              Icons.search_outlined,
              size: 20,
              color: AppColors.darkBlueShade3,
            ),
          ),
        ),
      ],
    );
  }

  AppBar appBarWithBack(
      {required String pageTitle, required BuildContext context}) {
    return AppBar(
      centerTitle: true,
      backgroundColor: AppColors.appWhite,
      title: Text(
        pageTitle,
        style:
            AppStyle.semiBoldText16.copyWith(color: AppColors.darkBlueShade2),
      ),
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: const Icon(
          Icons.chevron_left_outlined,
          color: AppColors.appBlack,
          size: 24,
        ),
      ),
    );
  }

  AppBar appBarWithNoBack(
      {required String pageTitle, required BuildContext context}) {
    return AppBar(
      backgroundColor: AppColors.appWhite,
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.only(left: 24),
        child: Center(
          child: Text(
            pageTitle,
            style: AppStyle.semiBoldText16
                .copyWith(color: AppColors.darkBlueShade2),
          ),
        ),
      ),
    );
  }

  AppBar appBarSearch(
      {required BuildContext context,
      required void Function(String?) onChanged}) {
    return AppBar(
      centerTitle: true,
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
      actions: [
        Flexible(
          flex: 3,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 60, right: 15),
            child: FormBuilderTextField(
              name: "search",
              textAlign: TextAlign.center,
              onChanged: onChanged,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  suffixIcon: const Icon(
                    Icons.search,
                    color: AppColors.greyShade2,
                    size: 20,
                  ),
                  hintText: "Search",
                  hintStyle: AppStyle.lightText12
                      .copyWith(color: AppColors.greyShade1)),
            ),
          ),
        ),
      ],
    );
  }
}
