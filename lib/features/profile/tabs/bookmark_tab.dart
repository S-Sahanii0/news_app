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

class BookmarkTab extends StatefulWidget {
  const BookmarkTab({
    Key? key,
  }) : super(key: key);

  @override
  State<BookmarkTab> createState() => _BookmarkTabState();
}

class _BookmarkTabState extends State<BookmarkTab> {
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
          final bookmarks = state.currentUser?.bookmarks ?? [];
          return bookmarks.isEmpty
              ? const Center(
                  child: Text("You dont have any bookmarks"),
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
                  itemCount: bookmarks.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(SingleNewsScreen.route,
                            arguments: [index, bookmarks, state.currentUser]);
                      },
                      child: NewsDetailCard(
                        channelName: bookmarks[index].channel.channel,
                        newsDescription: bookmarks[index].content,
                        newsTime: bookmarks[index].date,
                        numberOfLikes: bookmarks[index].likes.toString(),
                        numberOfComments:
                            bookmarks[index].comment!.length.toString(),
                        onTapHeart: () {
                          if (state.currentUser!.history!
                              .contains(bookmarks[index])) {
                            _authBloc.add(RemoveFromHistory(
                                newsModel: bookmarks[index],
                                user: state.currentUser!));
                            _newsBloc.add(UnlikeNewsEvent(
                                unlikedNews: bookmarks[index].copyWith(
                                    likes: bookmarks[index].likes! - 1)));
                          } else {
                            _authBloc.add(AddToHistory(
                                newsModel: bookmarks[index],
                                user: state.currentUser!));
                            _newsBloc.add(LikeNewsEvent(
                                likedNews: bookmarks[index].copyWith(
                                    likes: bookmarks[index].likes! + 1)));
                          }
                        },
                        onTapComment: () {
                          Navigator.of(context).pushNamed(CommentScreen.route,
                              arguments: bookmarks[index]);
                        },
                        onTapBookmark: () {
                          if (state.currentUser!.bookmarks!
                              .contains(bookmarks[index])) {
                            _authBloc.add(RemoveBookMarkEvent(
                                newsToBookmark: bookmarks[index],
                                user: state.currentUser!));
                          } else {
                            _authBloc.add(AddToBookMarkEvent(
                                newsToBookmark: bookmarks[index],
                                user: state.currentUser!));
                          }
                        },
                        onTapShare: () {
                          Share.share('check out this ${bookmarks[index].url}');
                        },
                        isBookmark: state.currentUser == null
                            ? false
                            : state.currentUser!.bookmarks!.any(
                                (element) => element.id == bookmarks[index].id),
                        isHeart: state.currentUser == null
                            ? false
                            : state.currentUser!.history!.any(
                                (element) => element.id == bookmarks[index].id),
                        onTapMenu: () {},
                        channelImage: bookmarks[index].channel.channelImage,
                        imageUrl: bookmarks[index].newsImage,
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
