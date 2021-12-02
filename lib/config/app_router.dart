import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:news_app/app/cubit/navigation/navigation_cubit.dart';
import 'package:news_app/app/cubit/network/network_cubit.dart';
import 'package:news_app/features/auth/models/user_model.dart';
import 'package:news_app/features/auth/services/auth_service.dart';
import 'package:news_app/features/categories/bloc/category_bloc.dart';
import 'package:news_app/features/categories/screens/follwing_category_screen.dart';
import 'package:news_app/features/categories/screens/news_by_category.dart';
import 'package:news_app/features/categories/services/category_service.dart';
import 'package:news_app/features/channels/bloc/channel_bloc.dart';
import 'package:news_app/features/channels/screens/news_by_channel.dart';
import 'package:news_app/features/channels/services/channel_service.dart';
import 'package:news_app/features/news_feed/bloc/filter/cubit/filter_cubit.dart';
import 'package:news_app/features/news_feed/bloc/search/search_cubit.dart';
import 'package:news_app/features/news_feed/bloc/tts/tts_cubit.dart';
import 'package:news_app/features/news_feed/services/news_service.dart';
import 'package:news_app/features/news_feed/services/tts_service.dart';
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

final _ttsService = TtsService(flutterTts: FlutterTts());
final _ttsCubit = TtsCubit(ttsService: _ttsService);
//Services instance
final _authService = AuthService(newsService: _newsService);
final _categoryService = CategoryService();
final _newsService = NewsService(categoryService: _categoryService);
final _channelService = ChannelService(newsService: _newsService);

//Bloc Instances
final _authBloc = AuthBloc(authService: _authService);
final _newsBloc = NewsBloc(newsService: _newsService);
final _filerBloc = FilterCubit(newsBloc: _newsBloc);
final _categoryBloc =
    CategoryBloc(catgoryService: _categoryService, newsService: _newsService);
final _channelBloc =
    ChannelBloc(channelService: _channelService, newsService: _newsService);

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SignUpScreen.route:
      return MaterialPageRoute(
        builder: (context) =>
            BlocProvider.value(value: _authBloc, child: const SignUpScreen()),
      );
    case BaseScreen.route:
      return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: _authBloc),
                  BlocProvider.value(value: _newsBloc),
                  BlocProvider.value(value: _categoryBloc),
                  BlocProvider.value(value: _channelBloc),
                  BlocProvider(create: (_) => NavigationCubit()),
                ],
                child: BaseScreen(),
              ));

    case LoginScreen.route:
      return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
                value: _authBloc,
                child: const LoginScreen(),
              ));
    case FollowingCategoryScreen.route:
      return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
                value: _authBloc,
                child: const FollowingCategoryScreen(),
              ));

    case MyFeedScreen.route:
      log('routing to Feed Screen');
      return MaterialPageRoute(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: _authBloc),
            BlocProvider.value(value: _newsBloc),
            BlocProvider.value(value: _filerBloc),
          ],
          child: MyFeedScreen(),
        ),
      );

    case DiscoverScreen.route:
      return MaterialPageRoute(builder: (context) => const DiscoverScreen());

    case SingleNewsScreen.route:
      final args = settings.arguments as List;
      return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => _ttsCubit,
                  ),
                  BlocProvider.value(
                    value: _authBloc,
                  ),
                  BlocProvider.value(
                    value: _newsBloc,
                  ),
                  BlocProvider.value(
                    value: _categoryBloc,
                  ),
                ],
                child: SingleNewsScreen(
                  currentNewsIndex: args.first as int,
                  news: args[1] as List<News>,
                  user: args.last != null ? args.last as UserModel : null,
                ),
              ));
    case ChannelScreen.route:
      return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
                value: _channelBloc,
                child: ChannelScreen(),
              ));
    case CategoryScreen.route:
      return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: _categoryBloc,
                  ),
                  BlocProvider.value(
                    value: _authBloc,
                  ),
                ],
                child: CategoryScreen(),
              ));
    case NewsByChannelScreen.route:
      return MaterialPageRoute(builder: (context) {
        final args = settings.arguments as String;
        return BlocProvider.value(
          value: _categoryBloc,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: _channelBloc),
              BlocProvider.value(value: _authBloc),
              BlocProvider.value(value: _newsBloc),
              BlocProvider.value(value: _filerBloc),
            ],
            child: NewsByChannelScreen(
              channelName: args,
            ),
          ),
        );
      });

    case NewsByCategoryScreen.route:
      return MaterialPageRoute(builder: (context) {
        final args = settings.arguments as List;
        return BlocProvider.value(
          value: _categoryBloc,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: _newsBloc,
              ),
              BlocProvider.value(
                value: _categoryBloc,
              ),
              BlocProvider.value(
                value: _authBloc,
              ),
            ],
            child: NewsByCategoryScreen(
              userData: args.first == null ? null : args.first as UserModel,
              category: args[1],
            ),
          ),
        );
      });
    case ChooseCategoryScreen.route:
      return MaterialPageRoute(
          builder: (context) => BlocProvider.value(
                value: _authBloc,
                child: ChooseCategoryScreen(
                  categoryService: _categoryService,
                ),
              ));
    case ProfileScreen.route:
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
                child: const ProfileScreen(),
              ));
    case CommentScreen.route:
      return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: _newsBloc,
                  ),
                  BlocProvider.value(
                    value: _authBloc,
                  ),
                ],
                child: CommentScreen(
                  newsModel: settings.arguments as News,
                ),
              ));
    case SearchScreen.route:
      final user = settings.arguments as UserModel;
      return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => SearchCubit(newsService: _newsService),
                  ),
                  BlocProvider.value(value: _newsBloc),
                  BlocProvider.value(value: _authBloc),
                ],
                child: SearchScreen(
                  user: user,
                ),
              ));

    default:
      return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(value: _authBloc),
                  BlocProvider.value(value: _newsBloc),
                  BlocProvider.value(value: _categoryBloc),
                  BlocProvider.value(value: _channelBloc),
                  BlocProvider.value(value: _filerBloc),
                  BlocProvider.value(value: NetworkCubit()),
                ],
                child: BaseScreen(),
              ));
  }
}
