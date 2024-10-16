import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/app_text_large.dart';
import 'package:futela/widgets/bouton_next.dart';
import 'package:futela/widgets/constantes.dart';
import 'package:futela/widgets/lign.dart';

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
    'assets/house2.jpg',
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
      body: Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
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
                      child: AspectRatio(
                        aspectRatio: 16 / 14,
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
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(0),
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
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                        Spacer(),
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          child: Icon(
                            Icons.share_outlined,
                            color: Colors.black,
                          ),
                        ),
                        sizedbox2,
                        const CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          child: Icon(
                            Icons.favorite_border_rounded,
                            color: Colors.black,
                          ),
                        ),
                      ],
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
                                    duration: const Duration(milliseconds: 300),
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
                        sizedbox,
                        AppTextLarge(
                          text: 'Zuri.Camp-Tente Madini',
                          textAlign: TextAlign.start,
                          size: 25,
                        ),
                        sizedbox,
                        sizedbox,

                        Row(
                          children: [

                            Container(
                              decoration: BoxDecoration(
                                  borderRadius:BorderRadius.circular(10),
                                  border: Border.all()
                              ),
                              height: 30,width: 30.0,child: Icon(CupertinoIcons.location_solid),
                            ),
                            sizedbox2,
                            AppTextLarge(
                              text: 'Camp-Tente Espagne',
                              size: 14,
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            AppText(text: '4 Salons,  '),
                            AppText(text: '4 chambres,  '),
                            AppText(text: '2 balcon,  '),
                            AppText(text: '2 salle de bain'),
                          ],
                        ),
                        sizedbox,
                        Lign(indent: 20, endIndent: 20),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Theme.of(context).highlightColor,
                              child: Icon(
                                Icons.person,
                                color: Colors.black,
                              ),
                            ),
                            sizedbox2,
                            sizedbox2,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppTextLarge(
                                  text: 'Alias FUTELA',
                                  size: 14,
                                ),
                                AppText(
                                  text: '+243 975 054 345',
                                ),
                              ],
                            ),
                            Spacer(),
                            CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).highlightColor,
                                child: Icon(Icons.phone)),
                          ],
                        ),
                        Lign(indent: 20, endIndent: 20),

                        Row(
                          children: [

                            Container(
                              decoration: BoxDecoration(
                              borderRadius:BorderRadius.circular(10),
                                border: Border.all()
                              ),
                              height: 30,width: 30.0,child: Icon(Icons.house),
                            ),
                            sizedbox2,
                            AppTextLarge(
                              text: 'Ce que propose ce Logement',
                              size: 18,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40.0),
                          child: Column(
                            children: [
                              sizedbox,
                              Row(
                                children: [
                                  Icon(Icons.image_outlined),
                                  sizedbox2,
                                  AppText(text: 'Vue sur le montagne'),
                                ],
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Icon(Icons.image_outlined),
                                  sizedbox2,
                                  AppText(text: 'Vue sur la vallee'),
                                ],
                              ),
                              SizedBox(height: 5),

                              Row(
                                children: [
                                  Icon(Icons.food_bank_sharp),
                                  sizedbox2,
                                  AppText(text: 'cuisine'),
                                ],
                              ),
                              SizedBox(height: 5),

                              Row(
                                children: [
                                  Icon(Icons.car_repair_rounded),
                                  sizedbox2,
                                  AppText(text: 'Parking'),
                                ],
                              ),
                              SizedBox(height: 5),

                              Row(
                                children: [
                                  Icon(Icons.generating_tokens),
                                  sizedbox2,
                                  AppText(text: 'Genereateur de secrours'),
                                ],
                              ),
                              SizedBox(height: 5),

                              Row(
                                children: [
                                  Icon(Icons.electric_bolt),
                                  sizedbox2,
                                  AppText(text: 'Electricité'),
                                ],
                              ),
                              SizedBox(height: 5),

                              Row(
                                children: [
                                  Icon(Icons.wifi),
                                  sizedbox2,
                                  AppText(text: 'Wifi'),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Container(
                        //   padding: const EdgeInsets.all(10),
                        //   decoration: BoxDecoration(
                        //     borderRadius: borderRadius,
                        //     border: Border.all(color: Colors.grey),
                        //   ),
                        //   width: MediaQuery.of(context).size.width,
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           AppTextLarge(
                        //             text: 'Caracteristique',
                        //             textAlign: TextAlign.start,
                        //           ),
                        //           AppTextLarge(
                        //             text: '650 \$',
                        //             color:
                        //                 Theme.of(context).colorScheme.primary,
                        //           )
                        //         ],
                        //       ),
                        //       sizedbox,
                        //       AppText(
                        //           text:
                        //               'Maison à louer : 2 chambres, 1 salon, 1 salle de bains, cuisine équipée. Située dans un quartier calme avec jardin/cour et parking. Proche des commodités (écoles, supermarchés, transports).'),
                        //       sizedbox,
                        //       Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Row(
                        //             children: [
                        //               const Icon(
                        //                 Icons.bed,
                        //                 size: 40,
                        //               ),
                        //               AppText(text: '2 ch')
                        //             ],
                        //           ),
                        //           Row(
                        //             children: [
                        //               const Icon(
                        //                 FontAwesomeIcons.couch,
                        //               ),
                        //               sizedbox2,
                        //               AppText(text: '2 Sln')
                        //             ],
                        //           ),
                        //           Row(
                        //             children: [
                        //               const Icon(
                        //                 FontAwesomeIcons.shower,
                        //               ),
                        //               AppText(text: '2 Slb')
                        //             ],
                        //           )
                        //         ],
                        //       ),
                        //       sizedbox,
                        //       sizedbox,
                        //       Row(
                        //         mainAxisAlignment:
                        //             MainAxisAlignment.spaceBetween,
                        //         children: [
                        //           Row(
                        //             children: [
                        //               const Icon(
                        //                 FontAwesomeIcons.utensils,
                        //               ),
                        //               AppText(text: '2 P')
                        //             ],
                        //           ),
                        //           Row(
                        //             children: [
                        //               const Icon(
                        //                   FontAwesomeIcons.squareParking),
                        //               AppText(text: '2 p')
                        //             ],
                        //           ),
                        //           Row(
                        //             children: [
                        //               const Icon(
                        //                 FontAwesomeIcons.map,
                        //                 size: 20,
                        //               ),
                        //               AppText(text: '2 m2')
                        //             ],
                        //           )
                        //         ],
                        //       )
                        //     ],
                        //   ),
                        // ),
                        sizedbox,
                        sizedbox,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).highlightColor,
          ),
        ),
        height: 70,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AppTextLarge(
                    text: '2 500\$',
                    size: 18,
                  ),
                  AppText(text: ' par mois'),
                ],
              ),
              NextButton(
                width: 150.0,
                color: Theme.of(context).colorScheme.primary,
                onTap: () {},
                child: AppTextLarge(
                  text: 'Réserver',
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
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
        title: AppText(text: 'Images'),
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
