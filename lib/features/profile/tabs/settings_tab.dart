import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/components/buttons/app_button.dart';
import 'package:news_app/components/buttons/app_outlined_button.dart';
import 'package:news_app/config/theme/app_colors.dart';
import 'package:news_app/config/theme/app_styles.dart';
import 'package:news_app/features/auth/models/user_model.dart';
import 'package:news_app/features/auth/services/auth_service.dart';
import 'package:news_app/features/categories/screens/follwing_category_screen.dart';
import 'package:news_app/features/profile/widgets/change_password_form.dart';
import '../../../components/app_card.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../widgets/email_card.dart';
import '../widgets/settings_screen_card.dart';

class Settings extends StatefulWidget {
  final UserModel user;
  const Settings({Key? key, required this.user}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Password didn't match")));
          }
        },
        builder: (context, state) {
          return ListView(
            children: [
              SettingsCard.text(
                  cardText: "Username",
                  onTap: () {},
                  text: widget.user.username.toString()),
              EmailCard(email: widget.user.email.toString()),
              SettingsCard(
                  cardText: "Change Password",
                  onTap: () {
                    showModalBottomSheet(
                        useRootNavigator: false,
                        isDismissible: true,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.r),
                          topRight: Radius.circular(10.r),
                        )),
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (contex) {
                          return _ChangePasswordBottomSheet(
                            authBloc: BlocProvider.of<AuthBloc>(context),
                            user: widget.user,
                          );
                        });
                  }),
              // SettingsCard.toggle(
              //     cardText: "Dark mode", isToggled: false, onTapToggle: (val) {}),
              // SettingsCard.toggle(
              //     cardText: "Notifications",
              //     isToggled: false,
              //     onTapToggle: (val) {}),
              SettingsCard.hasNumber(
                  cardText: "Following",
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed(FollowingCategoryScreen.route);
                  },
                  number: (state as AuthSuccess)
                      .currentUser
                      .chosenCategories!
                      .length),
              // SettingsCard.hasNumber(cardText: "Blocked", onTap: () {}, number: 1),
              // SettingsCard(cardText: "Help", onTap: () {}),
              // SettingsCard(cardText: "Feedback", onTap: () {}),
              // SettingsCard(cardText: "About us", onTap: () {}),
              SettingsCard.logout(
                  cardText: "Logout",
                  onTap: () {
                    showModalBottomSheet(
                        useRootNavigator: false,
                        isDismissible: true,
                        isScrollControlled: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.r),
                          topRight: Radius.circular(10.r),
                        )),
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (contex) {
                          return LogoutBottomSheet(
                            authBloc: BlocProvider.of<AuthBloc>(context),
                          );
                        });
                  }),
              SizedBox(
                height: 200.h,
              ),
            ],
          );
        },
      ),
    );
  }
}

class LogoutBottomSheet extends StatelessWidget {
  final AuthBloc authBloc;
  const LogoutBottomSheet({Key? key, required this.authBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.appWhite,
      ),
      constraints: BoxConstraints(maxHeight: 170.h),
      margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 25.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Text(
              'Are you sure you want to logout?',
              style: AppStyle.semiBoldText16
                  .copyWith(color: AppColors.darkBlueShade2),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 20.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AppOutlinedButton(
                    onTap: () {
                      Navigator.of(context).pop();
                      authBloc.add(LogoutEvent());
                    },
                    buttonText: "Logout"),
                AppButton(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    buttonText: "Cancel")
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChangePasswordBottomSheet extends StatelessWidget {
  final AuthBloc authBloc;
  final UserModel user;
  const _ChangePasswordBottomSheet(
      {Key? key, required this.authBloc, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.appWhite,
      ),
      constraints: BoxConstraints(maxHeight: 400.h),
      margin: EdgeInsets.symmetric(horizontal: 18.w, vertical: 25.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Text(
              'Change Password',
              style: AppStyle.semiBoldText16
                  .copyWith(color: AppColors.darkBlueShade2),
            ),
          ),
          ChangePasswordForm(onSubmit: (val) {
            if (val.currentState!.validate()) {
              val.currentState!.save();
              var result = val.currentState!.value;
              authBloc.add(
                ResetPasswordEvent(
                    user: user,
                    password: result['password'],
                    confirmPassword: result['confirm']),
              );
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Password changed successfully"),
              ));
            }
          }),
        ],
      ),
    );
  }
}
