import 'dart:math';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:news_app/components/app_bar/app_bar.dart';
import 'package:news_app/features/news_feed/screens/single_news_screen.dart';
import 'package:news_app/utils/app_drawer.dart';
import 'package:news_app/config/theme/app_colors.dart';
import 'package:news_app/config/theme/app_icons.dart';
import 'package:news_app/config/theme/app_styles.dart';
import 'package:news_app/features/news_feed/widgets/news_detail_card.dart';
import 'package:news_app/utils/app_popup.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);
  static const String route = '/kRouteDiscover';

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  bool isHeart = false;
  bool isBookmark = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _key,
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar().primaryAppBar(pageTitle: "Discover"),
          body: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(SingleNewsScreen.route);
            },
            child: NewsDetailCard(
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
          ),
          floatingActionButton: InkWell(
            onTap: () {
              _key.currentState!.openDrawer();
            },
            child: const Image(
              image: AppIcons.floating,
            ),
          ),
          drawer: const AppDrawer()),
    );
  }
}