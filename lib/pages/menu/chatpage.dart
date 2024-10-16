import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futela/authentification/login_page.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/app_text_large.dart';
import 'package:futela/widgets/bouton_next.dart';
import 'package:futela/widgets/constantes.dart';

class Chatpage extends StatefulWidget {
  const Chatpage({super.key});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  @override
  Widget build(BuildContext context) {
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
            // const CircleAvatar(
            //   radius: 40,
            //   backgroundColor: Colors.black12,
            //   child: Icon(
            //     CupertinoIcons.,
            //     color: Colors.grey,
            //     size: 40,
            //   ),
            // ),
            AppTextLarge(
              text:
                  "Connecte-vous pour consulter les messages",
              size: 16,
              textAlign: TextAlign.center,
            ),
            AppText(
              text:
              "Une fois votre connexion effectuée, les messages des hôtes apparaitront ici.",
              textAlign: TextAlign.center,
            ),
            sizedbox,
            NextButton(
              height: 40,
              color: Colors.black,
              width: 200,
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: Theme.of(context).colorScheme.background,
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return Container(child: LoginPage());
                  },
                );
              },
              child: AppText(
                text: "Connexion",
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
