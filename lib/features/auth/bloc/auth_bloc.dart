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
          emit(AuthFailure(errorMessage: "No user"));
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
          currentUser: event.user.copyWith(
              chosenCategories: event.user.chosenCategories!
                ..addAll(event.categoryList))));
    } catch (e, stk) {
      log('Exception', error: e, stackTrace: stk);
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  _handleRemoveChosenCatgoryEvent(
      RemoveChosenCategoryEvent event, Emitter<AuthState> emit) async {
    try {
      await authService.removeChosenCategory(event.category, event.user.id!);
      emit(AuthSuccess(
          currentUser: event.user.copyWith(
              chosenCategories: event.user.chosenCategories!
                ..remove(event.category))));
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
        await authService.resetPassword(event.password);
        emit(AuthSuccess(currentUser: event.user));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  _handleAddToHistory(AddToHistory event, Emitter<AuthState> emit) async {
    try {
      final result =
          await authService.addToHistory(event.newsModel, event.user.id!);
      // add(LoginEvent(user: event.user));
      emit(AuthSuccess(
          currentUser: event.user
              .copyWith(bookmarks: event.user.history!..add(event.newsModel))));
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  _handleRemoveFromHistory(
      RemoveFromHistory event, Emitter<AuthState> emit) async {
    // emit(AuthLoading());
    try {
      final result =
          await authService.removeFromHistory(event.newsModel, event.user.id!);
      // add(LoginEvent(user: event.user));
      emit(AuthSuccess(
          currentUser: event.user.copyWith(
              bookmarks: event.user.history!..remove(event.newsModel))));
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
}
