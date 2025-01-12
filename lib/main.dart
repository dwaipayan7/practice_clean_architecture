import 'package:flutter/material.dart';
import 'package:practice_clean_architecture/cors/secrets/app_secrets.dart';
import 'package:practice_clean_architecture/cors/theme/app_theme.dart';
import 'package:practice_clean_architecture/features/auth/presentation/pages/login_page.dart';
import 'package:practice_clean_architecture/features/auth/presentation/pages/signup_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
 final supabase = await Supabase.initialize(url: AppSecrets.supabaseURL, anonKey: AppSecrets.supabaseanonKey);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

