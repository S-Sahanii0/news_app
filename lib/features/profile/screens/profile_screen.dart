import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/config/theme/theme.dart';
import 'package:news_app/features/news_feed/screens/my_feed.dart';
import 'package:news_app/features/profile/tabs/bookmark_tab.dart';
import 'package:news_app/features/profile/tabs/history.dart';
import 'package:news_app/features/profile/tabs/settings_tab.dart';
import 'package:news_app/features/profile/widgets/profile_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String route = '/kRouteProfile';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TabController? _tabController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            DefaultTabController(
              length: 3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const ProfileCard(
                      username: "John", profileBio: "Get only what you want"),
                  ColoredBox(
                    color: AppColors.appWhite,
                    child: TabBar(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      overlayColor:
                          MaterialStateProperty.all(AppColors.appWhite),
                      controller: _tabController,
                      indicatorColor: Colors.transparent,
                      unselectedLabelColor: AppColors.greyShade1,
                      labelColor: AppColors.darkBlueShade1,
                      tabs: [
                        Text("Settings", style: AppStyle.mediumText14),
                        Text("Bookmarks", style: AppStyle.mediumText14),
                        Text("History", style: AppStyle.mediumText14),
                      ],
                    ),
                  ),
                  const Expanded(
                    child: TabBarView(
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        Settings(),
                        BookmarkTab(),
                        History(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
