import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../config/theme/theme.dart';

class EmailCard extends StatefulWidget {
  const EmailCard({
    Key? key,
    required this.email,
  }) : super(key: key);

  final String email;

  @override
  State<EmailCard> createState() => _EmailCardState();
}

class _EmailCardState extends State<EmailCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Text(
            "Email",
            style:
                AppStyle.mediumText14.copyWith(color: AppColors.darkBlueShade1),
          ),
          const Spacer(
            flex: 6,
          ),
          Text(
            widget.email,
            style:
                AppStyle.mediumText16.copyWith(color: AppColors.darkBlueShade1),
          ),
          Image(
            height: 25.h,
            width: 25.w,
            image: AppIcons.google,
            color: AppColors.appWhite,
            colorBlendMode: BlendMode.saturation,
          )
        ],
      ),
    );
  }
}
