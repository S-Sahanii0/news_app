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
  final UserModel user;

  AddToBookMarkEvent({required this.newsToBookmark, required this.user});
}

class RemoveBookMarkEvent extends AuthEvent {
  final News newsToBookmark;
  final UserModel user;

  RemoveBookMarkEvent({required this.newsToBookmark, required this.user});
}

class AddChosenCategoryEvent extends AuthEvent {
  final List<String> categoryList;
  final UserModel user;

  AddChosenCategoryEvent({required this.categoryList, required this.user});
}

class AddToHistory extends AuthEvent {
  final News newsModel;
  final UserModel user;

  AddToHistory({required this.newsModel, required this.user});
}

class RemoveFromHistory extends AuthEvent {
  final News newsModel;
  final UserModel user;

  RemoveFromHistory({required this.newsModel, required this.user});
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
