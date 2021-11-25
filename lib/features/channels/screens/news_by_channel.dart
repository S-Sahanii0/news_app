import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:news_app/components/app_loading.dart';
import 'package:news_app/features/auth/models/user_model.dart';
import 'package:news_app/features/categories/bloc/category_bloc.dart';
import 'package:news_app/features/channels/bloc/channel_bloc.dart';
import 'package:news_app/features/news_feed/bloc/news_bloc.dart';
import 'package:news_app/features/news_feed/screens/comments_screen.dart';
import 'package:news_app/features/news_feed/screens/single_news_screen.dart';
import 'package:news_app/features/news_feed/widgets/news_detail_card.dart';
import 'package:share_plus/share_plus.dart';

import '../../../components/app_bar/app_bar.dart';
import '../../../components/app_drawer.dart';
import '../../../components/app_floating_button.dart';
import '../../../config/theme/app_colors.dart';
import '../../auth/bloc/auth_bloc.dart';

class NewsByChannelScreen extends StatefulWidget {
  final UserModel userData;
  final String channelName;
  const NewsByChannelScreen(
      {Key? key, required this.userData, required this.channelName})
      : super(key: key);
  static const String route = '/kRouteNewsByChannel';

  @override
  _NewsByChannelScreenState createState() => _NewsByChannelScreenState();
}

class _NewsByChannelScreenState extends State<NewsByChannelScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  late final NewsBloc _newsBloc;
  late final AuthBloc _authBloc;
  late final ChannelBloc _channelBloc;
  late final User _currentUser;

  @override
  void initState() {
    super.initState();
    _channelBloc = BlocProvider.of<ChannelBloc>(context)
      ..add(GetNewsByChannelEvent(channelName: widget.channelName));
    _currentUser = FirebaseAuth.instance.currentUser!;
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _newsBloc = BlocProvider.of<NewsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    var userData = (_authBloc.state as AuthSuccess).currentUser;
    return SafeArea(
      child: Scaffold(
          key: _key,
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar()
              .appBarWithBack(pageTitle: "Interest", context: context),
          body: BlocBuilder<ChannelBloc, ChannelState>(
              buildWhen: (current, prev) {
            return current != prev;
          }, builder: (context, state) {
            if (state is ChannelInitial || state is ChannelLoading)
              return const AppLoadingIndicator();
            if (state is ChannelLoadSuccess) {
              final newsList = state.news;
              return newsList.isEmpty
                  ? const Center(
                      child: Text("No news of this channel is available"),
                    )
                  : ListView.builder(
                      itemCount: newsList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                SingleNewsScreen.route,
                                arguments: newsList[index]);
                          },
                          child: NewsDetailCard(
                            channelName: newsList[index].channel.channel,
                            newsDescription: newsList[index].content,
                            newsTime: newsList[index].date,
                            numberOfLikes: "100",
                            numberOfComments: "100",
                            onTapHeart: () {
                              if (widget.userData.history!
                                  .contains(newsList[index])) {
                                _authBloc.add(RemoveFromHistory(
                                    newsModel: newsList[index],
                                    user: userData));
                              } else {
                                _authBloc.add(AddToHistory(
                                    newsModel: newsList[index],
                                    user: userData));
                              }
                            },
                            onTapComment: () {
                              Navigator.of(context).pushNamed(
                                  CommentScreen.route,
                                  arguments: newsList[index]);
                            },
                            onTapBookmark: () {
                              if (widget.userData.bookmarks!
                                  .contains(newsList[index])) {
                                _authBloc.add(RemoveBookMarkEvent(
                                    newsToBookmark: newsList[index],
                                    user: userData));
                              } else {
                                _authBloc.add(AddToBookMarkEvent(
                                    newsToBookmark: newsList[index],
                                    user: userData));
                              }
                            },
                            onTapShare: () {
                              Share.share(
                                  'check out this ${newsList[index].url}');
                            },
                            onTapMenu: () {},
                            isBookmark: widget.userData.bookmarks!
                                .contains(newsList[index]),
                            isHeart: widget.userData.history!
                                .contains(newsList[index]),
                            channelImage: newsList[index].channel.channelImage,
                            imageUrl: newsList[index].newsImage,
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
}
