import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futela/pages/menu/homepage.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/app_text_large.dart';
import 'package:futela/widgets/bouton_next.dart';
import 'package:futela/widgets/constantes.dart';
import 'package:futela/widgets/lign.dart';

class ProductPage extends StatefulWidget {
  final List<String> imagePath;
  final int index;

  const ProductPage({super.key, required this.imagePath, required this.index});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int selectedImage = 0;
  late PageController pageController;
  double _currentAspectRatio = 1.0;

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
    if (widget.imagePath.isEmpty || colorValue.isEmpty) {
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
                            imagePath: widget.imagePath,
                            index: selectedImage,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      child: AspectRatio(
                        aspectRatio: 16 / 14,
                        child: PageView.builder(
                          itemCount: widget.imagePath.length,
                          controller: pageController,
                          onPageChanged: (int index) {
                            _updateAspectRatio(widget.imagePath[index]);
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
                                widget.imagePath[index],
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Homepage(),
                                ),
                              );
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20,
                              child: Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const Spacer(),
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
                            ...List.generate(widget.imagePath.length, (index) {
                              return GestureDetector(
                                onTap: () {
                                  pageController.animateToPage(
                                    index,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                  _updateAspectRatio(widget.imagePath[index]);
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
                                      widget.imagePath[index],
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
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Theme.of(context).highlightColor,
                                ),
                              ),
                              height: 30,
                              width: 30.0,
                              child: const Icon(CupertinoIcons.location_solid),
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
                        const Lign(indent: 20, endIndent: 20),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Theme.of(context).highlightColor,
                              child: const Icon(
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
                            const Spacer(),
                            CircleAvatar(
                                radius: 25,
                                backgroundColor:
                                    Theme.of(context).highlightColor,
                                child: const Icon(
                                  Icons.phone,
                                  size: 35.0,
                                )),
                          ],
                        ),
                        const Lign(indent: 20, endIndent: 20),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Theme.of(context).highlightColor)),
                              height: 30,
                              width: 30.0,
                              child: const Icon(Icons.house),
                            ),
                            sizedbox2,
                            AppTextLarge(
                              text: 'Ce que propose ce Logement',
                              size: 18,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Column(
                            children: [
                              sizedbox,
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Theme.of(context).highlightColor,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.image_outlined,
                                    ),
                                  ),
                                  sizedbox2,
                                  AppText(text: 'Vue sur le montagne'),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Theme.of(context).highlightColor,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.image_outlined,
                                    ),
                                  ),
                                  sizedbox2,
                                  AppText(text: 'Vue sur la vallee'),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Theme.of(context).highlightColor,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.food_bank_sharp,
                                    ),
                                  ),
                                  sizedbox2,
                                  AppText(text: 'cuisine'),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Theme.of(context).highlightColor,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.car_repair_rounded,
                                    ),
                                  ),
                                  sizedbox2,
                                  AppText(text: 'Parking'),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Theme.of(context).highlightColor,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.generating_tokens,
                                    ),
                                  ),
                                  sizedbox2,
                                  AppText(text: 'Genereateur de secrours'),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Theme.of(context).highlightColor,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.electric_bolt,
                                    ),
                                  ),
                                  sizedbox2,
                                  AppText(text: 'Electricité'),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Theme.of(context).highlightColor,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.wifi,
                                    ),
                                  ),
                                  sizedbox2,
                                  AppText(text: 'Wifi'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        sizedbox,
                        sizedbox,
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Theme.of(context).highlightColor,
                                ),
                              ),
                              height: 30,
                              width: 30.0,
                              child: const Icon(
                                CupertinoIcons.location_solid,
                              ),
                            ),
                            sizedbox2,
                            AppTextLarge(
                              text: 'Où se situe le logemenet',
                              size: 18,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 38.0),
                          child: AppText(
                            text: 'Oulad Berhil, Sous-Massa-Draa, Maroc',
                          ),
                        ),
                        sizedbox,
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 5.0, right: 0.0),
                              width: double.maxFinite,
                              height: 250.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context).highlightColor,
                                border: Border.all(
                                  color: Theme.of(context).highlightColor,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Theme.of(context).highlightColor,
                                ),
                              ),
                              height: 40,
                              width: 40.0,
                              child: const Icon(
                                CupertinoIcons.location_solid,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
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
