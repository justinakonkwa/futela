import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_translate/flutter_translate.dart';
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

  final List<Widget> _widgetOptions = <Widget>[
    Homepage(),
    Chatpage(),
    Chatpage(),
    UserDetailsPage(),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        border: Border(),
        backgroundColor: Colors.white,
        activeColor: Theme.of(context).colorScheme.primary,
        inactiveColor: CupertinoColors.inactiveGray,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.search),
            label: translate("menu.menu_1"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_border_rounded),
            label: translate("menu.menu_2"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.chat_bubble_text),
            label: translate("menu.menu_3"),
          ),
          BottomNavigationBarItem(
            icon: const Icon(CupertinoIcons.person),
            label: translate("menu.menu_4"),
          ),
        ],
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            return _widgetOptions[index];
          },
        );
      },
    );
  }
}
