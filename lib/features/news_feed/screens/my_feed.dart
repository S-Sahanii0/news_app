import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../auth/services/auth_service.dart';
import '../services/news_service.dart';

import '../../../components/app_bar/app_bar.dart';
import '../../../components/app_drawer.dart';
import '../../../components/app_floating_button.dart';
import '../../../config/theme/app_colors.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../bloc/news_bloc.dart';
import '../widgets/news_detail_card.dart';
import 'comments_screen.dart';
import 'single_news_screen.dart';

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
  late final User _currentUser;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _currentUser = FirebaseAuth.instance.currentUser!;
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _newsBloc = BlocProvider.of<NewsBloc>(context)
      ..add(GetFirstNewsListEvent());
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
            if (state is NewsInitial || state is NewsLoading)
              return const AppLoadingIndicator();
            if (state is NewsLoadingSuccess) {
              return ListView.builder(
                controller: _scrollController,
                itemCount: state.newsList.length + 1,
                itemBuilder: (context, index) {
                  return index >= state.newsList.length
                      ? const AppLoadingIndicator()
                      : GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                SingleNewsScreen.route,
                                arguments: state.newsList[index]);
                          },
                          child: NewsDetailCard(
                            channelName: state.newsList[index].channel.channel,
                            newsDescription: state.newsList[index].content,
                            newsTime: state.newsList[index].date,
                            numberOfLikes: "100",
                            numberOfComments: "100",
                            onTapHeart: () {
                              _newsBloc.add(AddToHistory(
                                  newsModel: state.newsList[index],
                                  uid: _currentUser.uid));
                            },
                            onTapComment: () {
                              Navigator.of(context).pushNamed(
                                  CommentScreen.route,
                                  arguments: state.newsList[index]);
                            },
                            onTapBookmark: () {
                              _newsBloc.add(BookMarkNewsEvent(
                                  newsToBookmark: state.newsList[index],
                                  uid: _currentUser.uid));
                            },
                            onTapShare: () {},
                            onTapMenu: () {},
                            // isBookmark:,
                            // _currentUser.bookmarks!.contains(currentNews.id),
                            channelImage:
                                state.newsList[index].channel.channelImage,
                            imageUrl: state.newsList[index].newsImage,
                          ),
                        );
                },
              );
            } else {
              return const Center(child: Text("Error fetching news."));
            }
          }),
          floatingActionButton: AppFloatingActionButton(
            scaffoldKey: _key,
          ),
          drawer: const AppDrawer()),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) _newsBloc.add(GetNextNewsListEvent());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= maxScroll && !_scrollController.position.outOfRange;
  }
}

class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
}
