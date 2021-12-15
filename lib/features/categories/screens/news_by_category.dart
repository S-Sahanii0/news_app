import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/components/buttons/app_outlined_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/config/theme/app_styles.dart';
import 'package:news_app/features/auth/screens/login_screen.dart';
import 'package:share_plus/share_plus.dart';

import '../../../components/app_bar/app_bar.dart';
import '../../../components/app_drawer.dart';
import '../../../components/app_loading.dart';
import '../../../config/theme/app_colors.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/models/user_model.dart';
import '../../news_feed/bloc/news_bloc.dart';
import '../../news_feed/screens/comments_screen.dart';
import '../../news_feed/screens/single_news_screen.dart';
import '../../news_feed/widgets/news_detail_card.dart';
import '../bloc/category_bloc.dart';
import '../models/category_model.dart';

class NewsByCategoryScreen extends StatefulWidget {
  final UserModel? userData;
  final CategoryModel category;
  const NewsByCategoryScreen(
      {Key? key, required this.userData, required this.category})
      : super(key: key);
  static const String route = '/kRouteNewsByCategory';

  @override
  _NewsByCategoryScreenState createState() => _NewsByCategoryScreenState();
}

class _NewsByCategoryScreenState extends State<NewsByCategoryScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  late final NewsBloc _newsBloc;
  late final CategoryBloc _categoryBloc;
  late final AuthBloc _authBloc;
  late final UserModel? userData;

  @override
  void initState() {
    super.initState();
    _categoryBloc = BlocProvider.of<CategoryBloc>(context)
      ..add(GetNewsByCategory(category: widget.category));
    _newsBloc = BlocProvider.of<NewsBloc>(context);
    _authBloc = BlocProvider.of<AuthBloc>(context);
    userData = (_authBloc.state as AuthSuccess).currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          key: _key,
          resizeToAvoidBottomInset: true,
          appBar: CustomAppBar()
              .appBarWithBack(pageTitle: "Interest", context: context),
          body: BlocBuilder<CategoryBloc, CategoryState>(
              buildWhen: (current, prev) {
            return current != prev;
          }, builder: (context, state) {
            if (state is CategoryInitial || state is CategoryLoading) {
              return const AppLoadingIndicator();
            }
            if (state is CategoryLoadSuccess) {
              final newsList = List.from(
                      state.otherCategoryList..addAll(state.likedCategoryList))
                  .where((element) =>
                      element.categoryName == widget.category.categoryName)
                  .first
                  .news;
              return newsList.isEmpty
                  ? const Center(
                      child: Text("No news of this category available"),
                    )
                  : ListView.separated(
                      padding: EdgeInsets.only(top: 16.h),
                      separatorBuilder: (BuildContext context, int index) {
                        return const ColoredBox(
                            color: AppColors.appWhite,
                            child: Divider(
                              thickness: 1.5,
                              height: 14,
                            ));
                      },
                      itemCount: newsList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                SingleNewsScreen.route,
                                arguments: [index, newsList, userData]);
                          },
                          child: NewsDetailCard(
                            channelName: newsList[index].channel.channel,
                            newsDescription: newsList[index].content,
                            newsTime: newsList[index].date,
                            numberOfLikes: newsList[index].likes!.toString(),
                            numberOfComments:
                                newsList[index].comment!.length.toString(),
                            onTapHeart: () {
                              if (userData != null) {
                                if (userData!.history!
                                    .any((e) => newsList[index].id == e.id)) {
                                  _authBloc.add(RemoveFromHistory(
                                      newsModel: newsList[index],
                                      user: userData!.copyWith(
                                          history: userData!.history!
                                            ..remove(newsList[index].id))));
                                  _categoryBloc.add(UnlikeNewsCategoryEvent(
                                      unlikedNews: newsList[index].copyWith(
                                          likes: newsList[index].likes! - 1),
                                      category: widget.category));
                                } else {
                                  _authBloc.add(AddToHistory(
                                      newsModel: newsList[index],
                                      user: userData!));
                                  _categoryBloc.add(LikeNewsCategoryEvent(
                                      likedNews: newsList[index].copyWith(
                                          likes: newsList[index].likes! + 1),
                                      category: widget.category));
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
                                                onTap: () =>
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            LoginScreen.route),
                                                child: Text(
                                                  ' Login to Continue',
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
                                                    MainAxisAlignment
                                                        .spaceAround,
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
                              Navigator.of(context).pushNamed(
                                  CommentScreen.route,
                                  arguments: newsList[index]);
                            },
                            onTapBookmark: () {
                              if (userData == null) {
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
                                                onTap: () =>
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            LoginScreen.route),
                                                child: Text(
                                                  ' Login to Continue',
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
                                                    MainAxisAlignment
                                                        .spaceAround,
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
                              } else {
                                if (widget.userData!.bookmarks!
                                    .contains(newsList[index])) {
                                  _authBloc.add(RemoveBookMarkEvent(
                                      newsToBookmark: newsList[index],
                                      user: widget.userData!));
                                } else {
                                  _authBloc.add(AddToBookMarkEvent(
                                      newsToBookmark: newsList[index],
                                      user: widget.userData!));
                                }
                              }
                            },
                            onTapShare: () {
                              Share.share(
                                  'check out this ${newsList[index].url}');
                            },
                            onTapMenu: () {},
                            isBookmark: userData == null
                                ? false
                                : userData!.bookmarks!
                                    .any((e) => newsList[index].id == e.id),
                            isHeart: userData == null
                                ? false
                                : userData!.history!
                                    .any((e) => newsList[index].id == e.id),
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
          endDrawer: const AppDrawer()),
    );
  }
}
