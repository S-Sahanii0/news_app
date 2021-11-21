import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/app/screens/navigation_screen.dart';
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
    return BlocBuilder<AuthBloc, AuthState>(
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
    );
  }
}
