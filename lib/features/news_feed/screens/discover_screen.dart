import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:news_app/components/app_loading.dart';
import 'package:news_app/features/news_feed/screens/search_screen.dart';
import 'package:share_plus/share_plus.dart';

import '../../../components/app_bar/app_bar.dart';
import '../../../components/app_drawer.dart';
import '../../../components/app_floating_button.dart';
import '../../../config/theme/app_colors.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../bloc/news_bloc.dart';
import '../widgets/news_detail_card.dart';
import 'comments_screen.dart';
import 'single_news_screen.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);
  static const String route = '/kRouteDiscover';

  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
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
    var userData = (_authBloc.state as AuthSuccess).currentUser;
    return SafeArea(
      child: Scaffold(
          key: _key,
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar().primaryAppBar(
              pageTitle: "Discover",
              context: context,
              onPressSearch: () => Navigator.of(context)
                  .pushNamed(SearchScreen.route, arguments: userData)),
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
                  var newListDiscover = state.newsList..reversed;
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: newListDiscover.length + 1,
                    itemBuilder: (context, index) {
                      print(newListDiscover[index].likes);
                      return index >= newListDiscover.length
                          ? const AppLoadingIndicator()
                          : GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    SingleNewsScreen.route,
                                    arguments: [index, newListDiscover]);
                              },
                              child: NewsDetailCard(
                                channelName:
                                    newListDiscover[index].channel.channel,
                                newsDescription: newListDiscover[index].content,
                                newsTime: newListDiscover[index].date,
                                numberOfLikes:
                                    newListDiscover[index].likes.toString(),
                                numberOfComments: state
                                    .newsList[index].comment!.length
                                    .toString(),
                                onTapHeart: () {
                                  if (userData.history!
                                      .contains(newListDiscover[index])) {
                                    _authBloc.add(RemoveFromHistory(
                                        newsModel: newListDiscover[index],
                                        user: userData));
                                  } else {
                                    _authBloc.add(AddToHistory(
                                        newsModel: newListDiscover[index],
                                        user: userData));
                                    _newsBloc.add(LikeNewsEvent(
                                        likedNews: newListDiscover[index]
                                            .copyWith(
                                                likes: newListDiscover[index]
                                                        .likes! +
                                                    1)));
                                  }
                                },
                                onTapComment: () {
                                  Navigator.of(context).pushNamed(
                                      CommentScreen.route,
                                      arguments: newListDiscover[index]);
                                },
                                onTapBookmark: () {
                                  if (userData.bookmarks!
                                      .contains(newListDiscover[index])) {
                                    _authBloc.add(RemoveBookMarkEvent(
                                        newsToBookmark: newListDiscover[index],
                                        user: userData));
                                  } else {
                                    _authBloc.add(AddToBookMarkEvent(
                                        newsToBookmark: newListDiscover[index],
                                        user: userData));
                                  }
                                },
                                onTapShare: () {
                                  Share.share(
                                      'check out this ${state.newsList[index].url}');
                                },
                                onTapMenu: () {},
                                isBookmark: userData.bookmarks!.any(
                                    (e) => newListDiscover[index].id == e.id),
                                isHeart: userData.history!.any(
                                    (e) => newListDiscover[index].id == e.id),
                                channelImage:
                                    newListDiscover[index].channel.channelImage,
                                imageUrl: newListDiscover[index].newsImage,
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
