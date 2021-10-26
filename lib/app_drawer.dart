import 'package:flutter/material.dart';

import 'config/theme/theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: DecoratedBox(
        decoration: const BoxDecoration(
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
                onTap: () {},
                child: Text(
                  "My Feed",
                  style: AppStyle.mediumText20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                onTap: () {},
                child: Text(
                  "Discover",
                  style: AppStyle.mediumText20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                onTap: () {},
                child: Text(
                  "Categories",
                  style: AppStyle.mediumText20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                onTap: () {},
                child: Text(
                  "Channels",
                  style: AppStyle.mediumText20,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                onTap: () {},
                child: Text(
                  "Invite",
                  style: AppStyle.mediumText20,
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(children: [
                Icon(Icons.close),
                Spacer(),
                Text("Login/SignUp", style: AppStyle.regularText14)
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
