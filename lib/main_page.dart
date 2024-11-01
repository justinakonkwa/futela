import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:futela/pages/menu/Favoris_page.dart';
import 'package:futela/pages/menu/chatpage.dart';
import 'package:futela/pages/menu/homepage.dart';
import 'package:futela/pages/menu/userpage.dart';

class MainPage extends StatefulWidget {
  final int initialIndex;

  const MainPage({this.initialIndex = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final List<Widget> _pages = const [
    Homepage(),
    FavorisPage(),
    ChatPage(),
    UserDetailsPage(),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[
          currentIndex], // Affiche la page correspondant à l'onglet actuel
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0,
        currentIndex: currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // Désactive les animations
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.search),
            label: translate("menu.menu_1"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.heart),
            label: translate("menu.menu_2"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.chat_bubble_2),
            label: translate("menu.menu_3"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.person),
            label: translate("menu.menu_4"),
          ),
        ],
      ),
    );
  }
}
