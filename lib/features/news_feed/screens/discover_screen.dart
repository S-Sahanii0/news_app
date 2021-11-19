import 'dart:math';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import '../../../components/app_bar/app_bar.dart';
import '../../../components/app_drawer.dart';
import '../../../components/app_floating_button.dart';
import 'single_news_screen.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_icons.dart';
import '../../../config/theme/app_styles.dart';
import '../widgets/news_detail_card.dart';

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
          appBar: CustomAppBar()
              .primaryAppBar(pageTitle: "Discover", context: context),
          body: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(SingleNewsScreen.route);
            },
            child: NewsDetailCard(
              channelName: "DummyTitle",
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
              channelImage: '',
              imageUrl: '',
            ),
          ),
          floatingActionButton: AppFloatingActionButton(
            scaffoldKey: _key,
          ),
          drawer: const AppDrawer()),
    );
  }
}
