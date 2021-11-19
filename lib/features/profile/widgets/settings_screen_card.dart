import 'package:flutter/material.dart';
import '../../../config/theme/theme.dart';

class SettingsCard extends StatefulWidget {
  SettingsCard.toggle({
    Key? key,
    required this.cardText,
    required this.isToggled,
    required this.onTapToggle,
  }) : super(key: key) {
    hasText = false;
    withArrow = false;
    canBeToggled = true;
    hasNumber = false;
  }
  SettingsCard.hasNumber(
      {Key? key,
      required this.cardText,
      required this.onTap,
      required this.number})
      : super(key: key) {
    hasText = false;
    withArrow = true;
    canBeToggled = false;
    hasNumber = true;
    hasLogoutButton = false;
  }
  SettingsCard.logout({
    Key? key,
    required this.cardText,
    required this.onTap,
  }) : super(key: key) {
    hasText = false;

    withArrow = false;
    canBeToggled = false;
    hasNumber = false;
    hasLogoutButton = true;
  }
  SettingsCard.text(
      {Key? key,
      required this.cardText,
      required this.onTap,
      required this.text})
      : super(key: key) {
    hasText = true;
    withArrow = false;
    canBeToggled = false;
    hasNumber = false;
    hasLogoutButton = false;
  }
  SettingsCard({
    Key? key,
    required this.cardText,
    required this.onTap,
  }) : super(key: key) {
    hasText = false;
    withArrow = true;
    canBeToggled = false;
    hasNumber = false;
    hasLogoutButton = false;
  }

  final String cardText;
  bool? canBeToggled;
  bool? isToggled;
  bool? hasNumber;
  bool? hasText;
  String? text;
  bool? withArrow;
  bool? hasLogoutButton;
  int? number;

  VoidCallback? onTap;
  ValueSetter? onTapToggle;

  @override
  State<SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Text(
            widget.cardText,
            style:
                AppStyle.mediumText14.copyWith(color: AppColors.darkBlueShade1),
          ),
          const Spacer(
            flex: 6,
          ),
          if (widget.hasNumber!)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                widget.number.toString(),
                style: AppStyle.mediumText16
                    .copyWith(color: AppColors.darkBlueShade1),
              ),
            ),
          if (widget.canBeToggled == true)
            Switch(
                activeColor: AppColors.yellowShade1,
                value: widget.isToggled!,
                onChanged: widget.onTapToggle),
          if (widget.withArrow!)
            GestureDetector(
              onTap: widget.onTap,
              child: const Icon(
                Icons.chevron_right_outlined,
                color: AppColors.darkBlueShade3,
                size: 24,
              ),
            ),
          if (widget.hasLogoutButton == true)
            GestureDetector(
              onTap: widget.onTap,
              child: const Icon(
                Icons.power_settings_new,
                color: AppColors.darkBlueShade3,
                size: 24,
              ),
            ),
          if (widget.hasText!)
            Text(
              widget.text!,
              style: AppStyle.mediumText16
                  .copyWith(color: AppColors.darkBlueShade1),
            )
        ],
      ),
    );
  }
}
