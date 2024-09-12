import 'package:flutter/material.dart';
import 'package:futela/widgets/app_text.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AppText(
          text: 'login page',
        ),
      ),
    );
  }
}
