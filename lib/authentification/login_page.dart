import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:futela/authentification/signup_page.dart';
import 'package:futela/main_page.dart';
import 'package:futela/modeles/user_provider.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/app_text_large.dart';
import 'package:futela/widgets/bouton_next.dart';
import 'package:futela/widgets/constantes.dart';
import 'package:futela/widgets/textfield.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final Function? onLoginSuccess; // Paramètre de rappel

  const LoginPage({Key? key, this.onLoginSuccess}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool visibility = false;
  bool isLoading = false;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context)
            .viewInsets
            .bottom, // Ajuste le padding en bas
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        padding:
            const EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.center,
              height: 8,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.black,
              ),
            ),
            Row(
              children: [
                AppTextLarge(
                  text: "SE CONNECTER",
                  color: Theme.of(context).colorScheme.onBackground,
                  size: 20.0,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.red,
                    size: 30,
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.topLeft,
              child: AppText(
                text: 'Se conncter a votre compte',
              ),
            ),
            const SizedBox(height: 30),
            buildTextField(
              context,
              controller: _usernameController,
              placeholder: 'Entrer votre nom d\'utilisateur',
              isNumber: false,
            ),
            const SizedBox(height: 20),
            buildTextField(
              context,
              controller: _passwordController,
              placeholder: 'Entrer votre mot de passe',
              isNumber: false,
              suffix: const Padding(
                padding: EdgeInsets.only(right: 15),
                child: Icon(CupertinoIcons.eye_slash),
              ),
            ),
            const SizedBox(height: 20),
            NextButton(
              onTap: () async {
                setState(() => isLoading = true);
                await userProvider.login(
                  _usernameController.text,
                  _passwordController.text,
                );
                setState(() => isLoading = false);

                if (userProvider.isLoggedIn) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MainPage()),
                    (Route<dynamic> route) => false,
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text(userProvider.errorMessage ?? 'Login failed.')),
                  );
                }
              },
              color: Theme.of(context).colorScheme.primary,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : AppText(
                      text: 'Se connceter',
                      color: Colors.white,
                    ),
            ),
            if (userProvider.errorMessage != null)
              Text(
                userProvider.errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            sizedbox,
            sizedbox,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Container(
            //       width: MediaQuery.of(context).size.width * 0.30,
            //       height: 1,
            //       color: Colors.grey,
            //     ),
            //     sizedbox2,
            //     AppText(text: 'Or login with'),
            //     sizedbox2,
            //     Container(
            //       width: MediaQuery.of(context).size.width * 0.30,
            //       height: 1,
            //       color: Colors.grey,
            //     ),
            //   ],
            // ),
            // sizedbox,
            // sizedbox,
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     NextButton(
            //       padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            //       width: MediaQuery.of(context).size.width * 0.4,
            //       color: Theme.of(context).highlightColor,
            //       onTap: () {},
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         children: [
            //           Container(
            //             height: 30,
            //             child: const Image(
            //               image: AssetImage(
            //                 'assets/google.png',
            //               ),
            //             ),
            //           ),
            //           AppTextLarge(
            //             text: 'Google',
            //             size: 16,
            //           ),
            //         ],
            //       ),
            //     ),
            //     NextButton(
            //       padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            //       color: Theme.of(context).highlightColor,
            //       width: MediaQuery.of(context).size.width * 0.4,
            //       onTap: () {},
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         children: [
            //           Container(
            //             alignment: Alignment.center,
            //             height: 30,
            //             child: const Image(
            //               image: AssetImage(
            //                 'assets/apple.png',
            //               ),
            //             ),
            //           ),
            //           AppTextLarge(
            //             text: 'Apple',
            //             size: 16,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                AppText(
                    text: "Vous n'avez pas de compte?",
                    color: Theme.of(context).colorScheme.onBackground),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      scrollControlDisabledMaxHeightRatio:
                          MediaQuery.of(context).size.height * 0.2,
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          color: Colors.transparent,
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: SignUpPage());
                      },
                    );
                  },
                  child: AppText(
                    text: translate("S'inscrire"),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
