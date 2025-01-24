import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_clean_architecture/cors/common/widgets/loader.dart';
import 'package:practice_clean_architecture/cors/error/failure_dart.dart';
import 'package:practice_clean_architecture/cors/theme/app_pallete.dart';
import 'package:practice_clean_architecture/cors/utils/show_snackbar.dart';
import 'package:practice_clean_architecture/features/auth/presentation/pages/login_page.dart';
import 'package:practice_clean_architecture/features/auth/presentation/widget/auth_field.dart';
import '../../../blog/presentation/pages/blog_page.dart';
import '../bloc/auth_bloc.dart';
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
    // formKey.currentState!.validate();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
           if(state is AuthFailure){

           }
          },
          builder: (context, state) {

            if(state is AuthLoading){
                return Loader();
            }
            
            if(state is AuthFailure){
              showSnackBar(context, state.message);
            }else if (state is AuthSuccess) {
              Navigator.pushAndRemoveUntil(
                context,
                BlogPage.route(),
                    (route) => false,
              );
            }

            return Form(
              key: formKey,
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
                  AuthField(
                    hintText: 'Name',
                    controller: nameController,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  AuthField(
                    hintText: 'Email',
                    controller: emailController,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  AuthField(
                    hintText: 'Password',
                    controller: passwordController,
                    isObscureText: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  AuthGradientButton(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              AuthSignUp(
                                name: nameController.text.trim(),
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              ),
                            );
                      }
                    },
                    buttonText: 'Sign Up',
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, LoginPage.route());
                    },
                    child: RichText(
                      text: TextSpan(
                          text: "Already have an account? ",
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: "Sign In",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: AppPallete.gradient2,
                                      fontWeight: FontWeight.bold),
                            )
                          ]),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
