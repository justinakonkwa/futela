import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    UserDetailsPage(),
  ];

  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        // backgroundColor: CupertinoColors.systemBackground,
        activeColor: Theme.of(context).colorScheme.onBackground,
        inactiveColor: CupertinoColors.inactiveGray,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: translate("menu.menu_1"),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_text),
            label: translate("menu.menu_2"),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.gear_big),
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
