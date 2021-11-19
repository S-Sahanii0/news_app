import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _authService = AuthService();

  AuthBloc() : super(AuthInitial()) {
    on<AppStartedEvent>(_handleAppStarted);
    on<RegisterEvent>(_handleRegister);
    on<LoginSuccess>(_handleLoginSuccess);
    on<LoginFailure>(_handleLoginFailure);
    on<LoginEvent>(_handleLogin);
    on<LogoutEvent>(_handleLogout);
  }

  _handleAppStarted(AppStartedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await for (var authEvent in _authService.checkUser()) {
        if (authEvent != null) {
          final user = await _authService.getCurrentUser(authEvent.uid);
          emit(AuthSuccess(currentUser: user));
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
      final result = await _authService.registerUser(event.user);
      // add(LoginEvent(user: event.user));

      emit(AuthSuccess(currentUser: result));
    } catch (e) {
      emit(AuthFailure());
    }
  }

  _handleLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final result = await _authService.login(event.user);
      emit(AuthSuccess(currentUser: result));
    } catch (e) {
      emit(AuthFailure());
    }
  }

  _handleLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      _authService.logout();
      emit(LogoutState());
    } catch (e) {
      emit(AuthFailure());
    }
  }

  _handleLoginSuccess(LoginSuccess event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _authService.getCurrentUser(event.user.uid);
    emit(AuthSuccess(currentUser: result));
  }

  _handleLoginFailure(AuthEvent event, Emitter<AuthState> emit) async {
    return emit(AuthFailure());
  }
}
