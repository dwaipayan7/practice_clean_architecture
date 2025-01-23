import 'package:fpdart/fpdart.dart';
import 'package:practice_clean_architecture/cors/error/exception.dart';
import 'package:practice_clean_architecture/cors/error/failure_dart.dart';
import 'package:practice_clean_architecture/cors/network/connection_checker.dart';
import 'package:practice_clean_architecture/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:practice_clean_architecture/features/auth/data/models/user_model.dart';
import 'package:practice_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import '../../../../cors/common/entities/user.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final ConnectionChecker connectionChecker;

  AuthRepositoryImpl(this.connectionChecker, {required this.remoteDataSource});


  @override
  Future<Either<Failure, User>> currentUser() async{
     try{
       final user = await remoteDataSource.getCurrentUserData();

       if(user == null){
         return Either.left(Failure("User not logged in!"),);
      }

       return Either.right(user);

     }catch(e){
       throw Exception(e.toString());
     }
  }

  @override
  Future<Either<Failure, User>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.loginWithEmailPassword(
        email: email,
        password: password,
      ),
    );
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    return _getUser(
      () async => await remoteDataSource.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      ),
    );
  }

  Future<Either<Failure, User>> _getUser(
      Future<UserModel> Function() fn) async {
    try {

      if(! await (connectionChecker.isConnected)){
        // return Either.left(Failure("No Internet Connection"));
        final session = remoteDataSource.currentUserSession;

        if(session == null){
          return Either.left(Failure("User not Logged in!!"));
        }

        return Either.right(UserModel(id: session.user.id, email: session.user.email ?? '', name: ''));

      }

      final user = await fn();
      return Either.right(user);
    }
    on sb.AuthException catch(e){
      return Either.left(Failure(e.toString()));
    }
    on ServerException catch (e) {
      return Either.left(Failure(e.message));
    }
  }


}
