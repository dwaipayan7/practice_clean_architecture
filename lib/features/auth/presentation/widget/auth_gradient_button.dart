import 'package:flutter/material.dart';

import '../../../../cors/theme/app_pallete.dart';

class AuthGradientButton extends StatelessWidget {
  final VoidCallback onTap;
  final String buttonText;
  const AuthGradientButton({super.key, required this.onTap, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppPallete.gradient1, AppPallete.gradient2],
        ),
        borderRadius: BorderRadius.circular(7)
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          fixedSize: Size(395, 55),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,

        ),
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
