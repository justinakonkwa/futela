// ignore_for_file: prefer_const_constructors

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show Uint8List;
import 'package:flutter_translate/flutter_translate.dart';
import 'package:futela/authentification/signup_page.dart';
import 'package:futela/language/choose_language.dart';
import 'package:futela/theme/theme_provider.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/bouton_next.dart';
import 'package:futela/widgets/constantes.dart';
import 'package:futela/widgets/lign.dart';
import 'package:futela/widgets/message_widget.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:store_redirect/store_redirect.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({
    super.key,
  });

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  int _currentPageIndex = 0;
  String number = '';

  TextEditingController numbers = TextEditingController(text: '975 024 7');
  TextEditingController name = TextEditingController(text: 'Futela');
  TextEditingController adress =
      TextEditingController(text: 'Bobanga, Q/beau marché,/kinshasa');

  bool isLoading = false;
  bool isLoadingLogout = false;

  // -------- fonction to select a picture or to take a picture ----------
  showDialogConfirm() {
    //show a dialog box to ask user to confirm to remove from cart
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        surfaceTintColor: Theme.of(context).colorScheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        content: AppText(
          text: translate('chat.show_message_3'),
          textAlign: TextAlign.center,
        ),
        actions: [
          //camera method
          Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: ListTile(
              title: Center(
                child: AppText(
                  text: translate('chat.button_4'),
                ),
              ),
              titleAlignment: ListTileTitleAlignment.center,
              onTap: () async {},
            ),
          ),
          sizedbox,
          //galarie method
          Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: ListTile(
              title: Center(
                child: AppText(
                  text: translate('chat.button_5'),
                ),
              ),
              titleAlignment: ListTileTitleAlignment.center,
              onTap: () async {},
            ),
          ),

          //cancel button
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: AppText(
              text: translate('button.cancel'),
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // -------- Desconnected item from app method ----------
  showDialogLogout() {
    //show a dialog box to ask user to confirm to remove from cart
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        surfaceTintColor: Theme.of(context).colorScheme.inversePrimary,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
        ),
        content: AppText(
          text: translate("settings.logout_message"),
          textAlign: TextAlign.center,
        ),
        actions: [
          //cancel button
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: AppText(
              text: translate('button.cancel'),
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),

          //yes button
          TextButton(
            onPressed: () async {},
            child: isLoadingLogout
                ? CupertinoActivityIndicator(
                    color: Theme.of(context).colorScheme.primary)
                : AppText(text: translate("settings.logout")),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController(initialPage: _currentPageIndex);

    // Écouter les changements d'onglets et mettre à jour la page correspondante
    _tabController.addListener(() {
      if (_tabController.index != _currentPageIndex) {
        _pageController.jumpToPage(_tabController.index);
      }
    });

    // Écouter les changements de page et mettre à jour l'index de l'onglet
    _pageController.addListener(() {
      if (_pageController.page!.round() != _currentPageIndex) {
        _tabController.animateTo(
          _pageController.page!.round(),
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
        title: AppText(
          text: 'Profil',
          color: Theme.of(context).colorScheme.inverseSurface,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            children: [
              sizedbox,
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        height: 130,
                        width: 130,
                        padding: const EdgeInsets.all(50),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.tertiary,
                            width: 2,
                          ),
                          color: Theme.of(context).highlightColor,
                        ),
                      ),
                      Positioned(
                        child: InkWell(
                          onTap: () async => showDialogConfirm(),
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.tertiary,
                                width: 2,
                              ),
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            child: Icon(
                              FluentIcons.camera_28_regular,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              sizedbox,
              Container(
                padding: EdgeInsets.only(
                    left: 5.0, right: 5.0, bottom: 5.0, top: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).highlightColor,
                ),

                height: 45.0, // Hauteur totale du TabBar
                child: TabBar(
                  controller: _tabController,
                  automaticIndicatorColorAdjustment: false,
                  tabs: [
                    Tab(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal:
                                8.0), // Espace de 8 pixels à gauche et à droite
                        child: Container(
                          height: 40.0, // Hauteur fixe pour chaque onglet
                          alignment: Alignment.center,
                          child: Text(
                            translate('User'),
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          height: 40.0,
                          alignment: Alignment.center,
                          child: Text(
                            translate('Files'),
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          height: 40.0,
                          alignment: Alignment.center,
                          child: Text(
                            translate('Settings'),
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                  dividerColor: Colors.transparent,

                  indicator: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(
                        8), // Coins arrondis pour l'indicateur
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,

                  labelColor: Theme.of(context).colorScheme.inversePrimary,
                  unselectedLabelColor: Colors.grey,
                  labelPadding:
                      EdgeInsets.zero, // Réinitialiser le padding des labels
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    // Vérifiez si le widget est encore monté avant de mettre à jour l'état
                    if (mounted) {
                      setState(() {
                        _currentPageIndex = index;
                      });
                    }
                  },
                  children: [
                    SingleChildScrollView(child: user()),
                    Files(),
                    SingleChildScrollView(child: setting()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget user() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizedbox,
        Container(
          decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(
                color: Theme.of(context).colorScheme.tertiary,
              )),
          height: 50.0,
          child: CupertinoTextField(
            padding: EdgeInsets.only(left: 15),
            controller: name,
            placeholder: '',
            style: TextStyle(
              color: Theme.of(context).colorScheme.inverseSurface,
              fontFamily: 'Montserrat',
            ),
            keyboardType: TextInputType.phone,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              // border: Border.all(
              //     color: errorText != null ? Colors.red : Colors.grey),
            ),
            prefix: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Icon(CupertinoIcons.person),
            ),
          ),
        ),
        sizedbox,
        sizedbox,
        Container(
          decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(
                color: Theme.of(context).colorScheme.tertiary,
              )),
          height: 50.0,
          child: CupertinoTextField(
            padding: EdgeInsets.only(left: 15),
            controller: adress,
            placeholder: 'Bobanga, Q/beau marché,/kinshasa',
            style: TextStyle(
              color: Theme.of(context).colorScheme.inverseSurface,
              fontFamily: 'Montserrat',
            ),
            keyboardType: TextInputType.phone,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
            ),
            prefix: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Icon(CupertinoIcons.location_solid),
            ),
          ),
        ),
        sizedbox,
        sizedbox,
        IntlPhoneField(
          controller: numbers,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            hintText: translate('profile.sub_number'),
            hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 14,
                fontFamily: 'DMSans',
                decoration: TextDecoration.none,
                letterSpacing: 0),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
              ),
              borderRadius: borderRadius,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
              ),
              borderRadius: borderRadius,
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.red,
              ),
              borderRadius: borderRadius,
            ),
            border: OutlineInputBorder(
              gapPadding: 0,
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.tertiary,
              ),
              borderRadius: borderRadius,
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.background,
          ),
          initialCountryCode: 'CD',
          initialValue: number,
          onChanged: (phone) => setState(() => number = phone.completeNumber),
        ),
        sizedbox,
        sizedbox,
        NextButton(
          height: 40,
          color: Theme.of(context).colorScheme.primary,
          onTap: () async {},
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                FluentIcons.save_edit_24_regular,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              AppText(
                text: translate(
                  'Sauvegarde',
                ),
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ],
          ),
        ),
        // Container(
        //   decoration: BoxDecoration(
        //     color: Theme.of(context).colorScheme.primary,
        //     borderRadius: borderRadius,
        //   ),
        //   child: MaterialButton(
        //     onPressed: () {
        //       showModalBottomSheet(
        //
        //
        //         backgroundColor: Colors.transparent,
        //         context: context,
        //         isScrollControlled: true,
        //         builder: (BuildContext context) {
        //           return Container(
        //
        //             height: MediaQuery.of(context).size.height * 0.8, // Hauteur fixe
        //             padding: const EdgeInsets.all(
        //                 .0), // Optionnel : marges internes
        //             decoration: BoxDecoration(
        //               color:Colors.transparent,
        //               borderRadius: const BorderRadius.vertical(
        //                 top: Radius.circular(20), // Arrondir les bords du haut
        //               ),
        //             ),
        //             child: SignupPage(), // Contenu de la feuille modale
        //           );
        //         },
        //       );
        //     },
        //     child: AppText(
        //       text: translate('connexion.button_2').toUpperCase(),
        //       color: Theme.of(context).colorScheme.onBackground,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Widget Files() {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 0.0,
          crossAxisSpacing: 10.0,
        ),
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.only(top: 10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  // child: buildNetworkImage(
                  //     videos[index].imageUrl, false, 0),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 150.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: borderRadius,
                      color: Theme.of(context).highlightColor,
                    ),
                    child: Icon(
                      FluentIcons.image_16_filled,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {},
        shape: CircleBorder(),
        child: Icon(
          FluentIcons.add_48_regular,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
  }

  Widget setting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: borderRadius,
          ),
          child: Column(
            children: [
              card1(
                ontap: () {
                  showLanguagePopup(context: context);
                },
                icon: Icons.translate_outlined,
                title: translate("settings.language"),
                icon2: Icons.switch_right_outlined,
                showLast: false,
              ),
              Consumer<ThemeProvider>(
                builder: (context, provider, child) {
                  bool theme = provider.currentTheme;
                  return myCard(
                    ontap: () => provider.changeTheme(!theme),
                    context: context,
                    fistWidget:
                        const Icon(FluentIcons.brightness_high_48_filled),
                    title: theme
                        ? translate('theme.light')
                        : translate('theme.dark'),
                    secondWidget: const Icon(FluentIcons.arrow_fit_20_regular),
                    showLast: true,
                  );
                },
              ),
            ],
          ),
        ),
        sizedbox,
        sizedbox,
        AppText(
          text: translate("settings.support_and_feedback").toUpperCase(),
        ),
        Container(
          margin: const EdgeInsets.only(
            top: 8,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: borderRadius,
          ),
          child: Column(
            children: [
              myCard(
                ontap: () {
                  showMessageDialog(context,
                      title: translate("settings.contactUs"),
                      widget: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppText(text: 'WWW.Futela.com'),
                        ],
                      ),
                      isConfirmation: false,
                      isSale: false);
                },
                context: context,
                fistWidget: const Icon(FluentIcons.call_48_regular),
                title: translate("settings.contactUs"),
                showLast: false,
              ),
              myCard(
                ontap: () {
                  // donner les avis
                  StoreRedirect.redirect(
                    androidAppId: 'com.naara.futela',
                    iOSAppId: 'com.naara.futela',
                  );
                },
                context: context,
                fistWidget: const Icon(FluentIcons.star_half_28_regular),
                title: translate("settings.leaveReview"),
                showLast: true,
              ),
              // card1(
              //     ontap: () {
              //
              //     },
              //     icon: CupertinoIcons.share,
              //     title: translate("settings.shareApp"),
              //     showLast: true)
            ],
          ),
        ),
        const SizedBox(height: 20),
        AppText(
          text: translate("settings.app").toUpperCase(),
        ),
        Container(
          margin: const EdgeInsets.only(
            top: 8,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: borderRadius,
          ),
          child: Column(
            children: [
              myCard(
                ontap: () {
                  // myLaunchUrl(
                  //     'https://raw.githubusercontent.com/Pacome0106/isKiling_app_info/main/README.md');
                },
                context: context,
                fistWidget: const Icon(FluentIcons.shield_error_24_regular),
                title: translate("settings.privacy_policy"),
                showLast: false,
              ),
              myCard(
                ontap: () {
                  // myLaunchUrl(
                  //     'https://raw.githubusercontent.com/Pacome0106/isKiling_app_info/main/conditions.md');
                },
                context: context,
                fistWidget:
                    const Icon(FluentIcons.book_question_mark_24_regular),
                title: translate("settings.terms_and_conditions"),
                showLast: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          margin: const EdgeInsets.only(
            top: 8,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).highlightColor,
            borderRadius: borderRadius,
          ),
          child: myCard(
            ontap: () => showDialogLogout(),
            context: context,
            fistWidget: const Icon(FluentIcons.sign_out_24_regular),
            secondWidget: const SizedBox(),
            title: translate("settings.logout"),
            showLast: true,
          ),
        ),
        sizedbox,
        sizedbox,
      ],
    );
  }

  Widget myCard({
    required BuildContext context,
    required Function() ontap,
    required Widget fistWidget,
    required String title,
    Widget secondWidget = const Icon(FluentIcons.ios_chevron_right_20_regular),
    bool showLast = false,
  }) {
    return InkWell(
      onTap: ontap,
      child: Column(
        children: [
          ListTile(
            leading: fistWidget,
            title: Container(
              alignment: Alignment.centerLeft,
              child: AppText(
                text: title,
              ),
            ),
            trailing: secondWidget,
            // subtitle: Container(),
          ),
          if (!showLast) const Lign(indent: 60, endIndent: 0)
        ],
      ),
    );
  }

  Widget card1({
    required VoidCallback ontap,
    required IconData icon,
    required String title,
    IconData icon2 = Icons.navigate_next_outlined,
    bool showLast = false,
  }) {
    return InkWell(
      onTap: ontap,
      child: Column(
        children: [
          ListTile(
            leading: Icon(icon),
            title: Container(
              alignment: Alignment.centerLeft,
              child: AppText(
                text: title,
              ),
            ),
            trailing: Icon(icon2),
          ),
          if (!showLast)
            Container(
              margin: EdgeInsets.only(left: 60),
              height: 0.5,
              color: Theme.of(context).colorScheme.secondary,
            ),
        ],
      ),
    );
  }
}
