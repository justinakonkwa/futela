import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/app_text_large.dart';
import 'package:futela/widgets/bouton_next.dart';
import 'package:futela/widgets/constantes.dart';
import 'package:futela/widgets/textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController numbercontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height,
            maxWidth: double.maxFinite,

          ),
          color: Colors.brown[50],
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [
          //       Colors.blueGrey,
          //       Colors.blueGrey,
          //     ],
          //     begin: Alignment.topLeft,
          //     end: Alignment.centerRight,
          //   ),
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppTextLarge(
                        text: 'Sign in to your',
                        size: 30,
                      ),
                      AppTextLarge(
                        text: 'compte',
                        size: 30,
                      ),
                      sizedbox,
                      sizedbox,
                      AppText(
                        text: 'Sign in to your compte',
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.brown[50],
                  ),
                  width: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 25.0, horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildTextField(context,
                            controller: numbercontroller,
                            placeholder: 'Enter your number',
                            isNumber: true),
                        sizedbox,
                        sizedbox,
                        buildTextField(
                          context,
                          controller: numbercontroller,
                          placeholder: 'Enter your password',
                          isNumber: false,
                          suffix: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Icon(
                              CupertinoIcons.eye_slash,
                            ),
                          ),
                        ),
                        sizedbox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,

                          children: [
                            AppText(
                              text: 'Forgot password',
                            ),
                          ],
                        ),
                        sizedbox,
                        sizedbox,
                        sizedbox,
                        sizedbox,
                        NextButton(
                          onTap: () {},
                          color: Colors.white,
                          child: AppTextLarge(
                            text: 'Register',
                          ),
                        ),
                        sizedbox,
                        sizedbox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.30,
                              height: 1,
                              color: Colors.grey,
                            ),
                            sizedbox2,
                            AppText(text: 'Or login with'),
                            sizedbox2,
                            Container(
                              width: MediaQuery.of(context).size.width * 0.30,
                              height: 1,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        sizedbox,
                        sizedbox,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            NextButton(
                              padding: EdgeInsets.only(left: 15.0, right: 15.0),
                              width: MediaQuery.of(context).size.width * 0.4,
                              color: Colors.white,
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    height: 30,
                                    child: Image(
                                      image: AssetImage(
                                        'assets/google.png',
                                      ),
                                    ),
                                  ),
                                  AppTextLarge(
                                    text: 'Google',
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                            NextButton(
                              padding: EdgeInsets.only(left: 15.0, right: 15.0),
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width * 0.4,
                              onTap: () {},
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    alignment: Alignment.center,
                                    height: 30,
                                    child: Image(
                                      image: AssetImage(
                                        'assets/apple.png',
                                      ),
                                    ),
                                  ),
                                  AppTextLarge(
                                    text: 'Apple',
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Expanded(child: Container()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(text: 'I have an account?'),
                            GestureDetector(
                              onTap: (){
                                Navigator.pushNamed(context, '/signup');
                              },
                              child: AppText(
                                text: 'Login',
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
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
