import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/app_loading.dart';
import '../bloc/channel_bloc.dart';
import '../../news_feed/bloc/news_bloc.dart';
import '../../news_feed/screens/comments_screen.dart';
import '../../news_feed/screens/single_news_screen.dart';
import '../../news_feed/widgets/news_detail_card.dart';
import 'package:share_plus/share_plus.dart';

import '../../../components/app_bar/app_bar.dart';
import '../../../components/app_drawer.dart';
import '../../auth/bloc/auth_bloc.dart';

class NewsByChannelScreen extends StatefulWidget {
  final String channelName;
  const NewsByChannelScreen({Key? key, required this.channelName})
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
          body: BlocBuilder<NewsBloc, NewsState>(
            builder: (context, newsState) {
              return BlocBuilder<ChannelBloc, ChannelState>(
                  builder: (context, state) {
                if (state is ChannelInitial || state is ChannelLoading) {
                  return const AppLoadingIndicator();
                }
                if (state is ChannelLoadSuccess) {
                  final newsList = state.news;
                  return newsList.isEmpty
                      ? const Center(
                          child: Text("No news of this channel is available"),
                        )
                      : ListView.builder(
                          itemCount: newsList.length,
                          itemBuilder: (context, index) {
                            print(newsList[index]);
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
                                numberOfLikes:
                                    newsList[index].likes!.toString(),
                                numberOfComments:
                                    newsList[index].comment!.length.toString(),
                                onTapHeart: () {
                                  if (userData.history!.any(
                                      (e) => state.news[index].id == e.id)) {
                                    _authBloc.add(RemoveFromHistory(
                                        newsModel: newsList[index],
                                        user: userData));
                                    _newsBloc.add(UnlikeNewsEvent(
                                        unlikedNews: newsList[index].copyWith(
                                            likes:
                                                newsList[index].likes! - 1)));
                                  } else {
                                    _authBloc.add(AddToHistory(
                                        newsModel: newsList[index],
                                        user: userData));
                                    _newsBloc.add(LikeNewsEvent(
                                        likedNews: newsList[index].copyWith(
                                            likes:
                                                newsList[index].likes! + 1)));
                                  }
                                },
                                onTapComment: () {
                                  Navigator.of(context).pushNamed(
                                      CommentScreen.route,
                                      arguments: newsList[index]);
                                },
                                onTapBookmark: () {
                                  if (userData.bookmarks!
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
                                isBookmark: userData.bookmarks!
                                    .any((e) => newsList[index].id == e.id),
                                isHeart: userData.bookmarks!
                                    .any((e) => newsList[index].id == e.id),
                                channelImage:
                                    newsList[index].channel.channelImage,
                                imageUrl: newsList[index].newsImage,
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
          drawer: const AppDrawer()),
    );
  }
}
