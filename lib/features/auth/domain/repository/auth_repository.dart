import 'package:fpdart/fpdart.dart';
import 'package:practice_clean_architecture/cors/error/failure_dart.dart';
import 'package:practice_clean_architecture/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  });

}
