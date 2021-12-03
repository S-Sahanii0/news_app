import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/app/cubit/navigation/navigation_cubit.dart';
import 'package:news_app/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/features/auth/models/user_model.dart';
import 'package:news_app/features/auth/screens/login_screen.dart';
import 'package:news_app/features/profile/tabs/settings_tab.dart';
import 'package:provider/src/provider.dart';
import '../config/theme/theme.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late final NavigationCubit _navigationCubit;
  late final AuthBloc _authBloc;
  late UserModel? _user;
  @override
  void initState() {
    super.initState();
    _authBloc = context.read<AuthBloc>();
    _user = (_authBloc.state as AuthSuccess).currentUser;
    _navigationCubit = context.read<NavigationCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        // Set the transparency here
        canvasColor: Colors
            .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
      ),
      child: Drawer(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            color: AppColors.blueShade2,
          ),
          child: Column(
            // Important: Remove any padding from the ListView.
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              DrawerHeader(
                child: Center(
                    child: Text(
                  '"Health Quote"',
                  style: AppStyle.regularText18,
                )),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () {
                    _navigationCubit.navigateToMyFeed();
                  },
                  child: Text(
                    "My Feed",
                    style: AppStyle.mediumText20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () {
                    _navigationCubit.navigateToDiscover();
                  },
                  child: Text(
                    "Discover",
                    style: AppStyle.mediumText20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () {
                    _navigationCubit.navigateToCategory();
                  },
                  child: Text(
                    "Categories",
                    style: AppStyle.mediumText20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () {
                    _navigationCubit.navigateToChannels();
                  },
                  child: Text(
                    "Channels",
                    style: AppStyle.mediumText20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: InkWell(
                  onTap: () {
                    if (_user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text(
                              "Please Login to access the following feature")));
                    } else {
                      _navigationCubit.navigateToProfile();
                    }
                  },
                  child: Text(
                    "Profile",
                    style: AppStyle.mediumText20,
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Row(children: [
                  GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close)),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        if (_user != null) {
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
                        } else {
                          Navigator.of(context)
                              .pushReplacementNamed(LoginScreen.route);
                        }
                      },
                      child: _user == null
                          ? Text("Login/SignUp", style: AppStyle.regularText14)
                          : Text("Logout", style: AppStyle.regularText14))
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
