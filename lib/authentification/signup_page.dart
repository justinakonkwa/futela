import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:futela/authentification/login_page.dart';
import 'package:futela/authentification/signup_page.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/app_text_large.dart';
import 'package:futela/widgets/bouton_next.dart';
import 'package:futela/widgets/constantes.dart';
import 'package:futela/widgets/textfield.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool visibility = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.brown[50],
            ),
            padding: const EdgeInsets.only(
                left: 15.0, right: 15.0, top: 10, bottom: 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 8,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    AppTextLarge(
                      text: "SIGNUP",
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 20.0,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {Navigator.pop(context);},
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
                    text: 'Sign in to your compte',
                  ),
                ),
                const SizedBox(height: 30),

                buildTextField(
                  context,
                  controller: _nameController,
                  placeholder: 'Enter your password',
                  isNumber: false,
                  suffix: const Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      CupertinoIcons.eye_slash,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                buildTextField(context,
                    controller: _phoneNumberController,
                    placeholder: 'Enter your number',
                    isNumber: true),
                const SizedBox(height: 20),
                buildTextField(
                  context,
                  controller: _passwordController,
                  placeholder: 'Enter your password',
                  isNumber: false,
                  suffix: const Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Icon(
                      CupertinoIcons.eye_slash,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                NextButton(
                  onTap: () {},
                  color: Colors.black,
                  child: AppTextLarge(
                    text: 'Register',
                    color: Colors.white,
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
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      width: MediaQuery.of(context).size.width * 0.4,
                      color: Colors.white,
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 30,
                            child: const Image(
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
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width * 0.4,
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: 30,
                            child: const Image(
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
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    AppText(
                        text: "I have an account?",
                        color: Theme.of(context).colorScheme.onBackground),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return const LoginPage();
                          },
                        );
                      },
                      child: AppText(
                        text: translate("Login"),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:futela/widgets/app_text.dart';
// import 'package:futela/widgets/app_text_large.dart';
// import 'package:futela/widgets/bouton_next.dart';
// import 'package:futela/widgets/constantes.dart';
// import 'package:futela/widgets/textfield.dart';
//
// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});
//
//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }
//
// class _SignupPageState extends State<SignupPage> {
//   TextEditingController numbercontroller = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.transparent,
//       body: SingleChildScrollView(
//         child: Container(
//           constraints: BoxConstraints(
//             maxHeight: MediaQuery.of(context).size.height,
//             maxWidth: double.maxFinite,
//           ),
//
//           decoration:  BoxDecoration(
//             borderRadius: BorderRadius.circular(20,), color: Colors.brown[50],
//             // gradient: LinearGradient(
//             //   colors: [
//             //     Colors.blueGrey,
//             //     Colors.blueGrey,
//             //   ],
//             //   begin: Alignment.topLeft,
//             //   end: Alignment.centerRight,
//             // ),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       // GestureDetector(
//                       //     onTap: (){
//                       //       Navigator.pushNamed(context, '/login');
//                       //     },
//                       //     child: Icon(CupertinoIcons.arrow_left)),
//                       // sizedbox,
//                       // sizedbox,
//                       AppTextLarge(
//                         text: 'Register',
//                         size: 30,
//                       ),
//                       sizedbox,
//                       AppText(
//                         text: 'Create your compte',
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 10,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                     color: Colors.brown[50],
//                   ),
//                   width: double.maxFinite,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 25.0, horizontal: 15.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         buildTextField(context,
//                             controller: numbercontroller,
//                             placeholder: 'Enter your name',
//                             isNumber: false),
//                         sizedbox,
//                         sizedbox,
//                         buildTextField(context,
//                             controller: numbercontroller,
//                             placeholder: 'Enter your number',
//                             isNumber: true),
//                         sizedbox,
//                         sizedbox,
//                         buildTextField(
//                           context,
//                           controller: numbercontroller,
//                           placeholder: 'Enter your password',
//                           isNumber: false,
//                           suffix: Padding(
//                             padding: const EdgeInsets.only(right: 15),
//                             child: Icon(
//                               CupertinoIcons.eye_slash,
//                             ),
//                           ),
//                         ),
//                         sizedbox,
//                         sizedbox,
//                         sizedbox,
//                         sizedbox,
//                         sizedbox,
//                         NextButton(
//                           onTap: () {},
//                           color: Colors.white,
//                           child: AppTextLarge(
//                             text: 'Register',
//                           ),
//                         ),
//                         sizedbox,
//                         sizedbox,
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Container(
//                               width: MediaQuery.of(context).size.width * 0.30,
//                               height: 1,
//                               color: Colors.grey,
//                             ),
//                             sizedbox2,
//                             AppText(text: 'Or login with'),
//                             sizedbox2,
//                             Container(
//                               width: MediaQuery.of(context).size.width * 0.30,
//                               height: 1,
//                               color: Colors.grey,
//                             ),
//                           ],
//                         ),
//                         sizedbox,
//                         sizedbox,
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             NextButton(
//                               padding: EdgeInsets.only(left: 15.0, right: 15.0),
//                               width: MediaQuery.of(context).size.width * 0.4,
//                               color: Colors.white,
//                               onTap: () {},
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   Container(
//                                     height: 30,
//                                     child: Image(
//                                       image: AssetImage(
//                                         'assets/google.png',
//                                       ),
//                                     ),
//                                   ),
//                                   AppTextLarge(
//                                     text: 'Google',
//                                     size: 16,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             NextButton(
//                               padding: EdgeInsets.only(left: 15.0, right: 15.0),
//                               color: Colors.white,
//                               width: MediaQuery.of(context).size.width * 0.4,
//                               onTap: () {},
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceEvenly,
//                                 children: [
//                                   Container(
//                                     alignment: Alignment.center,
//                                     height: 30,
//                                     child: Image(
//                                       image: AssetImage(
//                                         'assets/apple.png',
//                                       ),
//                                     ),
//                                   ),
//                                   AppTextLarge(
//                                     text: 'Apple',
//                                     size: 16,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                         Expanded(child: Container()),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             AppText(text: 'I have an account?'),
//                             GestureDetector(
//                               onTap: (){
//                                 Navigator.pushNamed(context, '/login');
//                               },
//                               child: AppText(
//                                 text: 'Login',
//                                 color: Colors.blue,
//                               ),
//                             ),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
