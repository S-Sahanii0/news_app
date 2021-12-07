import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:news_app/components/app_loading.dart';
import 'package:news_app/components/buttons/app_outlined_button.dart';
import 'package:news_app/features/auth/bloc/auth_bloc.dart';
import 'package:news_app/features/auth/models/user_model.dart';
import 'package:news_app/features/auth/screens/login_screen.dart';
import 'package:news_app/features/categories/bloc/category_bloc.dart';
import 'package:news_app/features/categories/screens/news_by_category.dart';
import 'package:news_app/features/news_feed/screens/my_feed.dart';
import '../../../components/app_bar/app_bar.dart';
import '../../../components/app_card.dart';
import '../../../components/app_drawer.dart';
import '../../../components/app_floating_button.dart';

import '../../../config/theme/theme.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);
  static const String route = '/kRouteInterest';

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late final AuthBloc _authBloc;
  late final UserModel? userData;
  late final CategoryBloc _categoryBloc;

  late String uid;
  @override
  void initState() {
    super.initState();

    _authBloc = BlocProvider.of<AuthBloc>(context);
    userData = (_authBloc.state as AuthSuccess).currentUser;
    _categoryBloc = BlocProvider.of<CategoryBloc>(context)
      ..add(GetCategoryEvent(user: userData));
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _key,
        appBar: CustomAppBar().appBarWithNoBack(pageTitle: "Category", context: context),
        floatingActionButton: AppFloatingActionButton(
          scaffoldKey: _key,
        ),
        endDrawer: const AppDrawer(),
        body: SingleChildScrollView(
          child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryInitial || state is CategoryLoading) {
                return const Center(child: AppLoadingIndicator());
              }

              if (state is CategoryLoadSuccess) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("My Interests",
                          style: AppStyle.regularText14
                              .copyWith(color: AppColors.darkBlueShade2)),
                      SizedBox(
                        height: 8.h,
                      ),
                      if (state.likedCategoryList.isNotEmpty)
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.likedCategoryList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(NewsByCategoryScreen.route, arguments: [
                                    userData,
                                    state.likedCategoryList[index]
                                  ]);
                                },
                                child: AppCard.hasHeart(
                                  cardText: state.likedCategoryList[index].categoryName,
                                  onTap: () {},
                                  isSaved: true,
                                  onTapheart: () {
                                    if (userData != null) {
                                      _categoryBloc.add(UnlikeCategoryEvent(
                                          caytegory: state.likedCategoryList[index]));
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
                                                        horizontal: 28.w, vertical: 20.h),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceAround,
                                                      children: [
                                                        AppOutlinedButton(
                                                            onTap: () {
                                                              Navigator.of(context).pop();
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
                                ),
                              );
                            }),
                      if (state.likedCategoryList.isEmpty)
                        Center(
                          child: Text(
                            "You have not liked any category",
                            style: AppStyle.semiBoldText14
                                .copyWith(color: AppColors.darkBlueShade2),
                          ),
                        ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text("Other Topics",
                          style: AppStyle.regularText14
                              .copyWith(color: AppColors.darkBlueShade2)),
                      SizedBox(
                        height: 8.h,
                      ),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: state.otherCategoryList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(NewsByCategoryScreen.route, arguments: [
                                  userData,
                                  state.otherCategoryList[index]
                                ]);
                              },
                              child: AppCard.hasHeart(
                                cardText: state.otherCategoryList[index].categoryName,
                                onTap: () {},
                                isSaved: false,
                                onTapheart: () {
                                  if (userData != null) {
                                    _categoryBloc.add(LikeCategoryEvent(
                                        caytegory: state.otherCategoryList[index]));
                                    _authBloc.add(AddChosenCategoryEvent(categoryList: [
                                      state.otherCategoryList[index].categoryName
                                    ], user: userData!));
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
                                                      horizontal: 28.w, vertical: 20.h),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceAround,
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
                            );
                          }),
                      SizedBox(
                        height: 100.h,
                      )
                    ],
                  ),
                );
              } else {
                return const Center(child: Text("Please try again later"));
              }
            },
          ),
        ),
      ),
    );
  }
}
