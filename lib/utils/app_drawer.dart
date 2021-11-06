import 'package:flutter/material.dart';
import 'package:news_app/features/categories/screens/category_screen.dart';
import 'package:news_app/features/categories/screens/choose_category_screen.dart';
import 'package:news_app/features/channels/screens/channels_screen.dart';
import 'package:news_app/features/news_feed/screens/discover_screen.dart';
import 'package:news_app/features/news_feed/screens/my_feed.dart';
import 'package:news_app/features/profile/screens/profile_screen.dart';

import '../config/theme/theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        // Set the transparency here
        canvasColor: Colors
            .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
      ),
      child: Drawer(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            color: AppColors.blueShade2,
          ),
          child: Column(
            // Important: Remove any padding from the ListView.
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DrawerHeader(
                child: Center(
                    child: Text(
                  '"Health Quote"',
                  style: AppStyle.regularText18,
                )),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(MyFeedScreen.route);
                  },
                  child: Text(
                    "My Feed",
                    style: AppStyle.mediumText20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(ChooseCategoryScreen.route);
                  },
                  child: Text(
                    "Discover",
                    style: AppStyle.mediumText20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(CategoryScreen.route);
                  },
                  child: Text(
                    "Categories",
                    style: AppStyle.mediumText20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(ChannelScreen.route);
                  },
                  child: Text(
                    "Channels",
                    style: AppStyle.mediumText20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(ProfileScreen.route);
                  },
                  child: Text(
                    "Profile",
                    style: AppStyle.mediumText20,
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Row(children: [
                  Icon(Icons.close),
                  Spacer(),
                  Text("Login/SignUp", style: AppStyle.regularText14)
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
