import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/features/auth/services/auth_service.dart';

class AuthTest extends StatelessWidget {
  static const String route = '/kTest';
  const AuthTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
              onTap: () {
                AuthService().logout();
              },
              child: Center(
                  child: Text(FirebaseAuth.instance.currentUser!.email!))),
        ],
      ),
    );
  }
}
