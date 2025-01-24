part of 'init_dependencies.dart';


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