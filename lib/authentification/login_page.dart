import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:futela/main_page.dart';
import 'package:futela/modeles/user_provider.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/app_text_large.dart';
import 'package:futela/widgets/bouton_next.dart';
import 'package:futela/widgets/constantes.dart';
import 'package:futela/widgets/textfield.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final Function? onLoginSuccess;

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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: AppText(text: 'Connexion'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context)
              .viewInsets
              .bottom, // Ajuste le padding en bas
        ),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 10, bottom: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 8,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: AppTextLarge(
                  text: "BIENVENUE SUR FUTELA",
                  color: Theme.of(context).colorScheme.onBackground,
                  size: 18.0,
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),

              Container(
                alignment: Alignment.topLeft,
                child: AppText(
                  text: 'Numéro',
                ),
              ),
              sizedbox,
              buildTextField(
                context,
                controller: _usernameController,
                placeholder: 'Entrer votre nom d\'utilisateur',
                isNumber: false,
              ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.topLeft,
                child: AppText(
                  text: 'Mot de passe',
                ),
              ),
              sizedbox,
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
              const SizedBox(height: 50),
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
                      MaterialPageRoute(builder: (context) => const MainPage()),
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              userProvider.errorMessage ?? 'Login failed.')),
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
                  style: const TextStyle(color: Colors.red),
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
                      Navigator.pushNamed(context, '/signup');
                      // showModalBottomSheet(
                      //   scrollControlDisabledMaxHeightRatio:
                      //       MediaQuery.of(context).size.height * 0.9,
                      //   context: context,
                      //   builder: (BuildContext context) {
                      //     return Container(
                      //         color: Colors.transparent,
                      //         height: MediaQuery.of(context).size.height * 1,
                      //         child: SignUpPage());
                      //   },
                      // );
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
      ),
    );
  }
}
