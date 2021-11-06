import 'package:flutter/material.dart';
import 'package:news_app/components/app_card.dart';
import 'package:news_app/features/profile/widgets/email_card.dart';
import 'package:news_app/features/profile/widgets/settings_screen_card.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

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
          SettingsCard.text(cardText: "Username", onTap: () {}, text: "John"),
          const EmailCard(email: "John@gmail.com"),
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
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
