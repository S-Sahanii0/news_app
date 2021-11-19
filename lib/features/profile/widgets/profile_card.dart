import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/theme.dart';

class ProfileCard extends StatelessWidget {
  final String username;
  final String profileBio;
  const ProfileCard(
      {Key? key, required this.username, required this.profileBio})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.appWhite,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.yellowShade2,
              radius: 25,
              backgroundImage:
                  ExactAssetImage("assets/images/dummy_channel.png"),
            ),
            SizedBox(width: 15.w),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: AppStyle.mediumText18
                        .copyWith(color: AppColors.darkBlueShade1),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    profileBio,
                    style: AppStyle.regularText12
                        .copyWith(color: AppColors.darkBlueShade3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
