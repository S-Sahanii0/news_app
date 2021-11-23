import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:news_app/features/news_feed/services/news_service.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<AppStartedEvent>(_handleAppStarted);
    on<RegisterEvent>(_handleRegister);
    on<GoogleSignInEvent>(_handleGoogleSignIn);
    // on<FacebookSignInEvent>(_handleGoogleSignIn);
    on<LoginSuccess>(_handleLoginSuccess);
    on<LoginFailure>(_handleLoginFailure);
    on<LoginEvent>(_handleLogin);
    on<LogoutEvent>(_handleLogout);
  }

  _handleAppStarted(AppStartedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // NewsService().listenToChannelEvent();
      await for (var authEvent in authService.checkUser()) {
        if (authEvent != null) {
          final userEvent = authService.getCurrentUser(authEvent.uid);
          await for (var user in userEvent) {
            emit(AuthSuccess(currentUser: await user));
          }
        } else {
          emit(AuthFailure());
        }
      }
    } catch (e) {
      emit(AuthFailure());
    }
  }

  _handleRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await authService.registerUser(event.user);
      // add(LoginEvent(user: event.user));
      await for (var event in result) {
        emit(AuthSuccess(currentUser: await event));
      }
    } catch (e) {
      emit(AuthFailure());
    }
  }

  _handleGoogleSignIn(GoogleSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await authService.signInWithGoogle();
      // add(LoginEvent(user: event.user));
      await for (var event in result) {
        emit(AuthSuccess(currentUser: await event));
      }
    } catch (e) {
      emit(AuthFailure());
    }
  }

  // _handleFacebookSignIn(
  //     FacebookSignInEvent event, Emitter<AuthState> emit) async {
  //   emit(AuthLoading());
  //   try {
  //     final result = await authService.signInWithFacebook();
  //     // add(LoginEvent(user: event.user));
  //     await for (var event in result) {
  //       emit(AuthSuccess(currentUser: await event));
  //     }
  //   } catch (e) {
  //     emit(AuthFailure());
  //   }
  // }

  _handleLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await authService.login(event.user);
      await for (var event in result) {
        emit(AuthSuccess(currentUser: await event));
      }
    } catch (e) {
      emit(AuthFailure());
    }
  }

  _handleLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      authService.logout();
      emit(LogoutState());
    } catch (e) {
      emit(AuthFailure());
    }
  }

  _handleLoginSuccess(LoginSuccess event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authService.getCurrentUser(event.user.uid);
    await for (var event in result) {
      emit(AuthSuccess(currentUser: await event));
    }
  }

  _handleLoginFailure(AuthEvent event, Emitter<AuthState> emit) async {
    return emit(AuthFailure());
  }
}
