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

class _HomepageState extends State<Homepage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final PageController _pageController = PageController();

  late PageController _pageControllers;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this); // Ajusté à 7

    _pageControllers = PageController();
    // Écoutez les changements de page
    _pageControllers.addListener(() {
      setState(() {
        _currentPage = _pageControllers.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    _pageControllers.dispose(); // Libération des ressources

    super.dispose();
  }

  List<String> images = [
    'assets/house.jpg',
    'assets/house2.jpg',
    'assets/house3.avif',
    'assets/house4.avif',
    'assets/house5.avif',
    'assets/house6.avif',
  ];
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130),
          child: Column(
            children: [
              sizedbox,
              sizedbox,
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: GestureDetector(
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
                      borderRadius: BorderRadius.circular(15.0),
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
              ),
              TabBar(
                automaticIndicatorColorAdjustment: false,
                dividerColor: Theme.of(context).highlightColor,
                tabAlignment: TabAlignment.center,
                unselectedLabelColor: Colors.grey,
                padding: EdgeInsets.zero,
                indicatorPadding: EdgeInsets.zero,
                indicatorColor: Colors.black,
                indicatorWeight: 3,
                isScrollable: true,
                controller: _tabController,
                onTap: (int index) {
                  _pageController.animateToPage(
                    index,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.linear,
                  );
                },
                tabs: const [
                  Tab(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Icon(
                          CupertinoIcons.house,
                        ),
                      ),
                      text: 'House'),
                  Tab(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Icon(
                          FontAwesomeIcons.city,
                        ),
                      ),
                      text: 'Apartment'),
                  Tab(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Icon(
                          FontAwesomeIcons.building,
                        ),
                      ),
                      text: 'Skyscrape'),
                  Tab(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Icon(CupertinoIcons.house),
                      ),
                      text: 'Apartment'),
                  Tab(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Icon(
                          FontAwesomeIcons.city,
                        ),
                      ),
                      text: 'Apartment'),
                  Tab(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Icon(
                          FontAwesomeIcons.building,
                        ),
                      ),
                      text: 'Apartment'),
                  Tab(
                      icon: Padding(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child: Icon(
                          FontAwesomeIcons.city,
                        ),
                      ),
                      text: 'Apartment'),
                ],
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.6,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Theme.of(context).highlightColor,
                  ),
                  SizedBox(height: 10), // Utilise SizedBox directement
                  SizedBox(height: 10),
                  const Text('Futela App', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Accueil'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: const Text('Recherche'),
              onTap: () {
                // Ajoute ta logique de navigation ici
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Catégories'),
              onTap: () {
                // Ajoute ta logique de navigation ici
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Paramètres'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (int index) {
          _tabController.animateTo(index);
        },
        children: [
          _buildPage1(),
          _buildPage1(),
          _buildPage1(),
          _buildPage1(),
          _buildPage1(),
          _buildPage1(),
          _buildPage1(),
        ],
      ),
    );
  }

  // Dans la classe _HomepageState
  Widget _buildPage1() {
    // Créez un nouveau contrôleur pour chaque instance de _buildPage1
    final PageController innerPageController = PageController();

    return ListView.builder(
      itemCount: 10, // Nombre de conteneurs
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300.0, // Hauteur du conteneur
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView.builder(
                      controller:
                          innerPageController, // Utilisation du nouveau contrôleur
                      itemCount: images.length, // Nombre d'images
                      itemBuilder: (context, imageIndex) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0.0),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(
                                    images[imageIndex]), // Image correspondante
                                fit: BoxFit
                                    .cover, // L'image prend tout le conteneur
                              ),
                              borderRadius: BorderRadius.circular(
                                  10), // Ajout de coins arrondis
                            ),
                          ),
                        );
                      },
                    ),
                    const Positioned(
                      top: 15.0,
                      right: 15.0,
                      child: Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ),
                    _buildPageIndicator(images.length),
                  ],
                ),
              ),
              Row(
                children: [
                  AppTextLarge(
                    text: 'Kitambo, kinshasa',
                    size: 16,
                  ),
                  Spacer(),
                  Icon(
                    Icons.star,
                    size: 20,
                  ),
                  sizedbox2,
                  AppTextLarge(
                    text: '5.0',
                    size: 16,
                  )
                ],
              ),
              Row(
                children: [
                  AppText(text: 'Professionnel.'),
                  sizedbox2,
                  AppText(text: 'Posté: 12/12/2025'),
                ],
              ),
              Row(
                children: [
                  AppTextLarge(text: '2 500\$', size: 16),
                  sizedbox2,
                  AppText(text: 'par mois.'),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildPageIndicator(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
          height: 8.0,
          width: 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == _currentPage
                ? Colors.blueAccent
                : Colors.grey, // Change de couleur selon l'état
          ),
        );
      }),
    );
  }
}
//
//       Scaffold(
//       appBar: AppBar(
//         leading: Builder(
//           builder: (context) {
//             return IconButton(
//               icon: const Icon(CupertinoIcons.list_bullet_below_rectangle),
//               onPressed: () {
//                 Scaffold.of(context).openDrawer();
//               },
//             );
//           },
//         ),
//         actions: const [
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Icon(CupertinoIcons.bell),
//           ),
//         ],
//       ),
//       drawer: Drawer(
//         width: MediaQuery.of(context).size.width * 0.6,
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             DrawerHeader(
//                 decoration: BoxDecoration(),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     CircleAvatar(
//                       radius: 40,
//                       backgroundColor: Theme.of(context).highlightColor,
//                     ),
//                     sizedbox,
//                     sizedbox,
//                     AppTextLarge(
//                       text: 'Futela App',
//                       size: 18,
//                     )
//                   ],
//                 )),
//             ListTile(
//               leading: const Icon(Icons.home),
//               title: AppText(text: 'Accueil'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.search),
//               title: AppText(text: 'Recherche'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SearchScreen()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.category),
//               title: AppText(text: 'Catégories'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => CategorieDetails()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.settings),
//               title: AppText(text: 'Paramètres'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: AppText(text: 'Déconnexion'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(15.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AppTextLarge(text: 'Futela', size: 30),
//               const SizedBox(height: 10),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => SearchScreen(),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   width: double.infinity,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8.0),
//                     color: Theme.of(context).highlightColor,
//                   ),
//                   child: Row(
//                     children: [
//                       const Icon(CupertinoIcons.search),
//                       AppText(text: 'Search ...'),
//                       const Spacer(),
//                       const Icon(CupertinoIcons.mic_solid),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Container(
//                 padding: EdgeInsets.zero,
//                 height: 100,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: 5,
//                   itemBuilder: (context, index) {
//                     final List<IconData> icons = [
//                       FontAwesomeIcons.house,
//                       FontAwesomeIcons.city,
//                       FontAwesomeIcons.building,
//                       FontAwesomeIcons.building,
//                       FontAwesomeIcons.houseChimneyWindow
//                     ];
//
//                     final List<String> titles = [
//                       'House',
//                       'Apartment',
//                       'Skyscrape',
//                       'Building',
//                       'House',
//                     ];
//                     return GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (context) => CategorieDetails()));
//                       },
//                       child: Card(
//                         color: Theme.of(context).colorScheme.surface,
//                         child: Container(
//                           width: 70.0,
//                           margin: const EdgeInsets.all(8.0),
//                           decoration: BoxDecoration(
//                             color: Theme.of(context).highlightColor,
//                             borderRadius: borderRadius,
//                           ),
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 icons[index],
//                                 size: 30.0,
//                                 color: Colors.white,
//                               ),
//                               AppText(text: titles[index]),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(height: 10),
//               AppTextLarge(text: 'Featured Listing'),
//               const SizedBox(height: 10),
//               Container(
//                 height: MediaQuery.of(context).size.height,
//                 child: GridView.builder(
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 15.0,
//                     mainAxisSpacing: 20.0,
//                   ),
//                   itemCount: 15,
//                   itemBuilder: (context, index) {
//                     return Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.of(context).push(
//                               MaterialPageRoute(
//                                 builder: (context) => ProductPage(),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             height: 130,
//                             decoration: BoxDecoration(
//                                 image: const DecorationImage(
//                                     image: AssetImage('assets/house.jpg'),
//                                     fit: BoxFit.fill),
//                                 color: Colors.orange,
//                                 borderRadius: borderRadius),
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             const Icon(
//                               CupertinoIcons.location_solid,
//                               size: 15,
//                             ),
//                             AppTextLarge(
//                               text: 'Ma campagne',
//                               color: Colors.blue,
//                               size: 16,
//                               textAlign: TextAlign.start,
//                             ),
//                             const Spacer(),
//                             AppTextLarge(
//                               text: '\$150',
//                               textAlign: TextAlign.start,
//                               size: 16,
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             const Icon(
//                               FontAwesomeIcons.bed,
//                               size: 15,
//                               color: Colors.green,
//                             ),
//                             const SizedBox(width: 5),
//                             AppText(text: '5 Bds'),
//                             const SizedBox(width: 12),
//                             const Icon(
//                               FontAwesomeIcons.couch,
//                               size: 15,
//                               color: Colors.blue,
//                             ),
//                             const SizedBox(width: 5),
//                             AppText(text: 'Bds'),
//                             const SizedBox(width: 12),
//                             const FaIcon(FontAwesomeIcons.shower, size: 15.0),
//                             const SizedBox(width: 5),
//                             AppText(text: '5 Bp'),
//                           ],
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
