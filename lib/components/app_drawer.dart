import 'package:flutter/material.dart';
import 'package:news_app/app/cubit/navigation_cubit.dart';
import 'package:provider/src/provider.dart';
import '../config/theme/theme.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late final NavigationCubit _navigationCubit;
  @override
  void initState() {
    super.initState();
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
                    // _navigationCubit.navigateToCategory(); todo
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
                    _navigationCubit.navigateToProfile();
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
                  Icon(Icons.close),
                  Spacer(),
                  Text("Login/SignUp", style: AppStyle.regularText14)
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
