import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/features/auth/bloc/auth_bloc.dart';
import 'package:news_app/features/auth/screens/login_screen.dart';
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
                Navigator.of(context).pushReplacementNamed(LoginScreen.route);
                BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
              },
              child: Center(
                  child: Text(FirebaseAuth.instance.currentUser!.email!))),
        ],
      ),
    );
  }
}
