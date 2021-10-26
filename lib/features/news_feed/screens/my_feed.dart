import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/app_drawer.dart';
import 'package:news_app/config/theme/app_colors.dart';
import 'package:news_app/config/theme/app_icons.dart';
import 'package:news_app/config/theme/app_styles.dart';
import 'package:news_app/features/news_feed/widgets/news_detail_card.dart';

class MyFeedScreen extends StatefulWidget {
  const MyFeedScreen({Key? key}) : super(key: key);
  static const String route = '/kRouteFeed';

  @override
  _MyFeedScreenState createState() => _MyFeedScreenState();
}

class _MyFeedScreenState extends State<MyFeedScreen> {
  bool isHeart = false;
  bool isBookmark = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
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
          actions: [
            Icon(
              Icons.search_outlined,
              size: 20,
              color: AppColors.darkBlueShade3,
            ),
            PopupMenuButton(
                child: Image(
                  image: AppIcons.filter,
                ),
                itemBuilder: (context) {
                  return List.generate(5, (index) {
                    return PopupMenuItem(
                      padding: EdgeInsets.all(15),
                      child: Text('button no $index'),
                    );
                  });
                })
          ],
        ),
        body: NewsDetailCard(
          newsTitle: "DummyTitle",
          newsDescription:
              "Lorem LORem Lorem Lorem Lorem Lorem Lorem Lorem Lorem",
          newsTime: "6 hours ago",
          numberOfLikes: "100",
          numberOfComments: "100",
          isHeart: isHeart,
          isBookmark: isBookmark,
          onTapHeart: () {
            setState(() {
              isHeart = !isHeart;
            });
          },
          onTapComment: () {},
          onTapBookmark: () {
            setState(() {
              isBookmark = !isBookmark;
            });
          },
          onTapShare: () {},
          onTapMenu: () {},
        ),
        floatingActionButton: InkWell(
          onTap: () {
            _key.currentState!.openDrawer();
          },
          child: const Image(
            image: AppIcons.floating,
          ),
        ),
        drawer: const AppDrawer());
  }
}