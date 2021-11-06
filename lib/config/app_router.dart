import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/base_screen.dart';
import 'package:news_app/features/auth/bloc/auth_bloc.dart';
import 'package:news_app/features/auth/screens/auth_test.dart';
import 'package:news_app/features/auth/screens/login_screen.dart';
import 'package:news_app/features/auth/screens/sign_up_screen.dart';
import 'package:news_app/features/categories/screens/category_screen.dart';
import 'package:news_app/features/categories/screens/choose_category_screen.dart';
import 'package:news_app/features/channels/screens/channels_screen.dart';
import 'package:news_app/features/news_feed/screens/comments_screen.dart';
import 'package:news_app/features/news_feed/screens/discover_screen.dart';
import 'package:news_app/features/news_feed/screens/my_feed.dart';
import 'package:news_app/features/news_feed/screens/single_news_screen.dart';
import 'package:news_app/features/profile/screens/profile_screen.dart';

import 'theme/app_colors.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  late final _authBloc = AuthBloc();
  switch (settings.name) {
    case SignUpScreen.route:
      return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
                value: _authBloc,
                child: const SignUpScreen(),
              ));
    case BaseScreen.route:
      return MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => _authBloc,
                child: BaseScreen(),
              ));

    case LoginScreen.route:
      return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
                value: _authBloc,
                child: const LoginScreen(),
              ));

    case MyFeedScreen.route:
      return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
                value: _authBloc,
                child: const MyFeedScreen(),
              ));

    case DiscoverScreen.route:
      return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
                value: _authBloc,
                child: const DiscoverScreen(),
              ));

    case SingleNewsScreen.route:
      return MaterialPageRoute(builder: (context) => const SingleNewsScreen());
    case ChannelScreen.route:
      return MaterialPageRoute(builder: (context) => const ChannelScreen());
    case CategoryScreen.route:
      return MaterialPageRoute(builder: (context) => const CategoryScreen());
    case ChooseCategoryScreen.route:
      return MaterialPageRoute(
          builder: (context) => const ChooseCategoryScreen());
    case ProfileScreen.route:
      return MaterialPageRoute(builder: (context) => const ProfileScreen());
    case CommentScreen.route:
      return MaterialPageRoute(builder: (context) => const CommentScreen());

    default:
      return CupertinoPageRoute<void>(
        builder: (_) => const Center(
          child: Text('No Route Found',
              style: TextStyle(color: AppColors.appWhite)),
        ),
        settings: settings,
      );
  }
}
