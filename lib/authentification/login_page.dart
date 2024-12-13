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
        bottom: MediaQuery.of(context).viewInsets.bottom, // Ajuste le padding en bas
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10, bottom: 50),
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
                  text: "LOGIN",
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
                text: 'Log in to your account',
              ),
            ),
            const SizedBox(height: 30),
            buildTextField(
              context,
              controller: _usernameController,
              placeholder: 'Enter your username',
              isNumber: false,
            ),
            const SizedBox(height: 20),
            buildTextField(
              context,
              controller: _passwordController,
              placeholder: 'Enter your password',
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
                    SnackBar(content: Text(userProvider.errorMessage ?? 'Login failed.')),
                  );
                }
              },

              color: Colors.black,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : AppTextLarge(
                text: 'Login',
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
                  color: Theme.of(context).highlightColor,
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
                  color: Theme.of(context).highlightColor,
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
                        return  SignupPage();
                      },
                    );
                  },
                  child: AppText(
                    text: translate("Signup"),
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

//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert'; // Pour le décodage JSON
// import 'package:futela/widgets/app_text.dart';
// import 'package:futela/widgets/constantes.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Pour SharedPreferences
//
// class LoginPage extends StatefulWidget {
//   final Function? onLoginSuccess; // Paramètre de rappel
//
//   const LoginPage({Key? key, this.onLoginSuccess}) : super(key: key);
//
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   String? _errorMessage;
//
//   Future<void> _login() async {
//     final String url = 'http://futela.com/api/login';
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'username': _usernameController.text,
//         'password': _passwordController.text,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       // Traitez la réponse en cas de succès
//       final data = jsonDecode(response.body);
//
//       // Sauvegardez les données dans SharedPreferences
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('userData', jsonEncode(data['data'])); // Sauvegarde des données utilisateur
//
//       // Appelle la fonction de succès de connexion si elle est définie
//       if (widget.onLoginSuccess != null) {
//         widget.onLoginSuccess!(data['data']);
//       }
//
//       // Fermez le modal et revenez à la page de chat
//       Navigator.pop(context); // Fermez le modal
//     } else {
//       // Traitez les erreurs
//       setState(() {
//         _errorMessage = 'Erreur de connexion: ${response.statusCode}';
//       });
//       print('Erreur: ${response.body}'); // Affiche l'erreur
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: AppText(text: 'Connexion'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(
//                 labelText: 'Nom d\'utilisateur',
//                 errorText: _errorMessage,
//               ),
//             ),
//             SizedBox(height: 10),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(
//                 labelText: 'Mot de passe',
//                 errorText: _errorMessage,
//               ),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _login,
//               child: Text('Se connecter'),
//             ),
//             if (_errorMessage != null) ...[
//               SizedBox(height: 20),
//               Text(
//                 _errorMessage!,
//                 style: TextStyle(color: Colors.red),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }
// class UserInfoPage extends StatelessWidget {
//   final Map<String, dynamic> userData;
//
//   UserInfoPage({required this.userData});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Informations Utilisateur'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Nom : ${userData['name']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             SizedBox(height: 8),
//             Text('Email : ${userData['email']}', style: TextStyle(fontSize: 16)),
//             SizedBox(height: 8),
//             Text('Téléphone : ${userData['phone']}', style: TextStyle(fontSize: 16)),
//             SizedBox(height: 8),
//             Text('Adresse : ${userData['address']}', style: TextStyle(fontSize: 16)),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Action pour modifier les informations, si nécessaire
//               },
//               child: Text('Modifier les informations'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// user_provider.dart

// user_provider.dart
