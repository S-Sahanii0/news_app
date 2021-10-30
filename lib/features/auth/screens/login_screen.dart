import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/config/app_bar/app_bar.dart';
import 'package:news_app/config/theme/app_icons.dart';
import 'package:news_app/config/theme/theme.dart';
import 'package:news_app/features/auth/bloc/auth_bloc.dart';
import 'package:news_app/features/auth/models/user_model.dart';
import 'package:news_app/features/auth/screens/auth_test.dart';
import 'package:news_app/features/auth/screens/sign_up_screen.dart';
import 'package:news_app/features/auth/widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String route = '/kRouteLogin';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar().appBarWithBack(context),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return SingleChildScrollView(
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
                    "Login",
                    style: AppStyle.boldText20
                        .copyWith(color: AppColors.darkBlueShade1),
                  ),
                ),
                LoginForm(
                  onSubmit: (value) {
                    value.currentState!.save();
                    final result = value.currentState!.value;
                    BlocProvider.of<AuthBloc>(context)
                        .add(LoginEvent(user: UserModel.fromMap(result)));
                  },
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
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(SignUpScreen.route);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "New Here? ",
                      style: AppStyle.regularText14
                          .copyWith(color: AppColors.darkBlueShade2),
                      children: [
                        TextSpan(
                          text: "SignUp",
                          style: AppStyle.boldText16
                              .copyWith(color: AppColors.yellowShade2),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.h,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
