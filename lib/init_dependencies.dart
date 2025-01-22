import 'package:get_it/get_it.dart';
import 'package:practice_clean_architecture/cors/common/app_user/cubits/app_user_cubit.dart';
import 'package:practice_clean_architecture/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:practice_clean_architecture/features/auth/data/repository/auth_repository_impl.dart';
import 'package:practice_clean_architecture/features/auth/domain/repository/auth_repository.dart';
import 'package:practice_clean_architecture/features/auth/domain/usecase/current_user.dart';
import 'package:practice_clean_architecture/features/auth/domain/usecase/user_login.dart';
import 'package:practice_clean_architecture/features/auth/domain/usecase/user_signup.dart';
import 'package:practice_clean_architecture/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:practice_clean_architecture/features/blog/data/datasources/blog_remote_datasources.dart';
import 'package:practice_clean_architecture/features/blog/data/repositories/blog_repository_impl.dart';
import 'package:practice_clean_architecture/features/blog/domain/repositories/blog_repositories.dart';
import 'package:practice_clean_architecture/features/blog/domain/usecases/upload_blog.dart';
import 'package:practice_clean_architecture/features/blog/presentation/bloc/blog_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'cors/secrets/app_secrets.dart';
import 'features/blog/domain/usecases/get_all_blogs.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initBlog();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseURL,
    anonKey: AppSecrets.supabaseanonKey,
  );

  serviceLocator.registerLazySingleton(() => supabase.client);

  //core
  serviceLocator.registerLazySingleton(() => AppUserCubit());
}

void _initAuth() {
  //data source
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        supabaseClient: serviceLocator(),
      ),
    )

    //repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: serviceLocator(),
      ),
    )

    //usecase
    ..registerFactory(
      () => UserSignUp(
        repository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        authRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        authRepository: serviceLocator(),
      ),
    )
    //bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignup: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initBlog() {
  //DataSource
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
      () => BlogRemoteDataSourceImpl(
        supabaseClient: serviceLocator(),
      ),
    )

    //Repository
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImpl(
        blogRemoteDataSource: serviceLocator(),
      ),
    )
    //Usecase
    ..registerFactory(
      () => UploadBlog(
        repository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllBlogs(
        blogRepository: serviceLocator(),
      ),
    )
    //Bloc
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}
