part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState{}

class AuthSuccess extends AuthState{
  final String uid;

  AuthSuccess({required this.uid});
}

class AuthFailure extends AuthState{
  final String message;

  AuthFailure({required this.message});
}
