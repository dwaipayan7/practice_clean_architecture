import 'package:flutter/material.dart';
import 'package:practice_clean_architecture/cors/theme/app_pallete.dart';
import 'package:practice_clean_architecture/features/auth/presentation/widget/auth_field.dart';

import '../widget/auth_gradient_button.dart';

class SignupPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (_) => SignupPage(),
      );
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign Up.",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            AuthField(hintText: 'Name'),
            SizedBox(
              height: 15,
            ),
            AuthField(hintText: 'Email'),
            SizedBox(
              height: 15,
            ),
            AuthField(hintText: 'Password'),
            SizedBox(
              height: 20,
            ),
            AuthGradientButton(),
            SizedBox(
              height: 20,
            ),
            RichText(
              text: TextSpan(
                text: "Don't have an account? ",
                style: Theme.of(context).textTheme.titleMedium,
                children: [
                  TextSpan(
                    text: "Sign In",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppPallete.gradient2,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
