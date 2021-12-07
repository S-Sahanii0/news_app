import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/components/app_loading.dart';
import 'package:news_app/components/buttons/app_outlined_button.dart';
import 'package:news_app/config/theme/app_colors.dart';
import 'package:news_app/config/theme/app_styles.dart';
import 'package:news_app/features/auth/models/user_model.dart';
import 'package:news_app/features/auth/screens/login_screen.dart';
import 'package:news_app/features/news_feed/bloc/filter/cubit/filter_cubit.dart';
import 'package:news_app/features/news_feed/screens/search_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/app_bar/app_bar.dart';
import '../../../components/app_drawer.dart';
import '../../../components/app_floating_button.dart';
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
  late final FilterCubit _filterBloc;
  late final AuthBloc _authBloc;
  late final UserModel? userData;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    userData = (_authBloc.state as AuthSuccess).currentUser;
    _newsBloc = BlocProvider.of<NewsBloc>(context)
      ..add(GetFirstNewsListEvent(user: userData));
    _filterBloc = context.read();
  }

  @override
  Widget build(BuildContext context) {
    log(_authBloc.state.toString());
    return SafeArea(
      child: Scaffold(
        key: _key,
        resizeToAvoidBottomInset: true,
        appBar: CustomAppBar().primaryAppBar(
          pageTitle: "My Feed",
          context: context,
          onPressSearch: () =>
              Navigator.of(context).pushNamed(SearchScreen.route, arguments: userData),
          onAscendingSort: () => _newsBloc.add(const SortNewsEvent(isAscending: true)),
          onDescendingSort: () => _newsBloc.add(const SortNewsEvent(isAscending: false)),
          onTrendingSort: () => _newsBloc.add(const GetFirstNewsListEvent()),
          onUnreadFilter: () {
            if (userData != null) {
              final allNews = (_newsBloc.state as NewsLoadingSuccess).newsList;
              _filterBloc.applyFilter(
                  allNews, FilterType.unread, userData!.history ?? []);
            } else {
              showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  useRootNavigator: false,
                  isDismissible: true,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r),
                  )),
                  builder: (_) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: AppColors.appWhite,
                      ),
                      constraints: BoxConstraints(maxHeight: 170.h),
                      margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 25.h),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: InkWell(
                              onTap: () =>
                                  Navigator.of(context).pushNamed(LoginScreen.route),
                              child: Text(
                                'Login to Continue',
                                style: AppStyle.semiBoldText16
                                    .copyWith(color: AppColors.darkBlueShade2),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 28.w, vertical: 20.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                AppOutlinedButton(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    buttonText: "Continue Browsing")
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
          },
          onReadFilter: () {
            if (userData != null) {
              final allNews = (_newsBloc.state as NewsLoadingSuccess).newsList;
              _filterBloc.applyFilter(allNews, FilterType.read, userData!.history ?? []);
            } else {
              showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  useRootNavigator: false,
                  isDismissible: true,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r),
                  )),
                  builder: (_) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: AppColors.appWhite,
                      ),
                      constraints: BoxConstraints(maxHeight: 170.h),
                      margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 25.h),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: InkWell(
                              onTap: () =>
                                  Navigator.of(context).pushNamed(LoginScreen.route),
                              child: Text(
                                'Login to Continue',
                                style: AppStyle.semiBoldText16
                                    .copyWith(color: AppColors.darkBlueShade2),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 28.w, vertical: 20.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                AppOutlinedButton(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    buttonText: "Continue Browsing")
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
          },
          onChannelFilter: () {
            if (userData != null) {
              final allNews = (_newsBloc.state as NewsLoadingSuccess).newsList;
              _filterBloc.applyFilter(allNews, FilterType.all, userData!.history ?? []);
            } else {
              showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  useRootNavigator: false,
                  isDismissible: true,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    topRight: Radius.circular(10.r),
                  )),
                  builder: (_) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color: AppColors.appWhite,
                      ),
                      constraints: BoxConstraints(maxHeight: 170.h),
                      margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 25.h),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: InkWell(
                              onTap: () =>
                                  Navigator.of(context).pushNamed(LoginScreen.route),
                              child: Text(
                                'Login to Continue',
                                style: AppStyle.semiBoldText16
                                    .copyWith(color: AppColors.darkBlueShade2),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: 28.w, vertical: 20.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                AppOutlinedButton(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    buttonText: "Continue Browsing")
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
            }
          },
        ),
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            var userData = (_authBloc.state as AuthSuccess).currentUser;
            return BlocBuilder<FilterCubit, FilterState>(buildWhen: (current, prev) {
              return current != prev;
            }, builder: (context, state) {
              print('FILTER STATE $state');
              if (state is FilterInitailState || state is FilterLoadInProgress) {
                return const AppLoadingIndicator();
              }
              if (state is FilterLoadSuccess) {
                return state.news.isEmpty
                    ? const Center(child: Text('Could not find any news.'))
                    : ListView.separated(
                        controller: _scrollController,
                        itemCount: state.news.length + 1,
                        itemBuilder: (context, index) {
                          return (index >= state.news.length)
                              ? state.hasReachedMax
                                  ? const AppLoadingIndicator()
                                  : const SizedBox()
                              : GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        SingleNewsScreen.route,
                                        arguments: [index, state.news, userData]);
                                  },
                                  child: NewsDetailCard(
                                    channelName: state.news[index].channel.channel,
                                    newsDescription: state.news[index].content,
                                    newsTime: state.news[index].date,
                                    numberOfLikes: state.news[index].likes.toString(),
                                    numberOfComments:
                                        state.news[index].comment!.length.toString(),
                                    onTapHeart: () {
                                      if (userData != null) {
                                        if (userData.history!
                                            .any((e) => state.news[index].id == e.id)) {
                                          _authBloc.add(RemoveFromHistory(
                                              newsModel: state.news[index],
                                              user: userData.copyWith(
                                                  history: userData.history!
                                                    ..remove(state.news[index]))));
                                          _newsBloc.add(UnlikeNewsEvent(
                                              unlikedNews: state.news[index].copyWith(
                                                  likes: state.news[index].likes! - 1)));
                                        } else {
                                          _authBloc.add(AddToHistory(
                                              newsModel: state.news[index],
                                              user: userData.copyWith(
                                                  history: userData.history!
                                                    ..add(state.news[index]))));
                                          _newsBloc.add(LikeNewsEvent(
                                              likedNews: state.news[index].copyWith(
                                                  likes: state.news[index].likes! + 1)));
                                        }
                                      } else {
                                        showModalBottomSheet(
                                            context: context,
                                            backgroundColor: Colors.transparent,
                                            useRootNavigator: false,
                                            isDismissible: true,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.r),
                                              topRight: Radius.circular(10.r),
                                            )),
                                            builder: (_) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10.r),
                                                  color: AppColors.appWhite,
                                                ),
                                                constraints:
                                                    BoxConstraints(maxHeight: 170.h),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 18.w, vertical: 25.h),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: 20.h),
                                                      child: InkWell(
                                                        onTap: () => Navigator.of(context)
                                                            .pushNamed(LoginScreen.route),
                                                        child: Text(
                                                          'Login to Continue',
                                                          style: AppStyle.semiBoldText16
                                                              .copyWith(
                                                                  color: AppColors
                                                                      .darkBlueShade2),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 28.w,
                                                          vertical: 20.h),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.spaceAround,
                                                        children: [
                                                          AppOutlinedButton(
                                                              onTap: () {
                                                                Navigator.of(context)
                                                                    .pop();
                                                              },
                                                              buttonText:
                                                                  "Continue Browsing")
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      }
                                    },
                                    onTapComment: () {
                                      Navigator.of(context).pushNamed(CommentScreen.route,
                                          arguments: state.news[index]);
                                    },
                                    onTapBookmark: () {
                                      if (userData != null) {
                                        if (userData.bookmarks!
                                            .contains(state.news[index])) {
                                          _authBloc.add(RemoveBookMarkEvent(
                                              newsToBookmark: state.news[index],
                                              user: userData));
                                        } else {
                                          _authBloc.add(AddToBookMarkEvent(
                                              newsToBookmark: state.news[index],
                                              user: userData));
                                        }
                                      } else {
                                        showModalBottomSheet(
                                            context: context,
                                            backgroundColor: Colors.transparent,
                                            useRootNavigator: false,
                                            isDismissible: true,
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.r),
                                              topRight: Radius.circular(10.r),
                                            )),
                                            builder: (_) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10.r),
                                                  color: AppColors.appWhite,
                                                ),
                                                constraints:
                                                    BoxConstraints(maxHeight: 170.h),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 18.w, vertical: 25.h),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          vertical: 20.h),
                                                      child: InkWell(
                                                        onTap: () => Navigator.of(context)
                                                            .pushNamed(LoginScreen.route),
                                                        child: Text(
                                                          'Login to Continue',
                                                          style: AppStyle.semiBoldText16
                                                              .copyWith(
                                                                  color: AppColors
                                                                      .darkBlueShade2),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(
                                                          horizontal: 28.w,
                                                          vertical: 20.h),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.spaceAround,
                                                        children: [
                                                          AppOutlinedButton(
                                                              onTap: () {
                                                                Navigator.of(context)
                                                                    .pop();
                                                              },
                                                              buttonText:
                                                                  "Continue Browsing")
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      }
                                    },
                                    onTapShare: () {
                                      Share.share(
                                          'check out this ${state.news[index].url}');
                                    },
                                    onTapMenu: () {
                                      Navigator.of(context).pushNamed(
                                          SingleNewsScreen.route,
                                          arguments: [index, state.news, userData]);
                                    },
                                    isBookmark: userData == null
                                        ? false
                                        : userData.bookmarks!
                                            .any((e) => state.news[index].id == e.id),
                                    isHeart: userData == null
                                        ? false
                                        : userData.history!
                                            .any((e) => state.news[index].id == e.id),
                                    channelImage: state.news[index].channel.channelImage,
                                    imageUrl: state.news[index].newsImage,
                                  ),
                                );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const ColoredBox(
                              color: AppColors.appWhite,
                              child: Divider(
                                thickness: 1.5,
                                height: 14,
                              ));
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
        endDrawer: const AppDrawer(),
      ),
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
