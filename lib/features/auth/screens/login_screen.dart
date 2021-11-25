import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../components/app_bar/app_bar.dart';
import '../../../config/theme/app_icons.dart';
import '../../../config/theme/theme.dart';
import '../bloc/auth_bloc.dart';
import '../models/user_model.dart';
import 'auth_test.dart';
import 'sign_up_screen.dart';
import '../widgets/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static const String route = '/kRouteLogin';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 65),
                  child: LoginForm(
                    onSubmit: (value) {
                      if (value.currentState!.validate()) {
                        value.currentState!.save();
                        final result = value.currentState!.value;
                        print(result);
                        BlocProvider.of<AuthBloc>(context)
                            .add(LoginEvent(user: UserModel.fromMap(result)));
                      }
                    },
                  ),
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
                    children: [
                      GestureDetector(
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Coming soon"))),
                        child: Image(
                          image: AppIcons.facebook,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          BlocProvider.of<AuthBloc>(context)
                              .add(GoogleSignInEvent());
                        },
                        child: Image(
                          image: AppIcons.google,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(SignUpScreen.route);
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
