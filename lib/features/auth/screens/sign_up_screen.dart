import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/base_screen.dart';
import 'package:news_app/components/app_loading.dart';

import '../../../config/theme/app_icons.dart';
import '../../../config/theme/theme.dart';
import '../../categories/screens/choose_category_screen.dart';
import '../../news_feed/screens/my_feed.dart';
import '../bloc/auth_bloc.dart';
import '../models/user_model.dart';
import '../widgets/sign_up_form.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static const String route = '/kRouteSignUp';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  late final _authState;

  @override
  void initState() {
    _authState = context.read<AuthBloc>();
    super.initState();
  }

  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      buildWhen: (prev, current) => prev != current,
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.of(context)
              .pushReplacementNamed(ChooseCategoryScreen.route);
        }
        if (state is LogoutState) {
          //changed this from LoginScreen to BaseScreen
          Navigator.of(context).pushReplacementNamed(BaseScreen.route);
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.errorMessage)));
        }
      },
      builder: (context, state) => (state is AuthLoading)
          ? const Scaffold(
              body: Center(
                child: AppLoadingIndicator(),
              ),
            )
          : Scaffold(
              key: _scaffoldKey,
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
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
                actions: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GestureDetector(
                        onTap: () {
                          BlocProvider.of<AuthBloc>(context)
                              .add(AnonLoginEvent());
                        },
                        child: Text(
                          'Skip',
                          style: AppStyle.mediumText16
                              .copyWith(color: AppColors.yellowShade1),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 30.h,
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
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 65.w),
                      child: SignUpForm(
                        onSubmit: (value) {
                          if (value.currentState!.validate()) {
                            value.currentState!.save();
                            final result = value.currentState!.value;
                            BlocProvider.of<AuthBloc>(context).add(
                                RegisterEvent(user: UserModel.fromMap(result)));
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
                            onTap: () => ScaffoldMessenger.of(context)
                                .showSnackBar(
                                    SnackBar(content: Text("Coming soon"))),
                            child: const Image(
                              image: AppIcons.facebook,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => BlocProvider.of<AuthBloc>(context)
                                .add(GoogleSignInEvent()),
                            child: const Image(
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
                        Navigator.of(context).pop();
                      },
                      child: RichText(
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
                    ),
                    SizedBox(
                      height: 50.h,
                    )
                  ],
                ),
              )),
    );
  }
}
