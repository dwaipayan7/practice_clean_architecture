import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:practice_clean_architecture/cors/common/app_user/cubits/app_user_cubit.dart';
import 'package:practice_clean_architecture/cors/usecase/usercase.dart';
import 'package:practice_clean_architecture/features/auth/domain/usecase/current_user.dart';
import 'package:practice_clean_architecture/features/auth/domain/usecase/user_signup.dart';
import '../../../../cors/common/entities/user.dart';
import '../../domain/usecase/user_login.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc(
      {required UserSignUp userSignup,
      required UserLogin userLogin,
      required CurrentUser currentUser,
      required AppUserCubit appUserCubit
      })
      : _userSignUp = userSignup,
        _userLogin = userLogin,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthSignUp>(_onAuthSignUp);
    on<AuthLogin>(_onAuthLogin);
    on<AuthIsUserLoggedIn>(_isUserLoggedIn);

  }

  void _isUserLoggedIn(
      AuthIsUserLoggedIn event, Emitter<AuthState> emit) async {
    final res = await _currentUser(NoParams());

    res.fold(
      (l) => emit(AuthFailure(message: l.message)),
      (r) {
        print(r.name);
        print(r.email);
        _emitAuthSuccess(r, emit);
      }
    );
  }

  FutureOr<void> _onAuthSignUp(
      AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final res = await _userSignUp(UserSignUpParams(
      name: event.name,
      email: event.email,
      password: event.password,
    ));

    res.fold(
      (failure) => emit(AuthFailure(message: failure.message)),
      (user) => _emitAuthSuccess(user, emit),
    );
  }

  FutureOr<void> _onAuthLogin(AuthLogin event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final res = await _userLogin(
      UserLoginParams(
        email: event.email,
        password: event.password,
      ),
    );

    res.fold(
      (l) => emit(AuthFailure(message: l.message)),
      (r) => _emitAuthSuccess(r, emit)
    );
  }

  void _emitAuthSuccess(User user, Emitter<AuthState> emit){
    emit(AuthLoading());
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user),);
  }

}
