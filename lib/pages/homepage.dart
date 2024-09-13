import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/app_text_large.dart';
import 'package:futela/widgets/constantes.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(CupertinoIcons.list_bullet_below_rectangle),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(CupertinoIcons.bell),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextLarge(text: 'Futela', size: 30),
              SizedBox(height: 10), // Utilisez SizedBox pour l'espace vertical
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double
                    .infinity, // Utilisez double.infinity au lieu de double.maxFinite
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      8.0), // Définir borderRadius si non défini
                  color: Theme.of(context).highlightColor,
                ),
                child: Row(
                  children: [
                    AppText(text: 'Search ...'),
                    Spacer(),
                    Icon(CupertinoIcons.search),
                  ],
                ),
              ),
              SizedBox(height: 10), // Espace entre les éléments
              Container(
                padding: EdgeInsets.zero,
                height: 100, // Définir une hauteur fixe pour la ListView
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    // Liste d'icônes
                    final List<IconData> icons = [
                      FontAwesomeIcons.house,
                      FontAwesomeIcons.city,
                      FontAwesomeIcons.building,
                      FontAwesomeIcons.building,
                      FontAwesomeIcons.houseChimneyWindow
                    ];

                    final List<String> titles = [
                      'House',
                      'Apartment',
                      'Skyscrape',
                      'building',
                      'House',
                    ];
                    return Card(
                      color: Theme.of(context).colorScheme.surface,
                      child: Container(
                        width: 70.0,
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          borderRadius: borderRadius,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              icons[index],
                              size: 30.0, // Taille de l'icône
                              color: Colors.white, // Couleur de l'icône
                            ),
                            AppText(text: titles[index]),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),

              AppTextLarge(text: 'Featured Listing'),
              SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context)
                    .size
                    .height, // Hauteur fixée pour le GridView
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Nombre de colonnes
                    crossAxisSpacing:
                        15.0, // Espacement horizontal entre les colonnes
                    mainAxisSpacing:
                        20.0, // Espacement vertical entre les lignes
                  ),
                  itemCount: 15, // Nombre d'éléments dans le GridView
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 130,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/house.jpg'),
                                  fit: BoxFit.fill),
                              color: Colors.orange,
                              borderRadius: borderRadius),
                        ),
                        Row(
                          children: [
                            AppText(
                              text: 'Ma campagne $index',
                              color: Colors.blue,
                              textAlign: TextAlign.start,
                            ),
                            Spacer(),
                            AppTextLarge(
                              text: '150.0\$',
                              textAlign: TextAlign.start,
                              size: 16,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.bed,
                              size: 15,
                              color: Colors.green,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            AppText(text: '5 Bds'),
                            SizedBox(
                              width: 12,
                            ),
                            Icon(
                              FontAwesomeIcons.couch,
                              size: 15,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            AppText(text: 'Bds'),
                            SizedBox(
                              width: 12,
                            ),
                            FaIcon(FontAwesomeIcons.shower, size: 15.0),
                            SizedBox(
                              width: 5,
                            ),
                            AppText(text: '5 Bp'),
                            // sizedbox2,
                            // Icon(CupertinoIcons.search),
                            // AppText(text: 'Bds'),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
