import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:news_app/features/auth/models/user_model.dart';
import 'package:news_app/features/auth/services/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    final _authService = AuthService();
    on<RegisterEvent>((event, emit) async {
      try {
        await _authService.registerUser(event.user);
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
  }
}
