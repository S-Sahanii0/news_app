import 'dart:math';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:news_app/components/app_bar/app_bar.dart';
import 'package:news_app/components/app_drawer.dart';
import 'package:news_app/components/app_floating_button.dart';
import 'package:news_app/features/auth/bloc/auth_bloc.dart';
import 'package:news_app/features/news_feed/bloc/news_bloc.dart';
import 'package:news_app/features/news_feed/screens/comments_screen.dart';
import 'package:news_app/features/news_feed/screens/single_news_screen.dart';
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
  late final NewsBloc _newsBloc;
  CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  void initState() {
    _newsBloc = BlocProvider.of<NewsBloc>(context)..add(GetNewsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _key,
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar()
              .primaryAppBar(pageTitle: "My Feed", context: context),
          body: BlocBuilder<NewsBloc, NewsState>(builder: (context, state) {
            if (state is Loading) {
              return const LinearProgressIndicator();
            }
            if (state is NewsLoadingSuccess) {
              final newsList = state.newsList;
              return ListView.builder(
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  final currentNews = newsList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(SingleNewsScreen.route);
                    },
                    child: NewsDetailCard(
                      channelName: currentNews.channel.channel,
                      newsDescription: currentNews.content,
                      newsTime: currentNews.date,
                      numberOfLikes: "100",
                      numberOfComments: "100",
                      isHeart: isHeart,
                      isBookmark: isBookmark,
                      onTapHeart: () {
                        setState(() {
                          isHeart = !isHeart;
                        });
                      },
                      onTapComment: () {
                        Navigator.of(context).pushNamed(CommentScreen.route);
                      },
                      onTapBookmark: () {
                        setState(() {
                          isBookmark = !isBookmark;
                        });
                      },
                      onTapShare: () {},
                      onTapMenu: () {},
                      channelImage: currentNews.channel.channelImage,
                      imageUrl: currentNews.newsImage,
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text("Something went wrong"),
              );
            }
          }),
          floatingActionButton: AppFloatingActionButton(
            scaffoldKey: _key,
          ),
          drawer: const AppDrawer()),
    );
  }
}
