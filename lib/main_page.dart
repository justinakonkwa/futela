import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:futela/pages/homepage.dart';
import 'package:futela/pages/userpage.dart';

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
    Homepage(),
    UserDetailsPage(),
  ];

  void initState() {
    super.initState();
    currentIndex =
        widget.initialIndex; // Définit l'index initial basé sur le paramètre
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
            icon: Icon(CupertinoIcons.add_circled_solid),
            label: translate("menu.menu_2"),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: translate("menu.menu_3"),
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
