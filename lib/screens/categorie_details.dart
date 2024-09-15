import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futela/pages/menu/homepage.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/app_text_large.dart';
import 'package:futela/widgets/constantes.dart';

class CategorieDetails extends StatefulWidget {
  const CategorieDetails({super.key});

  @override
  State<CategorieDetails> createState() => _CategorieDetailsState();
}

class _CategorieDetailsState extends State<CategorieDetails> {
  @override
  Widget build(BuildContext context) {
    // Calcule la hauteur de chaque élément pour en afficher 4 sur l'écran
    double itemHeight = MediaQuery.of(context).size.height / 3;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: Row(
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
                  child: const Icon(
                    CupertinoIcons.arrow_left,
                    size: 20,
                  )),
              AppText(text: 'Back')
            ],
          ),
        ),
        title: AppText(
          text: 'Featured Listing',
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(CupertinoIcons.bell),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, // Une seule colonne
            childAspectRatio: MediaQuery.of(context).size.width /
                itemHeight, // Ajuster la hauteur de chaque élément
          ),
          itemCount: 35, // Nombre d'éléments dans le GridView
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: itemHeight - 80, // Hauteur ajustée pour l'image
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage('assets/house.jpg'),
                          fit: BoxFit.cover,
                        ),
                        color: Colors.orange,
                        borderRadius: borderRadius,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
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
                const SizedBox(height: 4),
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
    );
  }
}
