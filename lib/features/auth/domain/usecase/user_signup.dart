import 'package:fpdart/fpdart.dart';
import 'package:practice_clean_architecture/cors/error/failure_dart.dart';
import 'package:practice_clean_architecture/cors/usecase/usercase.dart';
import 'package:practice_clean_architecture/features/auth/domain/repository/auth_repository.dart';

import '../../../../cors/common/entities/user.dart';

class UserSignUp implements UseCase<User, UserSignUpParams> {
  final AuthRepository repository;

  UserSignUp({required this.repository});

  @override
  Future<Either<Failure, User>> call(UserSignUpParams params) async {
   return await repository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String name;
  final String email;
  final String password;

  UserSignUpParams({
    required this.name,
    required this.email,
    required this.password,
  });
}
