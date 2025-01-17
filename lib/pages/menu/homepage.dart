import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futela/screens/search_screen.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/app_text_large.dart';
import 'package:futela/widgets/constantes.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoading = true;
  Map<String, Map<String, dynamic>> categories =
      {}; // Utilisation d'un Map pour associer l'ID à la catégorie

  @override
  void initState() {
    super.initState();
    fetchCategories().then((fetchedCategories) {
      setState(() {
        // Transformation de la liste en Map pour un accès plus rapide par ID
        categories = {
          for (var category in fetchedCategories) category['id']: category
        };
        _tabController = TabController(length: categories.length, vsync: this);
        isLoading = false;
      });

      // Charger les produits pour chaque catégorie
      for (var category in categories.values) {
        fetchCategoryDetails(category['id'].toString());
      }
    });
  }

  Future<List<Map<String, dynamic>>> fetchCategories() async {
    const String url = 'http://futela.com/api/app/categories';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is List) {
          return data.map((category) {
            return {
              'id': category['id'],
              'name': category['name'],
              'properties': [], // Ajouter une liste vide pour les propriétés
              'products': [] // Liste pour les produits
            };
          }).toList();
        } else {
          throw Exception('Invalid category data format.');
        }
      } else {
        throw Exception(
            'Failed to load categories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      throw Exception('Error fetching categories: $e');
    }
  }

  Icon _getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'appartement':
        return const Icon(CupertinoIcons.house);
      case 'maison':
        return const Icon(CupertinoIcons.house);
      case 'salle de fête':
        return const Icon(FontAwesomeIcons.gift);
      case 'terrain':
        return const Icon(FontAwesomeIcons.mapMarkerAlt);
      case 'voiture':
        return const Icon(FontAwesomeIcons.car);
      default:
        return const Icon(FontAwesomeIcons.hotel);
    }
  }
  // Future<List<Map<String, dynamic>>> fetchCategories() async {
  //   const String url = 'http://futela.com/api/app/categories';
  //
  //   try {
  //     final response = await http.get(Uri.parse(url));
  //
  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //
  //       if (data is List) {
  //         return data.map((category) {
  //           return {
  //             'id': category['id'],
  //             'name': category['name'],
  //             'properties': [], // Ajouter une liste vide pour les propriétés
  //             'products': [] // Liste pour les produits
  //           };
  //         }).toList();
  //       } else {
  //         throw Exception('Invalid category data format.');
  //       }
  //     } else {
  //       throw Exception(
  //           'Failed to load categories. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error fetching categories: $e');
  //     throw Exception('Error fetching categories: $e');
  //   }
  // }

  Future<void> fetchCategoryDetails(String categoryId) async {
    final url = 'http://futela.com/api/app/categories/$categoryId';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List categoryData =
            jsonDecode(response.body); // Décoder la réponse en liste

        setState(() {
          // Recherche de la catégorie directement par son ID dans le Map
          if (categoryData.isNotEmpty) {
            for (var property in categoryData) {
              if (property['category']['id'] == categoryId) {
                print(property);
                // // Ajouter les propriétés dans la catégorie correspondante
                // categories[categoryId]!['properties'].add({
                //   'title': property['title'],
                //   'description': property['description'],
                //   'cover': property['cover'],
                // });
                print(property);
                categories[categoryId]!['products'].add({
                  'title': property['title'],
                  'description': property['description'],
                  'cover': property['cover'],
                  // Ajoutez d'autres champs nécessaires
                });
              }
            }
          } else {
            print('Aucune propriété trouvée pour cette catégorie.');
          }
        });
      } else {
        print('Erreur API : ${response.body}');
      }
    } catch (e) {
      print('Erreur lors de la récupération des détails de la catégorie : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Image.asset('assets/logofutela.png'),
        ),
        actions: [
          GestureDetector(
            onTap: () {},
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(CupertinoIcons.bell),
            ),
          ),
        ],
        bottom: isLoading
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(130),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchScreen(),
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
                      indicatorColor:
                          Theme.of(context).colorScheme.inverseSurface,
                      indicatorWeight: 2,
                      isScrollable: true,
                      controller: _tabController,
                      tabs: categories.values.map((category) {
                        return Tab(
                          icon: Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: _getCategoryIcon(category['name']),
                          ),
                          text: category['name'],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
      ),
      body: isLoading
          ? const Center(
              child: CupertinoActivityIndicator(
                radius: 20,
              ),
            )
          : TabBarView(
              controller: _tabController,
              children: categories.values.map((category) {
                return CategoryDetails(category);
              }).toList(),
            ),
    );
  }
}

class CategoryDetails extends StatelessWidget {
  final Map<String, dynamic> category;

  CategoryDetails(this.category);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: category['products'] == null || category['products'].isEmpty
          ? const Text('Aucun produit disponible pour cette catégorie.')
          : ListView.builder(
              itemCount: category['products'].length,
              itemBuilder: (context, index) {
                var product = category['products'][index];
                String productName = product['title'] ?? 'Nom inconnu';
                String description = product['description'] ?? 'Nom inconnu';

                String price = product['price'] != null
                    ? 'Prix: ${product['price']}'
                    : 'Prix indisponible';
                String? coverImage = product['cover'];

                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            height: 300.0, //
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: coverImage != null
                                ? Image.network(
                                    coverImage,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.broken_image,
                                        size: 30,
                                        color: Colors.grey,
                                      );
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return const Center(
                                          child:
                                              CupertinoActivityIndicator(), //
                                        );
                                      }
                                    },
                                  )
                                : const Icon(Icons.image,
                                    size: 50, color: Colors.grey),
                          ),
                          Positioned(
                            top: 15.0,
                            right: 15.0,
                            child: Row(
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Theme.of(context).highlightColor,
                                  ),
                                  child: const Icon(
                                    Icons.favorite_border,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      sizedbox,
                      Row(
                        children: [
                          AppTextLarge(
                            text: productName,
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
                      AppText(text: description),
                      Row(
                        children: [
                          AppTextLarge(text: price, size: 16),
                          sizedbox2,
                          AppText(text: 'par mois.'),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
