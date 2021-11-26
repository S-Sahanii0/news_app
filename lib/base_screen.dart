import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/app/screens/navigation_screen.dart';
import 'package:news_app/components/app_loading.dart';
import 'app/cubit/network/network_cubit.dart';
import 'components/buttons/app_button.dart';
import 'components/buttons/app_outlined_button.dart';
import 'config/theme/app_colors.dart';
import 'config/theme/app_styles.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/screens/auth_test.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/services/auth_service.dart';
import 'features/categories/screens/choose_category_screen.dart';
import 'features/news_feed/screens/my_feed.dart';

import 'features/news_feed/bloc/news_bloc.dart';

class BaseScreen extends StatefulWidget {
  BaseScreen({Key? key}) : super(key: key);

  static const String route = "/kBaseScreen";

  @override
  State<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AppStartedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NetworkCubit, NetworkState>(
      listener: (context, state) {
        if (state is BadNetwork) {
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
                        child: Text(
                          'No Internet Connection.',
                          style: AppStyle.semiBoldText16
                              .copyWith(color: AppColors.darkBlueShade2),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 20.h),
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
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            return const NavigationScreen();
          }
          if (state is AuthLoading) {
            return const Scaffold(
              body: Center(
                child: AppLoadingIndicator(),
              ),
            );
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
