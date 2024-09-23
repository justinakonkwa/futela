import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futela/screens/categorie_details.dart';
import 'package:futela/screens/details_screen.dart';
import 'package:futela/screens/search_screen.dart';
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
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(CupertinoIcons.list_bullet_below_rectangle),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(CupertinoIcons.bell),
          ),
        ],
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.6,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Theme.of(context).highlightColor,
                    ),
                    sizedbox,
                    sizedbox,
                    AppTextLarge(
                      text: 'Futela App',
                      size: 18,
                    )
                  ],
                )),
            ListTile(
              leading: const Icon(Icons.home),
              title: AppText(text: 'Accueil'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: AppText(text: 'Recherche'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: AppText(text: 'Catégories'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategorieDetails()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: AppText(text: 'Paramètres'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: AppText(text: 'Déconnexion'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextLarge(text: 'Futela', size: 30),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
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
              ),
              const SizedBox(height: 10),
              Container(
                padding: EdgeInsets.zero,
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
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
                      'Building',
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
                                size: 30.0,
                                color: Colors.white,
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
                height: MediaQuery.of(context).size.height,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15.0,
                    mainAxisSpacing: 20.0,
                  ),
                  itemCount: 15,
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
                            const Icon(
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
                            const SizedBox(width: 5),
                            AppText(text: '5 Bds'),
                            const SizedBox(width: 12),
                            const Icon(
                              FontAwesomeIcons.couch,
                              size: 15,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 5),
                            AppText(text: 'Bds'),
                            const SizedBox(width: 12),
                            const FaIcon(FontAwesomeIcons.shower, size: 15.0),
                            const SizedBox(width: 5),
                            AppText(text: '5 Bp'),
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
