import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/app_text_large.dart';
import 'package:futela/widgets/bouton_next.dart';
import 'package:futela/widgets/constantes.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({
    Key? key,
  }) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int selectedImage = 0;
  late PageController pageController;
  double _currentAspectRatio = 1.0;

  final List<String> imagePath = [
    'assets/house.jpg',
    'assets/house.jpg',
    'assets/house.jpg',
    'assets/house.jpg',
    'assets/house.jpg',
  ];

  final List<int> colorValue = [
    0xFF123456,
    0xFF654321,
    0xFFabcdef,
    0xFF123456,
    0xFF654321,
  ];

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: selectedImage);
  }

  void _updateAspectRatio(String imagePath) {
    setState(() {
      _currentAspectRatio = 1.0; // Aspect ratio fixe pour simplification
    });
  }

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty || colorValue.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('Aucune donnée disponible'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: AppTextLarge(text: 'Details'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                const Icon(Icons.favorite_border_outlined),
                sizedbox2,
                const Icon(Icons.ios_share_outlined),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // L'image principale avec PageView
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowPicture(
                              imagePath: imagePath,
                              index: selectedImage,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 10, right: 10),
                        child: AspectRatio(
                          aspectRatio: 16 / 11,
                          child: PageView.builder(
                            itemCount: imagePath.length,
                            controller: pageController,
                            onPageChanged: (int index) {
                              _updateAspectRatio(imagePath[index]);
                              setState(() {
                                selectedImage = index;
                              });
                            },
                            itemBuilder: (BuildContext context, int index) {
                              return ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                child: Image.asset(
                                  imagePath[index],
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),

                    // Sélecteur d'images en bas
                    Positioned(
                      bottom: 10,
                      child: IntrinsicWidth(
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                              // color: Color(colorValue[selectedImage]),
                              // borderRadius: BorderRadius.circular(20),
                              ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ...List.generate(imagePath.length, (index) {
                                return GestureDetector(
                                  onTap: () {
                                    pageController.animateToPage(
                                      index,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                    _updateAspectRatio(imagePath[index]);
                                    setState(() {
                                      selectedImage = index;
                                    });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(2.0),
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      // color: Theme.of(context)
                                      //     .colorScheme
                                      //     .inversePrimary,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: selectedImage == index
                                            ? Theme.of(context)
                                                .colorScheme
                                                .primary
                                            : Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withOpacity(0.5),
                                        width: 2,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        imagePath[index],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.zero,
                            height:
                                100, // Définir une hauteur fixe pour la ListView
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                // Liste d'icônes
                                final List<IconData> icons = [
                                  FontAwesomeIcons.phone,
                                  FontAwesomeIcons.message,
                                  FontAwesomeIcons.mapLocationDot,
                                  FontAwesomeIcons.share,
                                ];

                                final List<String> titles = [
                                  'Call',
                                  'Message',
                                  'Direction',
                                  'Share',
                                ];
                                return Card(
                                  color: Theme.of(context).colorScheme.surface,
                                  child: Container(
                                    width: 70.0,
                                    margin: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).highlightColor,
                                      borderRadius: borderRadius,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          icons[index],
                                          color: Colors
                                              .black, // Couleur de l'icône
                                        ),
                                        AppText(text: titles[index]),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          sizedbox,
                          // product name
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: borderRadius,
                                border: Border.all(color: Colors.grey)),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppTextLarge(
                                      text: 'Caracteristique',
                                      textAlign: TextAlign.start,
                                    ),
                                    AppTextLarge(
                                      text: '650 \$',
                                      color: Theme.of(context).colorScheme.primary,
                                    )
                                  ],
                                ),
                                sizedbox,
                                AppText(
                                    text:
                                        'Maison à louer : 2 chambres, 1 salon, 1 salle de bains, cuisine équipée. Située dans un quartier calme avec jardin/cour et parking. Proche des commodités (écoles, supermarchés, transports).'),
                                sizedbox,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.bed,
                                          size: 40,
                                        ),
                                        AppText(text: '2 ch')
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          FontAwesomeIcons.couch,
                                        ),
                                        sizedbox2,
                                        AppText(text: '2 Sln')
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          FontAwesomeIcons.shower,
                                        ),
                                        AppText(text: '2 Slb')
                                      ],
                                    )
                                  ],
                                ),
                                sizedbox,
                                sizedbox,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          FontAwesomeIcons.utensils,
                                        ),
                                        AppText(text: '2 P')
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                            FontAwesomeIcons.squareParking),
                                        AppText(text: '2 p')
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          FontAwesomeIcons.map,
                                          size: 20,
                                        ),
                                        AppText(text: '2 m2')
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          sizedbox,
                          sizedbox,
                          NextButton(
                            color: Theme.of(context).colorScheme.primary,
                            onTap: () {},
                            child: AppText(
                              text: 'Interressée',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(left: 30.0),
      //   child: NextButton(
      //     color: Colors.grey,
      //     onTap: () {},
      //     child: AppText(
      //       text: 'Interressée',
      //     ),
      //   ),
      // ),
    );
  }
}
class ShowPicture extends StatelessWidget {
  final List<String> imagePath;
  final int index;

  const ShowPicture({
    Key? key,
    required this.imagePath,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  AppText(text:'Images'),
      ),
      body: ListView.builder(
        itemCount: imagePath.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              imagePath[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}

