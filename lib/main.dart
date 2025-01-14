import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_clean_architecture/cors/secrets/app_secrets.dart';
import 'package:practice_clean_architecture/cors/theme/app_theme.dart';
import 'package:practice_clean_architecture/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:practice_clean_architecture/features/auth/data/repository/auth_repository_impl.dart';
import 'package:practice_clean_architecture/features/auth/domain/usecase/user_signup.dart';
import 'package:practice_clean_architecture/features/auth/presentation/pages/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final supabase = await Supabase.initialize(
      url: AppSecrets.supabaseURL, anonKey: AppSecrets.supabaseanonKey);

  runApp(MultiBlocProvider(providers: [
    BlocProvider(
      create: (_) => AuthBloc(
        userSignup: UserSignUp(
          repository: AuthRepositoryImpl(
            remoteDataSource:
                AuthRemoteDataSourceImpl(supabaseClient: supabase.client),
          ),
        ),
      ),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Bloc Clean Architecture',
      theme: AppTheme.darkThemeMode,
      home: LoginPage(),
    );
  }
}
