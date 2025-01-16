import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futela/authentification/login_page.dart';
import 'package:futela/modeles/user_provider.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/app_text_large.dart';
import 'package:futela/widgets/bouton_next.dart';
import 'package:futela/widgets/textfield.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _gender;
  bool _isCommissioner = false;
  bool _isLandlord = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Provider.of<UserProvider>(context, listen: false).register(
          name: _nameController.text,
          lastname: _lastnameController.text,
          firstname: _firstnameController.text,
          phoneNumber: _phoneNumberController.text,
          gender: _gender!,
          password: _passwordController.text,
          commissioner: _isCommissioner,
          landlord: _isLandlord,
          context: context,
        );
        Navigator.pushReplacementNamed(context, '/AuthVerification');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
                  text: "S'INSCRIRE",
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
                text: "S'inscrire pour se connecter a votre compte",
              ),
            ),
            const SizedBox(height: 30),
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildTextField(
                        context,
                        controller: _nameController,
                        placeholder: 'Nom',
                        isNumber: false,
                        errorText: 'Ce champ est obligatoire',
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        context,
                        controller: _lastnameController,
                        placeholder: 'Prénom',
                        isNumber: false,
                        errorText: 'Ce champ est obligatoire',
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        context,
                        controller: _firstnameController,
                        placeholder: 'Deuxième prénom',
                        isNumber: false,
                        errorText: 'Ce champ est obligatoire',
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        context,
                        controller: _phoneNumberController,
                        placeholder: 'Numéro de téléphone',
                        isNumber: true,
                        errorText: 'Ce champ est obligatoire',
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.only(left: 15, right: 15.0),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                            hintText: 'Genre',
                            border: InputBorder.none,
                          ),
                          value: _gender,
                          items: const [
                            DropdownMenuItem(
                              value: 'Homme',
                              child: Text('Homme'),
                            ),
                            DropdownMenuItem(
                              value: 'Femme',
                              child: Text('Femme'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                          validator: (value) => value == null
                              ? 'Veuillez sélectionner un genre'
                              : null,
                        ),
                      ),
                      const SizedBox(height: 16),
                      buildTextField(
                        context,
                        controller: _passwordController,
                        placeholder: 'Mot de passe',
                        isNumber: false,
                        obscureText: true,
                        errorText: 'Ce champ est obligatoire',
                        onChanged: (value) {},
                        suffix: const Padding(
                          padding: EdgeInsets.only(right: 15),
                          child: Icon(CupertinoIcons.eye_slash),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('Êtes-vous un commissaire ?'),
                        value: _isCommissioner,
                        onChanged: (value) {
                          setState(() {
                            _isCommissioner = value;
                          });
                        },
                      ),
                      SwitchListTile(
                        title: const Text('Êtes-vous un propriétaire ?'),
                        value: _isLandlord,
                        onChanged: (value) {
                          setState(() {
                            _isLandlord = value;
                          });
                        },
                      ),
                      const SizedBox(height: 32),
                      NextButton(
                        color: Theme.of(context).colorScheme.primary,
                        onTap: _submitForm,
                        child: AppText(
                          text: "S\'inscrire",
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          AppText(
                              text: "Avez-vous un compte?",
                              color:
                                  Theme.of(context).colorScheme.onBackground),
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
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    child: LoginPage(),
                                  );
                                },
                              );
                            },
                            child: AppText(
                              text: 'Se connecter',
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
