import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../base_screen.dart';
import '../features/auth/bloc/auth_bloc.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/sign_up_screen.dart';
import '../features/categories/screens/category_screen.dart';
import '../features/categories/screens/choose_category_screen.dart';
import '../features/channels/screens/channels_screen.dart';
import '../features/news_feed/bloc/news_bloc.dart';
import '../features/news_feed/model/news_model.dart';
import '../features/news_feed/screens/comments_screen.dart';
import '../features/news_feed/screens/discover_screen.dart';
import '../features/news_feed/screens/my_feed.dart';
import '../features/news_feed/screens/search_screen.dart';
import '../features/news_feed/screens/single_news_screen.dart';
import '../features/profile/screens/profile_screen.dart';

import 'theme/app_colors.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final _authBloc = AuthBloc();
  final _newsBloc = NewsBloc();

  switch (settings.name) {
    case SignUpScreen.route:
      return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
                value: _authBloc,
                child: SignUpScreen(),
              ));
    case BaseScreen.route:
      return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: _authBloc,
                  ),
                  BlocProvider.value(
                    value: _newsBloc,
                  ),
                ],
                child: BaseScreen(),
              ));

    case LoginScreen.route:
      return MaterialPageRoute(builder: (context) => const LoginScreen());

    case MyFeedScreen.route:
      log('routing to Feed Screen');
      return MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: _authBloc),
            BlocProvider.value(value: _newsBloc),
          ],
          child: MyFeedScreen(),
        ),
      );

    case DiscoverScreen.route:
      return MaterialPageRoute(builder: (context) => const DiscoverScreen());

    case SingleNewsScreen.route:
      return MaterialPageRoute(
          builder: (context) => SingleNewsScreen(
                newsModel: settings.arguments as News,
              ));
    case ChannelScreen.route:
      return MaterialPageRoute(builder: (context) => const ChannelScreen());
    case CategoryScreen.route:
      return MaterialPageRoute(builder: (context) => const CategoryScreen());
    case ChooseCategoryScreen.route:
      return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
                value: _authBloc,
                child: const ChooseCategoryScreen(),
              ));
    case ProfileScreen.route:
      return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
                value: _authBloc,
                child: const ProfileScreen(),
              ));
    case CommentScreen.route:
      return MaterialPageRoute(
          builder: (context) =>
              CommentScreen(newsModel: settings.arguments as News));
    case SearchScreen.route:
      return MaterialPageRoute(builder: (context) => const SearchScreen());

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
