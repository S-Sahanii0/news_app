import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/app/cubit/navigation/navigation_cubit.dart';
import 'package:news_app/features/categories/screens/category_screen.dart';
import 'package:news_app/features/channels/screens/channels_screen.dart';
import 'package:news_app/features/news_feed/screens/discover_screen.dart';
import 'package:news_app/features/news_feed/screens/my_feed.dart';
import 'package:news_app/features/profile/screens/profile_screen.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<NavigationCubit, NavigationState>(
          builder: (context, state) {
            if (state is MyFeedState) {
              return const MyFeedScreen();
            }
            if (state is ChannelsState) {
              return const ChannelScreen();
            }
            if (state is DiscoverState) {
              return const DiscoverScreen();
            }
            if (state is CategoryState) {
              return const CategoryScreen();
            }
            if (state is ProfileState) {
              return const ProfileScreen();
            } else {
              return const Center(
                child: Text('Screens Holder'),
              );
            }
          },
        ),
      ),
    );
  }
}
