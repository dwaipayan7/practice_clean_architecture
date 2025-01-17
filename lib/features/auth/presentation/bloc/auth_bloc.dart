import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:practice_clean_architecture/features/auth/domain/entities/user.dart';
import 'package:practice_clean_architecture/features/auth/domain/usecase/user_signup.dart';

import '../../domain/usecase/user_login.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  AuthBloc({
    required UserSignUp userSignup,
    required UserLogin userLogin,
  })  : _userSignUp = userSignup,
        _userLogin = userLogin,
        super(AuthInitial()) {
    on<AuthSignUp>((event, emit) async {

      emit(AuthLoading());

      final res = await _userSignUp(UserSignUpParams(
        name: event.name,
        email: event.email,
        password: event.password,
      ));

      res.fold(
        (failure) => emit(AuthFailure(message: failure.message)),
        (user) => emit(
          AuthSuccess(user: user),
        ),
      );
    });
  }
}
