import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futela/authentification/login_page.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/app_text_large.dart';
import 'package:futela/widgets/bouton_next.dart';
import 'package:futela/widgets/constantes.dart';
import 'package:futela/widgets/textfield.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // Controllers pour les champs
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _coverImageBase64 = ''; // Variable pour stocker l'image en base64

  bool visibility = false;
  bool isLoading = false;

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        File imageFile = File(pickedFile.path);
        _coverImageBase64 = base64Encode(imageFile.readAsBytesSync());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 50),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(context),
                const SizedBox(height: 30),
                _buildFields(context),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextLarge(
                      text: 'Ajouter une photo',
                      size: 16,
                    ),
                    GestureDetector(
                      onTap: _pickPhoto,
                      child: Container(
                        height: 50,
                        width: 50,
                        child: Icon(
                          Icons.add_photo_alternate_outlined,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_coverImageBase64.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.memory(
                          base64Decode(_coverImageBase64),
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  )
                else
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:
                            Theme.of(context).highlightColor.withOpacity(0.3),
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                sizedbox,
                sizedbox,
                NextButton(
                  onTap: () {
                    _registerUser();
                  },
                  color: isLoading ? Colors.grey : Colors.black,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        )
                      : AppTextLarge(
                          text: 'Register',
                          color: Colors.white,
                        ),
                ),
                const SizedBox(height: 20),
                _buildFooter(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 8,
          width: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
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
            text: 'Sign up for your account',
          ),
        ),
      ],
    );
  }

  Widget _buildFields(BuildContext context) {
    return Column(
      children: [
        buildTextField(
          context,
          controller: _nameController,
          placeholder: 'Enter your name',
          isNumber: false,
        ),
        const SizedBox(height: 20),
        buildTextField(
          context,
          controller: _lastnameController,
          placeholder: 'Enter your last name',
          isNumber: false,
        ),
        const SizedBox(height: 20),
        buildTextField(
          context,
          controller: _firstnameController,
          placeholder: 'Enter your first name',
          isNumber: false,
        ),
        const SizedBox(height: 20),
        buildTextField(
          context,
          controller: _genderController,
          placeholder: 'Enter your gender',
          isNumber: false,
        ),
        const SizedBox(height: 20),
        buildTextField(
          context,
          controller: _phoneNumberController,
          placeholder: 'Enter your phone number',
          isNumber: true,
        ),
        const SizedBox(height: 20),
        buildPasswordField(context),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.30,
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(width: 8),
            AppText(text: 'Or login with'),
            const SizedBox(width: 8),
            Container(
              width: MediaQuery.of(context).size.width * 0.30,
              height: 1,
              color: Colors.grey,
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSocialButton('Google', 'assets/google.png'),
            _buildSocialButton('Apple', 'assets/apple.png'),
          ],
        ),
        const SizedBox(height: 20),
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
                text: "Login",
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(String text, String assetPath) {
    return NextButton(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      width: MediaQuery.of(context).size.width * 0.4,
      color: Colors.white,
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 30,
            child: Image.asset(assetPath),
          ),
          AppTextLarge(
            text: text,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget buildPasswordField(BuildContext context) {
    return buildTextField(
      context,
      controller: _passwordController,
      placeholder: 'Enter your password',
      isNumber: false,
      suffix: GestureDetector(
        onTap: () {
          setState(() {
            visibility = !visibility;
          });
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Icon(
            visibility ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
          ),
        ),
      ),
    );
  }

  void _registerUser() async {
    // Valider les champs
    if (_nameController.text.isEmpty ||
        _lastnameController.text.isEmpty ||
        _firstnameController.text.isEmpty ||
        _genderController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _coverImageBase64.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tous les champs sont requis.")),
      );
      return;
    }

    // Activer l'état de chargement
    setState(() {
      isLoading = true;
    });

    try {
      // Préparer les données à envoyer
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://futela.com/api/users/registration"),
      );

      // Ajouter les champs de texte
      request.fields['name'] = _nameController.text;
      request.fields['lastname'] = _lastnameController.text;
      request.fields['firstname'] = _firstnameController.text;
      request.fields['gender'] = _genderController.text;
      request.fields['phoneNumber'] = _phoneNumberController.text;
      request.fields['PWD'] = _passwordController.text;

      // Ajouter l'image en base64 dans le champ `file`
      // request.files.add(http.MultipartFile.fromBytes(
      //     'file', base64Decode(_coverImageBase64),
      //     filename: 'image.jpg')); // Décommentez si vous avez une image à envoyer

      // Envoyer la requête
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Vérifier la réponse
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print(response.body);

        // Enregistrer les informations de l'utilisateur dans SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userData', jsonEncode(data['data']));
        await prefs.setBool('isLoggedIn', true);

        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Inscription réussie : ${data['message']}")),
        );

        // Naviguer vers la page d'accueil
        Navigator.pushReplacementNamed(context,
            '/main'); // Remplacez '/home' par la route vers votre page d'accueil
      } else {
        final error = jsonDecode(response.body);
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : ${error['detail']}")),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de l'inscription : $e")),
      );
    } finally {
      // Désactiver l'état de chargement
      setState(() {
        isLoading = false;
      });
    }
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
