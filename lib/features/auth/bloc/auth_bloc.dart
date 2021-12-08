import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../news_feed/model/news_model.dart';
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
    on<AnonLoginEvent>(_handleAnonLogin);
    on<LoginSuccess>(_handleLoginSuccess);
    on<LoginFailure>(_handleLoginFailure);
    on<LoginEvent>(_handleLogin);
    on<LogoutEvent>(_handleLogout);
    on<AddToBookMarkEvent>(_handleAddToBookmark);
    on<RemoveBookMarkEvent>(_handleRemoveFromBookMark);
    on<AddToHistory>(_handleAddToHistory);
    on<RemoveFromHistory>(_handleRemoveFromHistory);
    on<AddChosenCategoryEvent>(_handleChosenCatgoryEvent);
    on<RemoveChosenCategoryEvent>(_handleRemoveChosenCatgoryEvent);
    on<ResetPasswordEvent>(_handleResetPasswordEvent);
    on<ForgotPasswordEvent>(_handleForgotPasswordEvent);
  }

  _handleAppStarted(AppStartedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await for (var authEvent in authService.checkUser()) {
        if (authEvent != null) {
          final userEvent = authService.getCurrentUser(authEvent.uid);
          await for (var user in userEvent) {
            emit(AuthSuccess(currentUser: await user));
          }
          if (FirebaseAuth.instance.currentUser!.isAnonymous) {
            emit(AuthSuccess(currentUser: null));
          }
        } else {
          emit(AuthFailure(errorMessage: ''));
        }
      }
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
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
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(AuthFailure(errorMessage: "Email already in use"));
      }
      if (e.code == 'network-request-failed') {
        emit(AuthFailure(
            errorMessage: "Please check your internet connection."));
      }
    }
  }

  _handleChosenCatgoryEvent(
      AddChosenCategoryEvent event, Emitter<AuthState> emit) async {
    try {
      await authService.addChosenCategory(event.categoryList, event.user.id!);
      emit(AuthSuccess(
          currentUser: (state as AuthSuccess).currentUser!.copyWith(
              chosenCategories: List<String>.from(
                  ((state as AuthSuccess).currentUser!.chosenCategories!
                    ..addAll(event.categoryList))))));
    } catch (e, stk) {
      log('Exception', error: e, stackTrace: stk);
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  _handleRemoveChosenCatgoryEvent(
      RemoveChosenCategoryEvent event, Emitter<AuthState> emit) async {
    final currentState = state as AuthSuccess;
    try {
      final result = await authService.removeChosenCategory(
          event.category, event.user.id!);
      emit(AuthLoading());
      await for (var event in result) {
        emit(AuthSuccess(currentUser: await event));
      }
    } catch (e, stk) {
      log('Exception', error: e, stackTrace: stk);
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  _handleAddToBookmark(
      AddToBookMarkEvent event, Emitter<AuthState> emit) async {
    // emit(AuthLoading());
    try {
      final result = await authService.addToBookmarks(
          event.newsToBookmark, event.user.id!);
      emit(AuthSuccess(
          currentUser: event.user.copyWith(
              bookmarks: event.user.bookmarks!..add(event.newsToBookmark))));
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  _handleRemoveFromBookMark(
      RemoveBookMarkEvent event, Emitter<AuthState> emit) async {
    // emit(AuthLoading());
    try {
      final result = await authService.addToBookmarks(
          event.newsToBookmark, event.user.id!);
      emit(AuthSuccess(
          currentUser: event.user.copyWith(
              bookmarks: event.user.bookmarks!..remove(event.newsToBookmark))));
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  _handleResetPasswordEvent(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    // emit(AuthLoading());
    try {
      if (event.confirmPassword == event.password) {
        emit(AuthSuccess(currentUser: event.user));
        await authService.resetPassword(event.password);
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  _handleAddToHistory(AddToHistory event, Emitter<AuthState> emit) async {
    try {
      emit(AuthSuccess(currentUser: event.user));
      await authService.addToHistory(event.newsModel, event.user.id!);
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  _handleRemoveFromHistory(
      RemoveFromHistory event, Emitter<AuthState> emit) async {
    try {
      emit(AuthSuccess(currentUser: event.user));

      await authService.removeFromHistory(event.newsModel, event.user.id!);
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
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
    } on FirebaseAuthException catch (e, stk) {
      log(e.toString(), stackTrace: stk);
      if (e.code == "network-request-failed") {
        emit(AuthFailure(errorMessage: "Please Check your network connection"));
      }
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
    } on FirebaseAuthException catch (e, stk) {
      log(e.toString(), stackTrace: stk);
      if (e.code == "network-request-failed") {
        emit(AuthFailure(errorMessage: "Please Check your network connection"));
      }
      if (e.code == "user-not-found") {
        emit(AuthFailure(
            errorMessage: "No account with given email address exists"));
      }
      if (e.code == "wrong-password") {
        emit(AuthFailure(errorMessage: "Incorrect credentials were provided"));
      }
    }
  }

  _handleAnonLogin(AnonLoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await authService.anonSignUp();
      if (result != null) {
        emit(AuthSuccess(currentUser: null));
      } else {
        emit(AuthFailure(errorMessage: 'Error when in signing in anonymously'));
      }
    } catch (e, stk) {
      log('Error when signing in anonymously', error: e, stackTrace: stk);
    }
  }

  _handleLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      authService.logout();
      emit(LogoutState());
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
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
    return emit(AuthFailure(errorMessage: "Login Failed"));
  }

  _handleForgotPasswordEvent(
      ForgotPasswordEvent event, Emitter<AuthState> emit) {
    try {
      authService.forgotPassword(event.email);
    } catch (e, stk) {
      log('Error sending email:', error: e, stackTrace: stk);
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }
}
