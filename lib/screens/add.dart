import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/app_text_large.dart';
import 'package:futela/widgets/bouton_next.dart';
import 'package:futela/widgets/constantes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Pour le décodage JSON
import 'package:shared_preferences/shared_preferences.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _denominationController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _nbrRoomController = TextEditingController();
  final TextEditingController _nbrLivingRoomController =
      TextEditingController();
  final TextEditingController _nbrToiletController = TextEditingController();
  final TextEditingController _nbrShowerController = TextEditingController();

  List<dynamic> _types = [];
  String? _selectedTypeId;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTypes();
  }

  Future<void> _loadTypes() async {
    final String url = 'http://futela.com/api/types';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        _types = jsonDecode(response.body); // Charger les types d'articles
      });
    } else {
      setState(() {
        _errorMessage =
            'Erreur de chargement des types : ${response.statusCode}';
      });
    }
  }

  Future<void> _addProduct() async {
    // Vérifie qu'un type d'article est sélectionné
    if (_selectedTypeId == null ||
        !_types.any((type) => type['id'].toString() == _selectedTypeId)) {
      setState(() {
        _errorMessage = 'Veuillez sélectionner un type d\'article valide.';
      });
      return;
    }

    final String url = 'http://futela.com/api/articles';
    final prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('userData');
    Map<String, dynamic>? user = userData != null ? jsonDecode(userData) : null;

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'denomination': _denominationController.text,
        'status': _statusController.text,
        'nbrRoom': int.tryParse(_nbrRoomController.text) ?? 0,
        's': int.tryParse(_nbrLivingRoomController.text) ?? 0,
        'nbrToilet': int.tryParse(_nbrToiletController.text) ?? 0,
        'nbrShower': int.tryParse(_nbrShowerController.text) ?? 0,
        'types': [
          {
            'id': _selectedTypeId,
            'name': _types.firstWhere(
                (type) => type['id'].toString() == _selectedTypeId,
                orElse: () => {'name': 'Type inconnu'})['name']
          }
        ],
        'user_id': user?['id'],
      }),
    );

    if (response.statusCode == 200) {
      // Traitez la réponse en cas de succès
      final data = jsonDecode(response.body);
      print('Produit ajouté : $data');
      Navigator.pop(context);
    } else {
      setState(() {
        _errorMessage = 'Erreur d\'ajout de produit : ${response.statusCode}';
      });
      print('Erreur : ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Icon(Icons.arrow_back),
                  SizedBox(
                    width: 5,
                  ),
                  AppText(text: 'back')
                ],
              ),
            ),
          ],
        ),
        title: AppText(text: 'Ajouter un produit'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextLarge(
                text: 'Categorie',
                size: 16,
              ),
              sizedbox,
              GestureDetector(
                onTap: () {
                  // Ouvrir le PopupMenu lorsque le conteneur est cliqué
                  showMenu<String>(
                    context: context,
                    position: const RelativeRect.fromLTRB(
                        100, 148.0, 10, 0), // Positionnement personnalisé
                    items: _types.map<PopupMenuEntry<String>>((type) {
                      return PopupMenuItem<String>(
                        value: type['id'].toString(),
                        child: Container(
                          width: 100, // Largeur fixe pour chaque item
                          alignment: Alignment.bottomLeft, // Centre le texte
                          child: Text(
                            type['name'],
                          ),
                        ),
                      );
                    }).toList(),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        _selectedTypeId = value;
                      });
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Affiche le texte sélectionné ou le hint text
                      Expanded(
                        child: Text(
                          _selectedTypeId != null
                              ? _types.firstWhere((type) =>
                                  type['id'].toString() ==
                                  _selectedTypeId)['name']
                              : 'Sélectionnez un type d\'article',
                          style: TextStyle(
                              color: _selectedTypeId == null
                                  ? Colors.grey
                                  : Colors.black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Icone pour le menu déroulant
                      Icon(Icons.arrow_circle_down),
                    ],
                  ),
                ),
              ),
              sizedbox,
              sizedbox,
              AppTextLarge(
                text: 'Denomination',
                size: 16,
              ),
              sizedbox,
              Row(
                children: [
                  Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.92,
                    child: TextFormField(
                      controller: _statusController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          CupertinoIcons.textformat,
                          color: Colors.black,
                        ),
                        hintText: 'Categorie du produit',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).highlightColor,
                            width: 1.3,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).highlightColor,
                              width: 1.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez fournir un titre';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              sizedbox,
              sizedbox,
              AppTextLarge(
                text: 'Prix',
                size: 16,
              ),
              sizedbox,
              Row(
                children: [
                  CustomTextField(
                    icon: Icon(Icons.monetization_on_outlined),
                    keyboardtype: TextInputType.number,
                    controller: _denominationController,
                    width: MediaQuery.of(context).size.width * 0.75,
                    hintText: 'Prix',
                  ),
                  Spacer(),
                  Container(
                    height: 40,
                    width: 50,
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: Theme.of(context).highlightColor),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.monetization_on_outlined),
                  )
                ],
              ),
              sizedbox,
              sizedbox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextLarge(
                        text: 'Chambre',
                        size: 16,
                      ),
                      sizedbox,
                      CustomTextField(
                        icon: Icon(Icons.bedroom_parent_outlined),
                        keyboardtype: TextInputType.number,
                        controller: _denominationController,
                        width: MediaQuery.of(context).size.width * 0.42,
                        hintText: 'Nombre de chambre',
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextLarge(
                        text: 'Salon',
                        size: 16,
                      ),
                      sizedbox,
                      CustomTextField(
                          icon: Icon(Icons.weekend_outlined),
                          keyboardtype: TextInputType.number,
                          controller: _denominationController,
                          width: MediaQuery.of(context).size.width * 0.42,
                          hintText: 'Nombre de Salon'),
                    ],
                  ),
                ],
              ),
              sizedbox,
              sizedbox,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextLarge(
                        text: 'Douche',
                        size: 16,
                      ),
                      sizedbox,
                      CustomTextField(
                          icon:
                              Icon(Icons.shower_outlined, color: Colors.black),
                          keyboardtype: TextInputType.number,
                          controller: _denominationController,
                          width: MediaQuery.of(context).size.width * 0.42,
                          hintText: 'Nombre de douche'),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextLarge(
                        text: 'Toilette',
                        size: 16,
                      ),
                      sizedbox,
                      CustomTextField(
                        keyboardtype: TextInputType.number,
                        controller: _denominationController,
                        width: MediaQuery.of(context).size.width * 0.42,
                        hintText: 'Nombre de toilette',
                        icon: Icon(
                          FontAwesomeIcons.toilet,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextLarge(
                    text: 'Ajouter des Images:',
                    size: 16,
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add_a_photo_outlined),
                  ),
                ],
              ),
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).highlightColor),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.image_outlined,
                  size: 50,
                ),
              ),
              const SizedBox(height: 20),
              NextButton(
                onTap: _addProduct,
                child: Text('Ajouter le produit'),
                color: Theme.of(context).colorScheme.primary,
              ),
              if (_errorMessage != null) ...[
                SizedBox(height: 20),
                Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final double width;
  final Icon icon;
  final keyboardtype;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    this.validator,
    required this.width,
    required this.keyboardtype,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: width,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardtype,
        decoration: InputDecoration(
          suffixIcon: icon,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
            fontWeight: FontWeight.w400,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey[300]!,
              width: 1.3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blue, // Remplacez par votre couleur principale
              width: 1.3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
