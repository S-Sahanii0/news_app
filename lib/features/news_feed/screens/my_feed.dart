import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:news_app/components/app_loading.dart';
import 'package:news_app/features/auth/models/user_model.dart';

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
  late final UserModel userData;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _currentUser = FirebaseAuth.instance.currentUser!;
    _authBloc = BlocProvider.of<AuthBloc>(context);
    userData = (_authBloc.state as AuthSuccess).currentUser;
    _newsBloc = BlocProvider.of<NewsBloc>(context)
      ..add(GetFirstNewsListEvent(user: userData));
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
          body: BlocBuilder<AuthBloc, AuthState>(
            buildWhen: (prevState, curState) {
              return curState is NewsInitial;
            },
            builder: (context, authState) {
              var userData = (_authBloc.state as AuthSuccess).currentUser;
              return BlocBuilder<NewsBloc, NewsState>(
                  buildWhen: (current, prev) {
                return current != prev;
              }, builder: (context, state) {
                if (state is NewsInitial || state is NewsLoading)
                  return const AppLoadingIndicator();
                if (state is NewsLoadingSuccess) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.newsList.length + 1,
                    itemBuilder: (context, index) {
                      print(state.newsList[index].likes);
                      return index >= state.newsList.length
                          ? const AppLoadingIndicator()
                          : GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    SingleNewsScreen.route,
                                    arguments: [
                                      index,
                                      state.newsList,
                                      userData
                                    ]);
                              },
                              child: NewsDetailCard(
                                channelName:
                                    state.newsList[index].channel.channel,
                                newsDescription: state.newsList[index].content,
                                newsTime: state.newsList[index].date,
                                numberOfLikes:
                                    state.newsList[index].likes.toString(),
                                numberOfComments: state
                                    .newsList[index].comment!.length
                                    .toString(),
                                onTapHeart: () {
                                  if (userData.history!
                                      .contains(state.newsList[index])) {
                                    _authBloc.add(RemoveFromHistory(
                                        newsModel: state.newsList[index],
                                        user: userData));
                                  } else {
                                    _authBloc.add(AddToHistory(
                                        newsModel: state.newsList[index],
                                        user: userData));
                                    _newsBloc.add(LikeNewsEvent(
                                        likedNews: state.newsList[index]
                                            .copyWith(
                                                likes: state.newsList[index]
                                                        .likes! +
                                                    1)));
                                  }
                                },
                                onTapComment: () {
                                  Navigator.of(context).pushNamed(
                                      CommentScreen.route,
                                      arguments: state.newsList[index]);
                                },
                                onTapBookmark: () {
                                  if (userData.bookmarks!
                                      .contains(state.newsList[index])) {
                                    _authBloc.add(RemoveBookMarkEvent(
                                        newsToBookmark: state.newsList[index],
                                        user: userData));
                                  } else {
                                    _authBloc.add(AddToBookMarkEvent(
                                        newsToBookmark: state.newsList[index],
                                        user: userData));
                                  }
                                },
                                onTapShare: () {},
                                onTapMenu: () {},
                                isBookmark: userData.bookmarks!.any(
                                    (e) => state.newsList[index].id == e.id),
                                isHeart: userData.history!.any(
                                    (e) => state.newsList[index].id == e.id),
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
              });
            },
          ),
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
