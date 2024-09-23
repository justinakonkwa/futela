import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/app_text_large.dart';
import 'package:futela/widgets/constantes.dart'; // Make sure this is importing correctly

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int currentIndex = 0; // Move currentIndex inside the State class

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 20, left: 15.0, right: 15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: CupertinoTextField(
                      prefix: Padding(
                        padding:  EdgeInsets.only(left: 8.0),
                        child:  Icon(CupertinoIcons.search),
                      ),
                      placeholder: 'Search',
                      suffix: Padding(
                        padding:  EdgeInsets.only(right: 8.0),
                        child:  Icon(CupertinoIcons.mic_solid),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Theme.of(context).highlightColor,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(
                          context); // Correctly close the current screen
                    },
                    child: AppText(
                      text: 'Cancel',
                    ),
                  ),
                ],
              ),
              sizedbox,
              sizedbox,

              Expanded(
                child: DefaultTabController(
                  initialIndex: currentIndex,
                  length: 3,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      const TabBarView(
                        children: [
                          Center(child: Text("Aucune donnee")),
                          Center(child: Text("Aucune donnee")),
                          Center(child: Text("Aucune donnee")),

                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).hoverColor,
                          ),
                          child: ClipPath(
                            clipper: const ShapeBorderClipper(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                            child: TabBar(
                              dividerColor: Colors.transparent,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              indicatorColor: Theme.of(context).focusColor,
                              labelColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                              unselectedLabelColor:
                                  Theme.of(context).focusColor,
                              tabs: [
                                Tab(
                                    child: AppText(
                                  text: 'For sale',
                                )),
                                Tab(
                                    child: AppText(
                                  text: 'For Rent',
                                )),
                                Tab(
                                    child: AppText(
                                  text: 'For Buy',
                                )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
