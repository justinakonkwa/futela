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
  // Liste des messages de chat simulés
  List<Map<String, String>> messages = [
    {'sender': 'User', 'message': 'Bonjour, comment ça va ?'},
    {'sender': 'Host', 'message': 'Ça va bien, merci! Et toi ?'},
    {'sender': 'User', 'message': 'Tout va bien, merci pour demander !'},
    {'sender': 'Host', 'message': 'Super! Que puis-je faire pour vous ?'},
    {'sender': 'User', 'message': 'Je voulais discuter de mon projet.'},
    {'sender': 'User', 'message': 'Je voulais discuter de mon projet.'},
    {'sender': 'User', 'message': 'Je voulais discuter de mon projet.'},
  ];

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
                // AppTextLarge(
                //   text:
                //   "Bienvenue, ${userProvider.currentUserData!['name']}!",
                //   size: 16,
                //   textAlign: TextAlign.center,
                // ),
                // AppText(
                //   text: "Voici vos messages :",
                //   textAlign: TextAlign.center,
                // ),
                // Afficher les messages dans un ListView
                Container(
                  alignment: Alignment.topLeft,
                  height: 300, // Taille du conteneur du chat
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isUserMessage = message['sender'] == 'User';
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(

                          alignment: isUserMessage
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(
                              color: isUserMessage
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: AppText(
                              text: message['message']!,
                              color: isUserMessage
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
            // NextButton(
            //   height: 40,
            //   color: Theme.of(context).colorScheme.primary,
            //   width: 200,
            //   onTap: () {
            //     if (userProvider.isLoggedIn) {
            //       userProvider.logout();
            //     } else {
            //       showModalBottomSheet(
            //         backgroundColor: Theme.of(context).colorScheme.background,
            //         context: context,
            //         isScrollControlled: true,
            //         builder: (BuildContext context) {
            //           return LoginPage(onLoginSuccess: (userData) {
            //             userProvider.login(
            //               userData['username'],
            //               userData['password'],
            //             );
            //           });
            //         },
            //       );
            //     }
            //   },
            //   child: AppText(
            //     text: userProvider.isLoggedIn ? "Déconnexion" : "Connexion",
            //     color: Colors.white,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
