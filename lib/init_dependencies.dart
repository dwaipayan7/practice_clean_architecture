
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cors/common/app_user/cubits/app_user_cubit.dart';
import 'cors/network/connection_checker.dart';
import 'cors/secrets/app_secrets.dart';
import 'features/auth/data/datasources/auth_remote_data_source.dart';
import 'features/auth/data/repository/auth_repository_impl.dart';
import 'features/auth/domain/repository/auth_repository.dart';
import 'features/auth/domain/usecase/current_user.dart';
import 'features/auth/domain/usecase/user_login.dart';
import 'features/auth/domain/usecase/user_signup.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/blog/data/datasources/blog_local_datasource.dart';
import 'features/blog/data/datasources/blog_remote_datasources.dart';
import 'features/blog/data/repositories/blog_repository_impl.dart';
import 'features/blog/domain/repositories/blog_repositories.dart';
import 'features/blog/domain/usecases/get_all_blogs.dart';
import 'features/blog/domain/usecases/upload_blog.dart';
import 'features/blog/presentation/bloc/blog_bloc.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseURL,
    anonKey: AppSecrets.supabaseanonKey,
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerFactory(
        () => InternetConnection(),
  );

  _initAuth();

  _initBlog();

  //core
  serviceLocator.registerLazySingleton(
        () => AppUserCubit(),
  );

  serviceLocator.registerFactory<ConnectionChecker>(
        () => ConnectionCheckerImpl(
       internetConnection: serviceLocator(),
    ),
  );
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
      supabaseClient: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory<AuthRepository>(
        () => AuthRepositoryImpl(
        remoteDataSource: serviceLocator(), serviceLocator()),
  );

  serviceLocator.registerFactory(
        () => UserSignUp(
       repository: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
        () => UserLogin(
       authRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerFactory(
        () => CurrentUser(
      authRepository: serviceLocator(),
    ),
  );

  serviceLocator.registerLazySingleton(
        () => AuthBloc(
      userLogin: serviceLocator(),
      currentUser: serviceLocator(),
      appUserCubit: serviceLocator(), userSignup: serviceLocator(),
    ),
  );
}

void _initBlog() {
  //Data source
  serviceLocator
    ..registerFactory<BlogRemoteDataSource>(
          () => BlogRemoteDataSourceImpl(
        supabaseClient: serviceLocator(),
      ),
    )
    ..registerFactory<BlogLocalDataSource>(
          () => BlogLocalDataSourceImpl(
         box: serviceLocator(),
      ),
    )

  //repository
    ..registerFactory<BlogRepository>(
          () => BlogRepositoryImpl(
       serviceLocator(),
          serviceLocator(),
          serviceLocator()),
    )
  //usecase
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
  //bloc
    ..registerLazySingleton(
          () => BlogBloc(
        uploadBlog: serviceLocator(),
        getAllBlogs: serviceLocator(),
      ),
    );
}