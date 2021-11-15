import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:news_app/features/auth/models/user_model.dart';
import 'package:news_app/features/auth/services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _authService = AuthService();

  AuthBloc() : super(AuthInitial()) {
    on<AppStartedEvent>((event, emit) async {
      try {
        _authService.checkUser().listen((authEvent) async {
          if (authEvent != null) {
            final user = await _authService.getCurrentUser(authEvent.uid);
            emit(AuthSuccess(currentUser: user));
          } else {
            emit(AuthFailure());
          }
        });
      } catch (e) {
        emit(AuthFailure());
      }
    });

    on<RegisterEvent>((event, emit) async {
      try {
        final result = await _authService.registerUser(event.user);
        // add(LoginEvent(user: event.user));

        emit(AuthSuccess(currentUser: result));
      } catch (e) {
        emit(AuthFailure());
      }
    });

    on<LoginSuccess>((event, emit) async {
      final result = await _authService.getCurrentUser(event.user.uid);
      emit(AuthSuccess(currentUser: result));
    });
    on<LoginFailure>((event, emit) => AuthFailure());
    on<LoginEvent>((event, emit) async {
      try {
        final result = await _authService.login(event.user);
        emit(AuthSuccess(currentUser: result));
      } catch (e) {
        emit(AuthFailure());
      }
    });

    on<LogoutEvent>((event, emit) async {
      try {
        _authService.logout();
        emit(LogoutState());
      } catch (e) {
        emit(AuthFailure());
      }
    });
  }
}
