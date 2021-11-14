import 'dart:developer';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:news_app/components/app_bar/app_bar.dart';
import 'package:news_app/components/app_drawer.dart';
import 'package:news_app/components/app_floating_button.dart';
import 'package:news_app/features/auth/bloc/auth_bloc.dart';
import 'package:news_app/features/auth/models/user_model.dart';
import 'package:news_app/features/auth/services/auth_service.dart';
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
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  late final NewsBloc _newsBloc;
  late final AuthBloc _authBloc;
  late final UserModel _currentUser;
  ScrollController controller = ScrollController();
  CustomPopupMenuController _controller = CustomPopupMenuController();

  @override
  void initState() {
    // AuthService().logout();x
    controller.addListener(_scrollListener);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _currentUser = (_authBloc.state as AuthSuccess).currentUser;
    _newsBloc = BlocProvider.of<NewsBloc>(context)
      ..add(GetFirstNewsListEvent());
    super.initState();
  }

  void _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      print("end");
      _newsBloc.add(GetNextNewsListEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    log(_authBloc.state.toString());
    return SafeArea(
      child: Scaffold(
          key: _key,
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar()
              .primaryAppBar(pageTitle: "My Feed", context: context),
          body: BlocBuilder<NewsBloc, NewsState>(builder: (context, state) {
            if (state is NewsInitial) {
              print("Loading");
              return const LinearProgressIndicator();
            }
            if (state is NewsLoading) {
              return const Center(
                child: SizedBox(
                  height: 20,
                  width: 100,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballPulse,
                    colors: [
                      AppColors.yellowShade1,
                      AppColors.yellowShade2,
                    ],
                    strokeWidth: 2,
                  ),
                ),
              );
            }
            if (state is NewsLoadingSuccess) {
              final newsList = state.newsList;

              return ListView.builder(
                controller: controller,
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  final currentNews = newsList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(SingleNewsScreen.route,
                          arguments: currentNews);
                    },
                    child: NewsDetailCard(
                      channelName: currentNews.channel.channel,
                      newsDescription: currentNews.content,
                      newsTime: currentNews.date,
                      numberOfLikes: "100",
                      numberOfComments: "100",
                      onTapHeart: () {
                        _newsBloc.add(AddToHistory(
                            newsModel: currentNews, uid: _currentUser.id!));
                      },
                      onTapComment: () {
                        Navigator.of(context).pushNamed(CommentScreen.route);
                      },
                      onTapBookmark: () {
                        _newsBloc.add(BookMarkNewsEvent(
                            newsToBookmark: currentNews,
                            uid: _currentUser.id!));
                      },
                      onTapShare: () {},
                      onTapMenu: () {},
                      isBookmark:
                          _currentUser.bookmarks!.contains(currentNews.id),
                      channelImage: currentNews.channel.channelImage,
                      imageUrl: currentNews.newsImage,
                    ),
                  );
                },
              );
            } else {
              return Container();
            }
          }),
          floatingActionButton: AppFloatingActionButton(
            scaffoldKey: _key,
          ),
          drawer: const AppDrawer()),
    );
  }
}
