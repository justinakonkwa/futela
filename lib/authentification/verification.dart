
import 'package:flutter/material.dart';
import 'package:futela/main_page.dart';
import 'package:futela/modeles/user_provider.dart';
import 'package:futela/pages/intro_screens/Intro.dart';
import 'package:provider/provider.dart';

class AuthVerification extends StatefulWidget {
  const AuthVerification({Key? key}) : super(key: key);

  @override
  State<AuthVerification> createState() => _AuthVerificationState();
}

class _AuthVerificationState extends State<AuthVerification> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoggedIn) {
            return const MainPage();
          } else {
            return const Intro();
          }
        },
      ),
    );
  }
}
