// chat_page.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futela/modeles/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:futela/authentification/login_page.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/app_text_large.dart';
import 'package:futela/widgets/bouton_next.dart';
import 'package:futela/widgets/constantes.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'Chat',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            userProvider.isLoggedIn
                ? Column(
              children: [
                AppTextLarge(
                  text:
                  "Bienvenue, ${userProvider.currentUserData!['name']}!",
                  size: 16,
                  textAlign: TextAlign.center,
                ),
                AppText(
                  text: "Voici vos messages :",
                  textAlign: TextAlign.center,
                ),
                // Ajoutez ici une liste de messages ou d'autres informations
              ],
            )
                : Column(
              children: [
                const Icon(
                  CupertinoIcons.chat_bubble_2,
                  size: 50,
                ),
                AppTextLarge(
                  text: "Connectez-vous pour consulter les messages",
                  size: 16,
                  textAlign: TextAlign.center,
                ),
                sizedbox,
                AppText(
                  text:
                  "Une fois votre connexion effectuée, les messages des hôtes apparaîtront ici.",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            sizedbox,
            NextButton(
              height: 40,
              color: Theme.of(context).colorScheme.primary,
              width: 200,
              onTap: () {
                if (userProvider.isLoggedIn) {
                  userProvider.logout();
                } else {
                  showModalBottomSheet(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return LoginPage(onLoginSuccess: (userData) {
                        userProvider.login(
                          userData['username'],
                          userData['password'],
                        );
                      });
                    },
                  );
                }
              },
              child: AppText(
                text: userProvider.isLoggedIn ? "Déconnexion" : "Connexion",
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
