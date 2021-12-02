import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/features/auth/bloc/auth_bloc.dart';
import 'package:news_app/features/auth/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/features/news_feed/bloc/news_bloc.dart';
import 'package:news_app/features/news_feed/bloc/tts/tts_cubit.dart';
import '../../../components/app_bar/app_bar.dart';
import '../../../config/theme/app_icons.dart';
import '../../../config/theme/theme.dart';
import '../model/news_model.dart';
import '../widgets/news_detail_bottom_sheet.dart';
import 'comments_screen.dart';

class SingleNewsScreen extends StatefulWidget {
  const SingleNewsScreen(
      {Key? key,
      required this.newsList,
      required this.currentNewsIndex,
      required this.user})
      : super(key: key);
  final List<News> newsList;
  final int currentNewsIndex;
  final UserModel user;
  static const String route = '/kRouteSingleNewsScreen';

  @override
  _SingleNewsScreenState createState() => _SingleNewsScreenState();
}

class _SingleNewsScreenState extends State<SingleNewsScreen> {
  late final TtsCubit _ttsCubit;
  late final NewsBloc _newsBloc;
  late final AuthBloc _authBloc;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    _newsBloc = BlocProvider.of<NewsBloc>(context);
    _ttsCubit = context.read<TtsCubit>();
    if (_ttsCubit.state.shouldAutoPlay) {
      _ttsCubit.handlePlay(widget.newsList[widget.currentNewsIndex].content);
    }
    _authBloc = BlocProvider.of<AuthBloc>(context);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _ttsCubit.state.pageController.jumpToPage(widget.currentNewsIndex);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didUpdateWidget');
  }

  @override
  void didUpdateWidget(covariant SingleNewsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget');
  }

  @override
  void dispose() {
    _ttsCubit.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var news = (_newsBloc.state as NewsLoadingSuccess).newsList;
    return SafeArea(
      child: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, newsState) {
          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              return BlocBuilder<TtsCubit, TtsState>(
                builder: (context, state) {
                  final _shouldPlay = _ttsCubit.state.shouldAutoPlay;

                  print('new state : ${state.hashCode}');
                  return PageView.builder(
                      onPageChanged: (_) {
                        if (!_shouldPlay) _ttsCubit.stop();
                      },
                      controller: state.pageController,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        final _news = news[index];
                        if (_shouldPlay) _ttsCubit.handlePlay(_news.content);
                        return Scaffold(
                          appBar: CustomAppBar()
                              .appBarWithBack(context: context, pageTitle: ""),
                          bottomSheet: NewsDetailBottomSheet(
                            onPlay: (isPlaying) => isPlaying
                                ? _ttsCubit.stop()
                                : _ttsCubit.handlePlay(_news.content),
                            shouldPlay: _shouldPlay,
                          ),
                          body: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 15),
                            child: ListView(
                              shrinkWrap: true,
                              physics: isExpanded
                                  ? ScrollPhysics()
                                  : const NeverScrollableScrollPhysics(),
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: AppColors.yellowShade2,
                                      radius: 15,
                                      child: Image(
                                        fit: BoxFit.contain,
                                        image: NetworkImage(
                                            _news.channel.channelImage),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Text(
                                        _news.channel.channel,
                                        style: AppStyle.regularText14.copyWith(
                                            color: AppColors.darkBlueShade2),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(_news.newsImage),
                                        fit: BoxFit.cover,
                                      ),
                                      border: Border.all(
                                        width: 2,
                                        color: AppColors.yellowShade4,
                                        style: BorderStyle.solid,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    _news.title,
                                    style: AppStyle.regularText14.copyWith(
                                        color: AppColors.darkBlueShade3),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                  ),
                                ),
                                Text(
                                  _news.content,
                                  style: AppStyle.regularText18.copyWith(
                                      color: AppColors.darkBlueShade1),
                                  overflow:
                                      isExpanded ? null : TextOverflow.ellipsis,
                                  maxLines: isExpanded ? null : 4,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () => setState(() {
                                          isExpanded = !isExpanded;
                                        }),
                                        child: Text(
                                          isExpanded
                                              ? "Read less"
                                              : "Read more",
                                          style: AppStyle.semiBoldText12
                                              .copyWith(
                                                  color:
                                                      AppColors.darkBlueShade2),
                                        ),
                                      ),
                                      const Spacer(
                                        flex: 6,
                                      ),
                                      Text(
                                        _news.date,
                                        style: AppStyle.regularText12.copyWith(
                                            color: AppColors.darkBlueShade2),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  thickness: 2,
                                ),
                                Flexible(
                                  flex: 4,
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (widget.user.history!
                                              .contains(_news)) {
                                            _authBloc.add(RemoveFromHistory(
                                                newsModel: _news,
                                                user: widget.user));
                                          } else {
                                            _authBloc.add(AddToHistory(
                                                newsModel: _news,
                                                user: widget.user));
                                            _newsBloc.add(LikeNewsEvent(
                                                likedNews: _news.copyWith(
                                                    likes: _news.likes! + 1)));
                                          }
                                        },
                                        child: Image(
                                            image: (authState as AuthSuccess)
                                                    .currentUser
                                                    .history!
                                                    .any((element) =>
                                                        element == _news)
                                                ? AppIcons.heartTapped
                                                : AppIcons.heart),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text(
                                          (newsState as NewsLoadingSuccess)
                                              .newsList
                                              .where((element) =>
                                                  element.id == _news.id)
                                              .first
                                              .likes
                                              .toString(),
                                          style: AppStyle.regularText12
                                              .copyWith(
                                                  color: AppColors.greyShade2),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4.w,
                                      ),
                                      InkWell(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                CommentScreen.route,
                                                arguments: (newsState
                                                        as NewsLoadingSuccess)
                                                    .newsList
                                                    .where((element) =>
                                                        element.id == _news.id)
                                                    .first);
                                          },
                                          child: const Image(
                                              image: AppIcons.comment)),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        child: Text(
                                          _news.comment!.length.toString(),
                                          style: AppStyle.regularText12
                                              .copyWith(
                                                  color: AppColors.greyShade2),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: isExpanded ? 80.h : 20.h,
                                )
                              ],
                            ),
                          ),
                        );
                      });
                },
              );
            },
          );
        },
      ),
    );
  }
}
