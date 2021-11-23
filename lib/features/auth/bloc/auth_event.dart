part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class RegisterEvent extends AuthEvent {
  final UserModel user;

  RegisterEvent({required this.user});
}

class GoogleSignInEvent extends AuthEvent {}

class FacebookSignInEvent extends AuthEvent {}

class AddToBookMarkEvent extends AuthEvent {
  final News newsToBookmark;
  final String uid;

  AddToBookMarkEvent({required this.newsToBookmark, required this.uid});
}

class LoginEvent extends AuthEvent {
  final UserModel user;

  LoginEvent({required this.user});
}

class LogoutEvent extends AuthEvent {}

class LoginSuccess extends AuthEvent {
  final User user;

  LoginSuccess({required this.user});
}

class AppStartedEvent extends AuthEvent {}

class LoginFailure extends AuthEvent {}
