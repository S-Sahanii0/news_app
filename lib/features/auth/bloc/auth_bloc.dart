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
    (_authService.checkUser().listen((event) async {
      if (event == null) {
        add(LoginFailure());
      } else {
        final result = await _authService.getCurrentUser(event.uid);
        add(LoginSuccess(user: result));
      }
    }));
    on<RegisterEvent>((event, emit) async {
      try {
        final result = await _authService.registerUser(event.user);
        // add(LoginEvent(user: event.user));
        emit(AuthSuccess(currentUser: result));
      } catch (e) {
        emit(AuthFailure());
      }
    });

    on<LoginSuccess>((event, emit) => AuthSuccess(currentUser: event.user));
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
