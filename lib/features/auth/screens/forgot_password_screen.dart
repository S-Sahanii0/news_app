import 'dart:async';

import 'package:flutter/material.dart';
import 'package:news_app/components/app_bar/app_bar.dart';
import 'package:news_app/config/theme/app_colors.dart';
import 'package:news_app/config/theme/app_styles.dart';
import 'package:news_app/features/auth/bloc/auth_bloc.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:provider/src/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key, required this.email}) : super(key: key);

  static const route = '/forgot-password';

  final String email;

  Stream<int> get _countdown async* {
    for (var i = 300; i >= 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      yield i;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBar().appBarWithBack(pageTitle: 'Forgot Password', context: context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sent password reset link to your gmail',
              style: AppStyle.mediumText16.copyWith(color: AppColors.darkBlueShade1),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Open Gmail',
                    style:
                        AppStyle.mediumText14.copyWith(color: AppColors.darkBlueShade2)),
                const SizedBox(width: 10),
                InkWell(
                  onTap: () async {
                    await OpenMailApp.openMailApp();
                  },
                  child: const Icon(
                    Icons.open_in_new,
                    color: AppColors.darkBlueShade1,
                    size: 22,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: StreamBuilder<int>(
                initialData: 300,
                stream: _countdown,
                builder: (context, snapshot) {
                  return Text(
                    "0${snapshot.data! ~/ 60}:${(snapshot.data! % 60).toString().padLeft(2, '0')}",
                    style: AppStyle.boldText20.copyWith(color: AppColors.darkBlueShade1),
                  );
                },
              ),
            ),
            Row(children: [
              StreamBuilder<int>(
                  initialData: 300,
                  stream: _countdown,
                  builder: (context, snapshot) {
                    return InkWell(
                      onTap: snapshot.data == 0
                          ? () =>
                              context.read<AuthBloc>().add(ForgotPasswordEvent(email: ''))
                          : null,
                      child: Text(
                        'Resend',
                        style: AppStyle.mediumText14.copyWith(
                            color: snapshot.data == 0
                                ? AppColors.darkBlueShade1
                                : AppColors.darkBlueShade3),
                      ),
                    );
                  }),
              const SizedBox(width: 10),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Login',
                  style: AppStyle.boldText14.copyWith(color: AppColors.blueShade1),
                ),
              )
            ])
          ],
        ),
      ),
    );
  }
}
