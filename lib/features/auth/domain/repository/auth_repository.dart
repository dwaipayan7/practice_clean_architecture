import 'package:fpdart/fpdart.dart';
import 'package:practice_clean_architecture/cors/error/failure_dart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, String>> loginWithEmailPassword({
    required String email,
    required String password,
  });

}
