import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/components/app_form_field.dart';
import 'package:news_app/components/buttons/form_button.dart';
import 'package:news_app/config/theme/app_icons.dart';
import 'package:news_app/config/theme/theme.dart';
import 'package:news_app/features/auth/widgets/sign_up_form.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static const String route = '/kRouteLogin';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.appWhite,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.chevron_left_outlined,
            color: AppColors.appBlack,
            size: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 100.h,
            ),
            Text("Get only what you want",
                style: AppStyle.semiBoldText16
                    .copyWith(color: AppColors.darkBlueShade1)),
            SizedBox(
              height: 5.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Text(
                "Sign Up",
                style: AppStyle.boldText20
                    .copyWith(color: AppColors.darkBlueShade1),
              ),
            ),
            SignUpForm(),
            SizedBox(
              height: 10.h,
            ),
            FormButton(
              onTap: () {},
            ),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text("or with your",
                  style: AppStyle.regularText12
                      .copyWith(color: AppColors.darkBlueShade2)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Image(
                    image: AppIcons.facebook,
                  ),
                  Image(
                    image: AppIcons.google,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25.h,
            ),
            RichText(
              text: TextSpan(
                text: "Already have an account? ",
                style: AppStyle.regularText14
                    .copyWith(color: AppColors.darkBlueShade2),
                children: [
                  TextSpan(
                    text: "Login",
                    style: AppStyle.boldText16
                        .copyWith(color: AppColors.yellowShade2),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50.h,
            )
          ],
        ),
      ),
    );
  }
}
