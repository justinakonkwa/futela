import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futela/screens/categorie_details.dart';
import 'package:futela/screens/details_screen.dart';
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
        leading: const Icon(CupertinoIcons.list_bullet_below_rectangle),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
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
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity, //
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Theme.of(context).highlightColor,
                ),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.search),
                    AppText(text: 'Search ...'),
                    const Spacer(),
                    const Icon(CupertinoIcons.mic_solid),
                  ],
                ),
              ),
              const SizedBox(height: 10), // Espace entre les éléments
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
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CategorieDetails()));
                      },
                      child: Card(
                        color: Theme.of(context).colorScheme.surface,
                        child: Container(
                          width: 70.0,
                          margin: const EdgeInsets.all(8.0),
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
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),

              AppTextLarge(text: 'Featured Listing'),
              const SizedBox(height: 10),
              Container(
                height: MediaQuery.of(context)
                    .size
                    .height, // Hauteur fixée pour le GridView
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProductPage(),
                              ),
                            );
                          },
                          child: Container(
                            height: 130,
                            decoration: BoxDecoration(
                                image: const DecorationImage(
                                    image: AssetImage('assets/house.jpg'),
                                    fit: BoxFit.fill),
                                color: Colors.orange,
                                borderRadius: borderRadius),
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.location_solid,
                              size: 15,
                            ),
                            AppTextLarge(
                              text: 'Ma campagne',
                              color: Colors.blue,
                              size: 16,
                              textAlign: TextAlign.start,
                            ),
                            const Spacer(),
                            AppTextLarge(
                              text: '\$150',
                              textAlign: TextAlign.start,
                              size: 16,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              FontAwesomeIcons.bed,
                              size: 15,
                              color: Colors.green,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            AppText(text: '5 Bds'),
                            const SizedBox(
                              width: 12,
                            ),
                            const Icon(
                              FontAwesomeIcons.couch,
                              size: 15,
                              color: Colors.blue,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            AppText(text: 'Bds'),
                            const SizedBox(
                              width: 12,
                            ),
                            const FaIcon(FontAwesomeIcons.shower, size: 15.0),
                            const SizedBox(
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