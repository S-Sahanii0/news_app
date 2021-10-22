import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/features/auth/screens/auth_test.dart';
import 'package:news_app/features/auth/screens/login_screen.dart';
import 'package:news_app/features/auth/services/auth_service.dart';

class BaseScreen extends StatelessWidget {
  BaseScreen({Key? key}) : super(key: key);

  static const String route = "/kBaseScreen";
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: _authService.checkUser(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return const AuthTest();
          }
          if (snapshot.data == null) {
            return LoginScreen();
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
