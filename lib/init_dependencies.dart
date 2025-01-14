import 'package:get_it/get_it.dart';
import 'package:practice_clean_architecture/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:practice_clean_architecture/features/auth/data/repository/auth_repository_impl.dart';
import 'package:practice_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:practice_clean_architecture/features/auth/domain/usecase/user_signup.dart';
import 'package:practice_clean_architecture/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'cors/secrets/app_secrets.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseURL,
    anonKey: AppSecrets.supabaseanonKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);
}

void _initAuth() {
  //data source
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      supabaseClient: serviceLocator(),
    ),
  );

  //repository
  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: serviceLocator(),
    ),
  );

  //usecase
  serviceLocator.registerFactory(
    () => UserSignUp(
      repository: serviceLocator(),
    ),
  );

  //bloc
  serviceLocator.registerLazySingleton(
    () => AuthBloc(
      userSignup: serviceLocator(),
    ),
  );
}
