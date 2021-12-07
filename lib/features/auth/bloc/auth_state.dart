part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel? currentUser;

  AuthSuccess({this.currentUser});

  @override
  List<Object?> get props => [currentUser];
}

class AuthFailure extends AuthState {
  final String errorMessage;

  AuthFailure({required this.errorMessage});
}

class LogoutState extends AuthState {}

class AuthLoading extends AuthState {}
