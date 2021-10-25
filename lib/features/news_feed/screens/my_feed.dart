import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/config/theme/app_colors.dart';
import 'package:news_app/config/theme/app_icons.dart';
import 'package:news_app/config/theme/app_styles.dart';
import 'package:news_app/features/news_feed/screens/widgets/news_detail_card.dart';

class MyFeedScreen extends StatefulWidget {
  const MyFeedScreen({Key? key}) : super(key: key);
  static const String route = '/kRouteFeed';

  @override
  _MyFeedScreenState createState() => _MyFeedScreenState();
}

class _MyFeedScreenState extends State<MyFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: AppColors.appWhite,
          title: Center(
            child: Text(
              "My feed",
              style: AppStyle.semiBoldText16
                  .copyWith(color: AppColors.darkBlueShade2),
            ),
          ),
          actions: const [
            Icon(
              Icons.search_outlined,
              size: 20,
              color: AppColors.darkBlueShade3,
            ),
            Image(image: AppIcons.filter)
          ],
        ),
        body: NewsDetailCard(
            newsTitle: "DummyTitle",
            newsDescription:
                "Lorem LORem Lorem Lorem Lorem Lorem Lorem Lorem Lorem",
            newsTime: "6 hours ago",
            numberOfLikes: "100",
            numberOfComments: "100",
            onTapHeart: () {},
            onTapComment: () {},
            onTapBookmark: () {},
            onTapShare: () {},
            onTapMenu: () {}));
  }
}
