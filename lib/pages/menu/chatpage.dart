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
        title: AppText(text: 'Add Annonce',),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: Colors.black12,
            child: Icon(
              CupertinoIcons.tickets_fill,
              color: Colors.grey,
              size: 40,
            ),
          ),
          AppTextLarge(
            text:
            "Connecte-toi ou crée un compte pour avant de publier une annonce !",
            size: 16,
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
                  return Container(
                      child: LoginPage());
                },
              );
            },
            child: AppText(
              text: "S'inscrire ou se connecter",
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
