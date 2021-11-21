import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:news_app/features/auth/models/user_model.dart';
import 'package:news_app/features/categories/bloc/category_bloc.dart';
import 'package:news_app/features/channels/bloc/channel_bloc.dart';
import 'package:news_app/features/news_feed/bloc/news_bloc.dart';
import 'package:news_app/features/news_feed/screens/comments_screen.dart';
import 'package:news_app/features/news_feed/screens/single_news_screen.dart';
import 'package:news_app/features/news_feed/widgets/news_detail_card.dart';

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

  late final ChannelBloc _channelBloc;
  late final User _currentUser;

  @override
  void initState() {
    super.initState();
    _channelBloc = BlocProvider.of<ChannelBloc>(context)
      ..add(GetNewsByChannelEvent(channelName: widget.channelName));
    _currentUser = FirebaseAuth.instance.currentUser!;
    _newsBloc = BlocProvider.of<NewsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
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
            if (state is NewsByChannel) {
              final newsList = state.newsList;
              return newsList.isEmpty
                  ? const Center(
                      child: Text("No news of this category available"),
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
                                _newsBloc.add(RemoveFromHistory(
                                    newsModel: newsList[index],
                                    uid: _currentUser.uid));
                              } else {
                                _newsBloc.add(AddToHistory(
                                    newsModel: newsList[index],
                                    uid: _currentUser.uid));
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
                                _newsBloc.add(RemoveBookMarkNewsEvent(
                                    newsToBookmark: newsList[index],
                                    uid: _currentUser.uid));
                              } else {
                                _newsBloc.add(BookMarkNewsEvent(
                                    newsToBookmark: newsList[index],
                                    uid: _currentUser.uid));
                              }
                            },
                            onTapShare: () {},
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
