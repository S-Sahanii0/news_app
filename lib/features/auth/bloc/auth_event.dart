part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class RegisterEvent extends AuthEvent {
  final UserModel user;

  RegisterEvent({required this.user});
}

class LoginEvent extends AuthEvent {
  final UserModel user;

  LoginEvent({required this.user});
}

class LogoutEvent extends AuthEvent {}

class LoginSuccess extends AuthEvent {
  final UserModel user;

  LoginSuccess({required this.user});
}

class LoginFailure extends AuthEvent {}
