import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:news_app/components/app_loading.dart';
import 'package:news_app/features/auth/bloc/auth_bloc.dart';
import 'package:news_app/features/auth/models/user_model.dart';
import 'package:news_app/features/categories/bloc/category_bloc.dart';
import 'package:news_app/features/categories/screens/news_by_category.dart';
import 'package:news_app/features/news_feed/screens/my_feed.dart';
import '../../../components/app_bar/app_bar.dart';
import '../../../components/app_card.dart';
import '../../../components/app_drawer.dart';
import '../../../components/app_floating_button.dart';

import '../../../config/theme/theme.dart';

class FollowingCategoryScreen extends StatefulWidget {
  const FollowingCategoryScreen({Key? key}) : super(key: key);
  static const String route = '/kRouteFollowing';

  @override
  _FollowingCategoryScreenState createState() =>
      _FollowingCategoryScreenState();
}

class _FollowingCategoryScreenState extends State<FollowingCategoryScreen> {
  late final AuthBloc _authBloc;

  late String uid;
  @override
  void initState() {
    super.initState();

    _authBloc = BlocProvider.of<AuthBloc>(context);

    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar()
            .appBarWithBack(pageTitle: "Following", context: context),
        endDrawer: const AppDrawer(),
        body: SingleChildScrollView(
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthInitial || state is AuthLoading) {
                return const Center(child: AppLoadingIndicator());
              }

              if (state is AuthSuccess) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 17, vertical: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.currentUser!.chosenCategories!.isNotEmpty)
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount:
                                state.currentUser!.chosenCategories!.length,
                            itemBuilder: (context, index) {
                              return AppCard.hasRemoveButton(
                                cardText:
                                    state.currentUser!.chosenCategories![index],
                                onTapRemove: () {
                                  _authBloc.add(RemoveChosenCategoryEvent(
                                      category: state.currentUser!
                                          .chosenCategories![index],
                                      user: state.currentUser!));
                                },
                              );
                            }),
                      SizedBox(
                        height: 8.h,
                      ),
                      if (state.currentUser!.chosenCategories!.isEmpty)
                        Center(
                          child: Text(
                            "You have not liked any category",
                            style: AppStyle.semiBoldText14
                                .copyWith(color: AppColors.darkBlueShade2),
                          ),
                        ),
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
