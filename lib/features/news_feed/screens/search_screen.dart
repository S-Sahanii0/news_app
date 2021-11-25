import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/auth/bloc/auth_bloc.dart';
import 'package:news_app/features/auth/models/user_model.dart';
import 'package:news_app/features/news_feed/bloc/news_bloc.dart';
import 'package:news_app/features/news_feed/widgets/news_detail_card.dart';
import 'package:share_plus/share_plus.dart';

import '../../../components/app_bar/app_bar.dart';
import '../../../config/theme/theme.dart';
import '../bloc/search/search_cubit.dart';
import 'comments_screen.dart';
import 'single_news_screen.dart';

class SearchScreen extends StatefulWidget {
  static const String route = "/kRouteSearch";
  const SearchScreen({Key? key, required this.user}) : super(key: key);

  final UserModel user;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final SearchCubit _searchCubit;
  late final AuthBloc _authBloc;
  late final NewsBloc _newsBloc;
  late final UserModel user;
  @override
  void initState() {
    super.initState();
    _searchCubit = context.read<SearchCubit>();
    _authBloc = context.read<AuthBloc>();
    _newsBloc = context.read<NewsBloc>();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar().appBarSearch(
        context: context,
        onChanged: (query) => _searchCubit.onTextChanged(query ?? ''),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchInitial) {
            return const Center(child: Image(image: AppIcons.searchResult));
          }
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SearchEmpty) {
            return const Center(
                child: Text('No news found containing this query'));
          }
          if (state is SearchLoaded) {
            return ListView.builder(
                itemCount: state.newsList.length,
                itemBuilder: (context, index) {
                  final item = state.newsList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed(SingleNewsScreen.route,
                          arguments: [index, state.newsList, user]);
                    },
                    child: NewsDetailCard(
                      channelImage: item.channel.channelImage,
                      channelName: item.channel.channel,
                      imageUrl: item.newsImage,
                      newsDescription: item.content,
                      newsTime: item.date,
                      numberOfComments: '${item.comment?.length}',
                      numberOfLikes: '${item.likes}',
                      onTapHeart: () {
                        if (user.history!.contains(state.newsList[index])) {
                          _authBloc.add(RemoveFromHistory(
                              newsModel: state.newsList[index], user: user));
                        } else {
                          _authBloc.add(AddToHistory(
                              newsModel: state.newsList[index], user: user));
                          _newsBloc.add(LikeNewsEvent(
                              likedNews: state.newsList[index].copyWith(
                                  likes: state.newsList[index].likes! + 1)));
                        }
                      },
                      onTapComment: () {
                        Navigator.of(context).pushNamed(CommentScreen.route,
                            arguments: state.newsList[index]);
                      },
                      onTapBookmark: () {
                        if (user.bookmarks!.contains(state.newsList[index])) {
                          _authBloc.add(RemoveBookMarkEvent(
                              newsToBookmark: state.newsList[index],
                              user: user));
                        } else {
                          _authBloc.add(AddToBookMarkEvent(
                              newsToBookmark: state.newsList[index],
                              user: user));
                        }
                      },
                      onTapShare: () {
                        Share.share(
                            'check out this ${state.newsList[index].url}');
                      },
                      onTapMenu: () {},
                      isBookmark: user.bookmarks!
                          .any((e) => state.newsList[index].id == e.id),
                      isHeart: user.history!
                          .any((e) => state.newsList[index].id == e.id),
                    ),
                  );
                });
          } else {
            return const Center(child: Text("Error when searching."));
          }
        },
      ),
    );
  }
}
