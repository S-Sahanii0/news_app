import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/features/auth/screens/sign_up_screen.dart';

import 'theme/app_colors.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case SignUpScreen.route:
      return MaterialPageRoute(builder: (context) => const SignUpScreen());
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
