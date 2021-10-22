import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:news_app/features/auth/models/user_model.dart';
import 'package:news_app/features/auth/services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final _authService = AuthService();

  AuthBloc() : super(AuthInitial()) {
    on<RegisterEvent>((event, emit) async {
      try {
        await _authService.registerUser(event.user);
        // add(LoginEvent(user: event.user));
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure());
      }
    });

    on<LoginEvent>((event, emit) async {
      try {
        await _authService.login(event.user);
        emit(AuthSuccess());
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
