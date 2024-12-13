import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  Map<String, List<String>> categoryImages = {
    'House': [
      'assets/house3.avif',
      'assets/house4.avif',
      'assets/house5.avif',
      'assets/house6.avif',
      'assets/house.jpg',
      'assets/house.jpg',
    ],
    'Apartment': [
      'assets/house2.jpg',
      'assets/house5.avif',
      'assets/house6.avif',
      'assets/house2.jpg',
    ],
    'Skyscraper': [
      'assets/house4.avif',
      'assets/house5.avif',
      'assets/house2.jpg',
      'assets/house3.avif',
      'assets/house3.avif',
    ],
  };

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
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                labelColor: Theme.of(context).colorScheme.inverseSurface,
                automaticIndicatorColorAdjustment: false,
                dividerColor: Theme.of(context).highlightColor,
                tabAlignment: TabAlignment.center,
                unselectedLabelColor: Colors.grey,
                padding: EdgeInsets.zero,
                indicatorPadding: EdgeInsets.zero,
                indicatorColor: Theme.of(context).colorScheme.inverseSurface,
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
                        padding: EdgeInsets.only(
                          bottom: 10.0,
                        ),
                        child: Icon(
                          CupertinoIcons.house,
                        ),
                      ),
                      text: 'Maison'),
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
                      text: 'Salle de fete'),
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
          _buildPage1('House'),
          _buildPage1('Apartment'),
          _buildPage1('Skyscraper'),
          _buildPage1('Apartment'), // Modifie en fonction de tes catégories
          _buildPage1('Skyscraper'),
          _buildPage1('Apartment'),
          _buildPage1('House'),
        ],
      ),
    );
  }

  // Dans la classe _HomepageState
  Widget _buildPage1(String category) {
    final PageController innerPageController = PageController();
    List<String> images =
    categoryImages[category]!; // Récupère les images de la catégorie

    return ListView.builder(
      itemCount: 10, // Nombre de conteneurs
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
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
                      controller: innerPageController,
                      itemCount: images.length,
                      itemBuilder: (context, imageIndex) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductPage(
                                  imagePath: images,
                                  index: index,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(images[imageIndex]),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
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
              sizedbox,
              Row(
                children: [
                  AppTextLarge(
                    text: 'Kitambo, Kinshasa DRC',
                    size: 16,
                  ),
                  const Spacer(),
                  const Icon(
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
              AppText(text: 'Professionnel.'),
              sizedbox2,
              AppText(text: '12-12-2025'),
              const SizedBox(
                height: 5.0,
              ),
              Row(
                children: [
                  AppTextLarge(text: '2 500\$', size: 16),
                  sizedbox2,
                  AppText(text: 'par mois.'),
                ],
              ),

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
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:futela/screens/categorie_details.dart';
// import 'package:futela/screens/details_screen.dart';
// import 'package:futela/screens/search_screen.dart';
// import 'package:futela/widgets/app_text.dart';
// import 'package:futela/widgets/app_text_large.dart';
// import 'package:futela/widgets/constantes.dart';
//
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class Homepage extends StatefulWidget {
//   const Homepage({super.key});
//
//   @override
//   State<Homepage> createState() => _HomepageState();
// }
//
// class _HomepageState extends State<Homepage> with TickerProviderStateMixin {
//   late TabController _tabController;
//   final PageController _pageController = PageController();
//
//   List<dynamic> categories = [];
//   bool isLoading = true; // Indicateur de chargement des catégories
//   int _currentPage = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 0, vsync: this);
//     fetchCategoriesWithArticles(); // Charger les catégories et articles dès le démarrage
//   }
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     _pageController.dispose();
//     super.dispose();
//   }
//
//   // Charger toutes les catégories avec leurs articles associés
//   Future<void> fetchCategoriesWithArticles() async {
//     try {
//       final response = await http.get(Uri.parse('http://www.futela.com/api/categories'));
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           categories = data; // Charger toutes les catégories et leurs articles
//           _tabController =
//               TabController(length: categories.length, vsync: this);
//           isLoading = false;
//         });
//         // Charger les articles pour chaque catégorie
//         await _fetchArticlesForCategories();
//       } else {
//         throw Exception('Erreur lors du chargement des catégories');
//       }
//     } catch (e) {
//       print("Erreur: $e");
//     }
//   }
//
//   // Fonction pour charger les articles pour chaque catégorie
//   Future<void> _fetchArticlesForCategories() async {
//     for (var category in categories) {
//       try {
//         final response = await http
//             .get(Uri.parse('http://futela.com/api/types/${category['id']}'));
//         if (response.statusCode == 200) {
//           final categoryData = json.decode(response.body);
//           setState(() {
//             category['articles'] = categoryData[
//                 'articles']; // Assigner les articles à la catégorie
//           });
//         } else {
//           print(
//               'Erreur lors du chargement des articles pour la catégorie ${category['name']}');
//         }
//       } catch (e) {
//         print("Erreur: $e");
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Builder(
//           builder: (context) {
//             return IconButton(
//               icon: const Icon(Icons.menu),
//               onPressed: () {
//                 Scaffold.of(context).openDrawer();
//               },
//             );
//           },
//         ),
//         actions: const [
//           Padding(
//             padding: EdgeInsets.all(8.0),
//             child: Icon(Icons.notifications),
//           ),
//         ],
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(130),
//           child: Column(
//             children: [
//               SizedBox(height: 20),
//               Padding(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 child: GestureDetector(
//                   onTap: () {
//                     // Action pour naviguer vers l'écran de recherche
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 20),
//                     width: double.infinity,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15.0),
//                       color: Theme.of(context).highlightColor,
//                     ),
//                     child: Row(
//                       children: [
//                         const Icon(Icons.search),
//                         const SizedBox(width: 10),
//                         const Text('Search ...'),
//                         const Spacer(),
//                         const Icon(Icons.mic),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               isLoading
//                   ? const LinearProgressIndicator()
//                   : TabBar(
//                       automaticIndicatorColorAdjustment: false,
//                       dividerColor: Theme.of(context).highlightColor,
//                       tabAlignment: TabAlignment.center,
//                       unselectedLabelColor: Colors.grey,
//                       labelColor: Colors.black,
//                       padding: EdgeInsets.zero,
//                       indicatorPadding: EdgeInsets.zero,
//                       indicatorColor: Colors.black,
//                       controller: _tabController,
//                       isScrollable: true,
//                       indicatorWeight: 3,
//                       tabs: categories.map((category) {
//                         return Tab(
//                           icon: const Padding(
//                             padding: EdgeInsets.only(
//                               bottom: 10.0,
//                             ),
//                             child: Icon(
//                               CupertinoIcons.house,
//                             ),
//                           ),
//                           text: category['name'],
//                         );
//
//                         // Affiche le nom de chaque catégorie
//                       }).toList(),
//                       onTap: (int index) {
//                         _pageController.animateToPage(
//                           index,
//                           duration: const Duration(milliseconds: 300),
//                           curve: Curves.linear,
//                         );
//                       },
//                     ),
//             ],
//           ),
//         ),
//       ),
//       drawer: Drawer(
//         width: MediaQuery.of(context).size.width * 0.6,
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: <Widget>[
//             DrawerHeader(
//               decoration: const BoxDecoration(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   CircleAvatar(
//                     radius: 40,
//                     backgroundColor: Theme.of(context).highlightColor,
//                   ),
//                   const SizedBox(height: 10),
//                   const Text('Futela App', style: TextStyle(fontSize: 18)),
//                 ],
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.home),
//               title: const Text('Accueil'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.search),
//               title: const Text('Recherche'),
//               onTap: () {
//                 // Ajoute ta logique de navigation ici
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.category),
//               title: const Text('Catégories'),
//               onTap: () {
//                 // Ajoute ta logique de navigation ici
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.settings),
//               title: const Text('Paramètres'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text('Déconnexion'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         ),
//       ),
//       body: isLoading
//           ? const Center(
//               child:
//                   CircularProgressIndicator()) // Afficher un indicateur de chargement
//           : PageView.builder(
//               controller: _pageController,
//               onPageChanged: (int index) {
//                 _tabController.animateTo(index);
//               },
//               itemCount: categories.length,
//               itemBuilder: (context, index) {
//                 return _buildCategoryPage(categories[index]);
//               },
//             ),
//     );
//   }
//
//   Widget _buildCategoryPage(Map<String, dynamic> category) {
//     final PageController innerPageController = PageController();
//     List<dynamic> articles =
//         category['articles'] ?? []; // Récupère les articles de la catégorie
//
//     return ListView.builder(
//       itemCount: articles.length, // Nombre d'articles dans la catégorie
//       itemBuilder: (context, index) {
//         final article = articles[index]; // Récupère l'article courant
//         List<dynamic> images =
//             article['images'] ?? []; // Récupère les images de l'article
//
//         return Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: 300.0, // Hauteur du conteneur
//                 decoration: BoxDecoration(
//                   color: Colors.blueAccent.withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Stack(
//                   alignment: Alignment.bottomCenter,
//                   children: [
//                     PageView.builder(
//                       controller: innerPageController,
//                       itemCount: images.length,
//                       itemBuilder: (context, imageIndex) {
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ProductPage(
//                                   imagePath:
//                                       images[imageIndex], // Image spécifique
//                                   index: index, // Passer l'index de l'article
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 0.0),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: NetworkImage(images[
//                                       imageIndex]), // Utiliser NetworkImage pour les images à partir d'une URL
//                                   fit: BoxFit.cover,
//                                 ),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                     const Positioned(
//                       top: 15.0,
//                       right: 15.0,
//                       child: Icon(
//                         Icons.favorite,
//                         color: Colors.red,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   AppTextLarge(
//                     text: article['denomination'] ??
//                         'Kitambo, Kinshasa DRC', // Utilisez l'emplacement de l'article
//                     size: 16,
//                   ),
//                   const Spacer(),
//                   const Icon(Icons.star, size: 20),
//                   const SizedBox(width: 5),
//                   AppTextLarge(
//                     text: article['rating']?.toString() ??
//                         '5.0', // Utilisez la note de l'article
//                     size: 16,
//                   ),
//                 ],
//               ),
//               AppText(text: article['profession'] ?? 'Professionnel.'),
//               const SizedBox(height: 5),
//               AppText(
//                   text: article['date'] ??
//                       '12-12-2025'), // Utilisez la date de l'article
//               const SizedBox(height: 5),
//               Row(
//                 children: [
//                   AppTextLarge(
//                     text: article['price']?.toString() ??
//                         '2 500\$', // Utilisez le prix de l'article
//                     size: 16,
//                   ),
//                   const SizedBox(width: 5),
//                   AppText(text: 'par mois.'),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }