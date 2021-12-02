import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/components/app_loading.dart';
import 'package:news_app/config/theme/app_colors.dart';
import 'package:news_app/features/news_feed/bloc/news_bloc.dart';
import 'package:news_app/features/news_feed/screens/comments_screen.dart';
import 'package:news_app/features/news_feed/screens/single_news_screen.dart';
import 'package:share_plus/share_plus.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../../news_feed/model/news_model.dart';
import '../../news_feed/widgets/news_detail_card.dart';

class History extends StatefulWidget {
  const History({
    Key? key,
  }) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late final AuthBloc _authBloc;
  late final NewsBloc _newsBloc;

  @override
  void initState() {
    super.initState();
    _authBloc = BlocProvider.of<AuthBloc>(context);
    _newsBloc = BlocProvider.of<NewsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return const AppLoadingIndicator();
        }
        if (state is AuthSuccess) {
          final history = state.currentUser?.history ?? [];
          return history.isEmpty
              ? const Center(
                  child: Text("You dont have any history"),
                )
              : ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return const ColoredBox(
                        color: AppColors.appWhite,
                        child: Divider(
                          thickness: 1.5,
                          height: 14,
                        ));
                  },
                  itemCount: history.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(SingleNewsScreen.route,
                            arguments: [index, history, state.currentUser]);
                      },
                      child: NewsDetailCard(
                        channelName: history[index].channel.channel,
                        newsDescription: history[index].content,
                        newsTime: history[index].date,
                        numberOfLikes: history[index].likes.toString(),
                        numberOfComments:
                            history[index].comment!.length.toString(),
                        onTapHeart: () {
                          if (state.currentUser!.history!
                              .contains(history[index])) {
                            _authBloc.add(RemoveFromHistory(
                                newsModel: history[index],
                                user: state.currentUser!));
                            _newsBloc.add(UnlikeNewsEvent(
                                unlikedNews: history[index].copyWith(
                                    likes: history[index].likes! - 1)));
                          } else {
                            _authBloc.add(AddToHistory(
                                newsModel: history[index],
                                user: state.currentUser!));
                            _newsBloc.add(LikeNewsEvent(
                                likedNews: history[index].copyWith(
                                    likes: history[index].likes! + 1)));
                          }
                        },
                        onTapComment: () {
                          Navigator.of(context).pushNamed(CommentScreen.route,
                              arguments: history[index]);
                        },
                        onTapBookmark: () {
                          if (state.currentUser!.history!
                              .contains(history[index])) {
                            _authBloc.add(RemoveBookMarkEvent(
                                newsToBookmark: history[index],
                                user: state.currentUser!));
                          } else {
                            _authBloc.add(AddToBookMarkEvent(
                                newsToBookmark: history[index],
                                user: state.currentUser!));
                          }
                        },
                        onTapShare: () {
                          Share.share('check out this ${history[index].url}');
                        },
                        isBookmark: state.currentUser == null
                            ? false
                            : state.currentUser!.bookmarks!.any(
                                (element) => element.id == history[index].id),
                        isHeart: state.currentUser == null
                            ? false
                            : state.currentUser!.history!.any(
                                (element) => element.id == history[index].id),
                        onTapMenu: () {},
                        channelImage: history[index].channel.channelImage,
                        imageUrl: history[index].newsImage,
                      ),
                    );
                  },
                );
        } else {
          return Center(
            child: Text("Oops something went wrong"),
          );
        }
      },
    );
  }
}
