import 'package:fpdart/fpdart.dart';
import 'package:practice_clean_architecture/cors/error/exception.dart';
import 'package:practice_clean_architecture/cors/error/failure_dart.dart';
import 'package:practice_clean_architecture/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:practice_clean_architecture/features/auth/data/models/user_model.dart';
import 'package:practice_clean_architecture/features/auth/domain/entities/user.dart';
import 'package:practice_clean_architecture/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(() async =>
    await remoteDataSource.loginWithEmailPassword(email: email, password: password),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(() async =>
    await remoteDataSource.signUpWithEmailPassword(name: name, email: email, password: password),
    );
  }

  Future<Either<Failure, User>> _getUser(Future<UserModel> Function() fn) async {
    try {
      final user = await fn();
      return Either.right(user);
    } on ServerException catch (e) {
      return Either.left(Failure(e.message));
    }
  }
}
