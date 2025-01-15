import 'package:fpdart/fpdart.dart';
import 'package:practice_clean_architecture/cors/error/exception.dart';
import 'package:practice_clean_architecture/cors/error/failure_dart.dart';
import 'package:practice_clean_architecture/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:practice_clean_architecture/features/auth/data/models/user_model.dart';
import 'package:practice_clean_architecture/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserModel>> loginWithEmailPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement loginWithEmailPassword
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserModel>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
    final user = await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );

    return Either.right(user);

    } on ServerException catch (e) {
     return Either.left(Failure(e.message));
    }
  }
}
