import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/features/auth/models/user_model.dart';
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
      child: ListView(
        children: [
          SettingsCard.text(
              cardText: "Username",
              onTap: () {},
              text: widget.user.username.toString()),
          EmailCard(email: widget.user.email.toString()),
          SettingsCard(cardText: "Change Password", onTap: () {}),
          SettingsCard.toggle(
              cardText: "Dark mode", isToggled: false, onTapToggle: (val) {}),
          SettingsCard.toggle(
              cardText: "Notifications",
              isToggled: false,
              onTapToggle: (val) {}),
          SettingsCard.hasNumber(
              cardText: "Following", onTap: () {}, number: 1),
          SettingsCard.hasNumber(cardText: "Blocked", onTap: () {}, number: 1),
          SettingsCard(cardText: "Help", onTap: () {}),
          SettingsCard(cardText: "Feedback", onTap: () {}),
          SettingsCard(cardText: "About us", onTap: () {}),
          SettingsCard.logout(
            cardText: "Logout",
            onTap: () {
              BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
              Navigator.of(context).pop();
            },
          ),
          SizedBox(
            height: 200.h,
          ),
        ],
      ),
    );
  }
}
