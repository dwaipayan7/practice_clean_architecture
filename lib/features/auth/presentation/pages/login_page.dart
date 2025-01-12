import 'package:flutter/material.dart';
import 'package:practice_clean_architecture/features/auth/presentation/pages/signup_page.dart';

import '../../../../cors/theme/app_pallete.dart';
import '../widget/auth_field.dart';
import '../widget/auth_gradient_button.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign In.",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            AuthField(hintText: 'Email', controller: emailController,),
            SizedBox(
              height: 15,
            ),
            AuthField(hintText: 'Password', controller: passwordController,),
            SizedBox(
              height: 20,
            ),
            AuthGradientButton(onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignupPage()));
            }, buttonText: 'Sign Up',),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, SignupPage.route());
              },
              child: RichText(
                text: TextSpan(
                    text: "Don't have an account? ",
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: "Sign Up",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: AppPallete.gradient2,
                            fontWeight: FontWeight.bold
                        ),
                      )
                    ]
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
