import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futela/widgets/app_text.dart';
import 'package:futela/widgets/app_text_large.dart';
import 'package:futela/widgets/bouton_next.dart';
import 'package:futela/widgets/constantes.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // Fonction pour soumettre les données
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:io';

class PostArticlePage extends StatefulWidget {
  @override
  _PostArticlePageState createState() => _PostArticlePageState();
}

class _PostArticlePageState extends State<PostArticlePage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  Map<String, dynamic> _details = {};
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  File? _coverImage; // Image de couverture
  List<File> _photos = []; // Liste des photos
  String _poster = "2"; // Simule l'utilisateur connecté

  final ImagePicker _picker = ImagePicker();

  // Liste des catégories
  final List<String> _categories = [
    'Appartement',
    'Maison',
    'Terrain',
    'Salle d\'événements',
    'Voiture'
  ];

  Future<void> _pickCoverImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _coverImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _addPhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _photos.add(File(pickedFile.path));
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }
  void _submitArticle() async {
    if (_formKey.currentState!.validate()) {
      final articleData = {
        "title": titleController.text,
        "description": descriptionController.text,
        "price": priceController.text.isNotEmpty
            ? double.tryParse(priceController.text) // Valeur en double
            : null,
        "category": _selectedCategory,
        "details": _details,
        "poster": _poster,
      };

      if (_coverImage == null) {
        print('Image de couverture manquante');
      }

      if (_photos.isEmpty) {
        print('Aucune photo supplémentaire');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://www.futela.com/api/articles'),
      );

      articleData.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString(); // Convertir la valeur en String
        }
      });

      if (_coverImage != null) {
        var coverImageFile = await http.MultipartFile.fromPath(
          'cover',
          _coverImage!.path,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(coverImageFile);
      }

      for (var photo in _photos) {
        var photoFile = await http.MultipartFile.fromPath(
          'photos[]',
          photo.path,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(photoFile);
      }

      try {
        final response = await request.send();
        final responseBody = await response.stream.bytesToString();
        print('Réponse de l\'API : $responseBody');

        if (response.statusCode == 200) {
          print('Produit publié avec succès');
        } else {
          print('Erreur lors de la publication du produit: ${response.statusCode}');
          print('Détails : $responseBody');
        }
      } catch (e) {
        print('Erreur réseau : $e');
      }
    } else {
      print("Les données du formulaire sont invalides");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Publier un article')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildCupertinoTextField(
                titleController,
                placeholder: 'Titre',
                validator: (value) =>
                    value!.isEmpty ? 'Le titre est obligatoire' : null,
              ),
              SizedBox(height: 20),
              _buildCupertinoTextField(
                descriptionController,
                placeholder: 'Description',
                validator: (value) =>
                    value!.isEmpty ? 'La description est obligatoire' : null,
              ),
              SizedBox(height: 20),
              _buildCupertinoTextField(
                priceController,
                placeholder: 'Prix',
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Le prix est obligatoire' : null,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonFormField<String>(
                  padding: EdgeInsets.only(left: 10, right: 20),
                  value: _selectedCategory,
                  items: _categories
                      .map((category) => DropdownMenuItem(
                          value: category, child: Text(category)))
                      .toList(),
                  hint: Text(
                    "Veuillez sélectionner une catégorie",
                    style: TextStyle(color: Colors.grey),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                      _details = {}; // Réinitialisez les détails spécifiques.
                    });
                  },
                  decoration: InputDecoration(border: InputBorder.none),
                  validator: (value) => value == null
                      ? 'Veuillez sélectionner une catégorie'
                      : null,
                ),
              ),
              if (_selectedCategory != null) _buildCategorySpecificFields(),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextLarge(
                    text: 'Image de couverture',
                    size: 16,
                  ),
                  GestureDetector(
                    onTap: _pickCoverImage,
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Icon(
                        Icons.add_photo_alternate_outlined,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              sizedbox,
              _coverImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        _coverImage!,
                        height: 150,
                        width: MediaQuery.of(context).size.width * 0.8,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      height: 120,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:
                            Theme.of(context).highlightColor.withOpacity(0.3),
                      ),
                      child: Icon(
                        Icons.image_outlined,
                        size: 60,
                        color: Colors.grey,
                      ),
                    ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppTextLarge(
                    text: 'Photos du produit',
                    size: 16,
                  ),
                  GestureDetector(
                    onTap: _addPhoto,
                    child: Container(
                      height: 50,
                      width: 50,
                      child: Icon(
                        Icons.add_photo_alternate_outlined,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
              sizedbox,
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  ..._photos.map(
                    (photo) => ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        photo,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _addPhoto,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            Theme.of(context).highlightColor.withOpacity(0.3),
                      ),
                      child: Icon(
                        Icons.add_a_photo,
                        size: 50,
                      ),
                    ),
                  ),
                ],
              ),
              sizedbox,
              sizedbox,
              NextButton(
                color: Theme.of(context).primaryColor,
                onTap: _submitArticle,
                child: AppText(
                  text: 'Soumettre',
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCupertinoTextField(
    TextEditingController controller, {
    required String placeholder,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 50,
      child: CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        keyboardType: keyboardType,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildCategorySpecificFields() {
    switch (_selectedCategory) {
      case 'Appartement':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNumberField('Nombre de chambres', 'numberOfBedrooms'),
            _buildNumberField('Nombre de salles de bain', 'bathrooms'),
            _buildNumberField('Superficie (m²)', 'area'),
            _buildNumberField('Étage', 'floor'),
            sizedbox,
            _buildMultiSelectField(
                'Équipements',
                [
                  'Ascenseur',
                  'Climatisation',
                  'Balcon',
                  'Terrasse',
                  'Cuisine équipée',
                ],
                'equipments'),
            _buildMultiSelectField(
                'Restrictions',
                [
                  'Animaux',
                  'Type de cuisine',
                  'Vue',
                  'Type de lit',
                  'Chauffage',
                ],
                'restrictions'),
          ],
        );
      case 'Maison':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNumberField('Nombre d\'étages', 'floors'),
            _buildSwitchField('Jardin', 'garden'),
            _buildSwitchField('Piscine', 'pool'),
            _buildSwitchField('Garage', 'garage'),
            sizedbox,
            _buildMultiSelectField(
                'Caractéristiques écologiques',
                [
                  'Énergie solaire',
                  'Isolation thermique',
                  'Eau de pluie',
                ],
                'ecologicalFeatures'),
          ],
        );
      case 'Terrain':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNumberField('Superficie (m²)', 'area'),
            _buildTextField('Type de terrain', 'landType'),
            sizedbox,
            _buildMultiSelectField(
                'Accès',
                [
                  'Électricité',
                  'Eau',
                  'Route',
                ],
                'access'),
          ],
        );
      case 'Salle d\'événements':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNumberField('Capacité d\'accueil', 'capacity'),
            _buildNumberField('Superficie (m²)', 'area'),
            sizedbox,
            _buildMultiSelectField(
                'Équipements spécifiques',
                [
                  'Système de sonorisation',
                  'Cuisine équipée',
                  'Éclairage',
                  'Audiovisuels',
                  'Parking',
                ],
                'specificEquipments'),
          ],
        );
      case 'Voiture':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Marque', 'brand'),
            _buildTextField('Modèle', 'model'),
            _buildNumberField('Année', 'year'),
            _buildTextField('Type de carburant', 'fuelType'),
            _buildNumberField('Kilométrage', 'mileage'),
            sizedbox,
            _buildMultiSelectField(
                'Équipements',
                [
                  'GPS',
                  'Climatisation',
                  'Assistance routière',
                  'Options de nettoyage',
                ],
                'equipments'),
          ],
        );
      default:
        return Container();
    }
  }

  Widget _buildNumberField(String label, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizedbox,
        Text(label, style: CupertinoTheme.of(context).textTheme.textStyle),
        sizedbox,
        CupertinoTextField(
          placeholder: label,
          keyboardType: TextInputType.number,
          onChanged: (value) => _details[key] = int.tryParse(value),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: CupertinoColors.systemGrey4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String key) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        sizedbox,
        Text(label, style: CupertinoTheme.of(context).textTheme.textStyle),
        sizedbox,
        CupertinoTextField(
          placeholder: label,
          onChanged: (value) => _details[key] = value,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: CupertinoColors.systemGrey4),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchField(String label, String key) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        Checkbox(
          value: _details[key] ?? false,
          onChanged: (value) => setState(() => _details[key] = value),
        ),
      ],
    );
  }

  Widget _buildMultiSelectField(
      String label, List<String> options, String key) {
    List<String> selectedOptions = _details[key]?.cast<String>() ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 8),
        Column(
          children: options.map((option) {
            final isSelected = selectedOptions.contains(option);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(option)),
                Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        selectedOptions.add(option);
                      } else {
                        selectedOptions.remove(option);
                      }
                      _details[key] = selectedOptions;
                    });
                  },
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:futela/widgets/app_text.dart';
// import 'package:futela/widgets/app_text_large.dart';
// import 'package:futela/widgets/bouton_next.dart';
// import 'package:futela/widgets/constantes.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert'; // Pour le décodage JSON
// import 'package:shared_preferences/shared_preferences.dart';
//
// class AddProductPage extends StatefulWidget {
//   const AddProductPage({Key? key}) : super(key: key);
//
//   @override
//   _AddProductPageState createState() => _AddProductPageState();
// }
//
// class _AddProductPageState extends State<AddProductPage> {
//   final TextEditingController _denominationController = TextEditingController();
//   final TextEditingController _statusController = TextEditingController();
//   final TextEditingController _nbrRoomController = TextEditingController();
//   final TextEditingController _nbrLivingRoomController =
//       TextEditingController();
//   final TextEditingController _nbrToiletController = TextEditingController();
//   final TextEditingController _nbrShowerController = TextEditingController();
//
//   List<dynamic> _types = [];
//   String? _selectedTypeId;
//   String? _errorMessage;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadTypes();
//   }
//
//   Future<void> _loadTypes() async {
//     final String url = 'http://futela.com/api/types';
//     final response = await http.get(Uri.parse(url));
//
//     if (response.statusCode == 200) {
//       setState(() {
//         _types = jsonDecode(response.body); // Charger les types d'articles
//       });
//     } else {
//       setState(() {
//         _errorMessage =
//             'Erreur de chargement des types : ${response.statusCode}';
//       });
//     }
//   }
//
//   Future<void> _addProduct() async {
//     // Vérifie qu'un type d'article est sélectionné
//     if (_selectedTypeId == null ||
//         !_types.any((type) => type['id'].toString() == _selectedTypeId)) {
//       setState(() {
//         _errorMessage = 'Veuillez sélectionner un type d\'article valide.';
//       });
//       return;
//     }
//
//     final String url = 'http://futela.com/api/articles';
//     final prefs = await SharedPreferences.getInstance();
//     String? userData = prefs.getString('userData');
//     Map<String, dynamic>? user = userData != null ? jsonDecode(userData) : null;
//
//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'denomination': _denominationController.text,
//         'status': _statusController.text,
//         'nbrRoom': int.tryParse(_nbrRoomController.text) ?? 0,
//         's': int.tryParse(_nbrLivingRoomController.text) ?? 0,
//         'nbrToilet': int.tryParse(_nbrToiletController.text) ?? 0,
//         'nbrShower': int.tryParse(_nbrShowerController.text) ?? 0,
//         'types': [
//           {
//             'id': _selectedTypeId,
//             'name': _types.firstWhere(
//                 (type) => type['id'].toString() == _selectedTypeId,
//                 orElse: () => {'name': 'Type inconnu'})['name']
//           }
//         ],
//         'user_id': user?['id'],
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       // Traitez la réponse en cas de succès
//       final data = jsonDecode(response.body);
//       print('Produit ajouté : $data');
//       Navigator.pop(context);
//     } else {
//       setState(() {
//         _errorMessage = 'Erreur d\'ajout de produit : ${response.statusCode}';
//       });
//       print('Erreur : ${response.body}');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: Row(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Row(
//                 children: [
//                   Icon(Icons.arrow_back),
//                   SizedBox(
//                     width: 5,
//                   ),
//                   AppText(text: 'back')
//                 ],
//               ),
//             ),
//           ],
//         ),
//         title: AppText(text: 'Ajouter un produit'),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               AppTextLarge(
//                 text: 'Categorie',
//                 size: 16,
//               ),
//               sizedbox,
//               GestureDetector(
//                 onTap: () {
//                   // Ouvrir le PopupMenu lorsque le conteneur est cliqué
//                   showMenu<String>(
//                     context: context,
//                     position: const RelativeRect.fromLTRB(
//                         100, 148.0, 10, 0), // Positionnement personnalisé
//                     items: _types.map<PopupMenuEntry<String>>((type) {
//                       return PopupMenuItem<String>(
//                         value: type['id'].toString(),
//                         child: Container(
//                           width: 100, // Largeur fixe pour chaque item
//                           alignment: Alignment.bottomLeft, // Centre le texte
//                           child: Text(
//                             type['name'],
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ).then((value) {
//                     if (value != null) {
//                       setState(() {
//                         _selectedTypeId = value;
//                       });
//                     }
//                   });
//                 },
//                 child: Container(
//                   padding: EdgeInsets.only(left: 10, right: 10),
//                   height: 40,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.grey),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Affiche le texte sélectionné ou le hint text
//                       Expanded(
//                         child: Text(
//                           _selectedTypeId != null
//                               ? _types.firstWhere((type) =>
//                                   type['id'].toString() ==
//                                   _selectedTypeId)['name']
//                               : 'Sélectionnez un type d\'article',
//                           style: TextStyle(
//                               color: _selectedTypeId == null
//                                   ? Colors.grey
//                                   : Colors.black),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       // Icone pour le menu déroulant
//                       Icon(Icons.arrow_circle_down),
//                     ],
//                   ),
//                 ),
//               ),
//               sizedbox,
//               sizedbox,
//               AppTextLarge(
//                 text: 'Denomination',
//                 size: 16,
//               ),
//               sizedbox,
//               Row(
//                 children: [
//                   Container(
//                     height: 40,
//                     width: MediaQuery.of(context).size.width * 0.92,
//                     child: TextFormField(
//                       controller: _statusController,
//                       decoration: InputDecoration(
//                         suffixIcon: Icon(
//                           CupertinoIcons.textformat,
//                           color: Colors.black,
//                         ),
//                         hintText: 'Categorie du produit',
//                         contentPadding:
//                             EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//                         enabledBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                             color: Theme.of(context).highlightColor,
//                             width: 1.3,
//                           ),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderSide: BorderSide(
//                               color: Theme.of(context).highlightColor,
//                               width: 1.3),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Veuillez fournir un titre';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//               sizedbox,
//               sizedbox,
//               AppTextLarge(
//                 text: 'Prix',
//                 size: 16,
//               ),
//               sizedbox,
//               Row(
//                 children: [
//                   CustomTextField(
//                     icon: Icon(Icons.monetization_on_outlined),
//                     keyboardtype: TextInputType.number,
//                     controller: _denominationController,
//                     width: MediaQuery.of(context).size.width * 0.75,
//                     hintText: 'Prix',
//                   ),
//                   Spacer(),
//                   Container(
//                     height: 40,
//                     width: 50,
//                     decoration: BoxDecoration(
//                       border:
//                           Border.all(color: Theme.of(context).highlightColor),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Icon(Icons.monetization_on_outlined),
//                   )
//                 ],
//               ),
//               sizedbox,
//               sizedbox,
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppTextLarge(
//                         text: 'Chambre',
//                         size: 16,
//                       ),
//                       sizedbox,
//                       CustomTextField(
//                         icon: Icon(Icons.bedroom_parent_outlined),
//                         keyboardtype: TextInputType.number,
//                         controller: _denominationController,
//                         width: MediaQuery.of(context).size.width * 0.42,
//                         hintText: 'Nombre de chambre',
//                       ),
//                     ],
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppTextLarge(
//                         text: 'Salon',
//                         size: 16,
//                       ),
//                       sizedbox,
//                       CustomTextField(
//                           icon: Icon(Icons.weekend_outlined),
//                           keyboardtype: TextInputType.number,
//                           controller: _denominationController,
//                           width: MediaQuery.of(context).size.width * 0.42,
//                           hintText: 'Nombre de Salon'),
//                     ],
//                   ),
//                 ],
//               ),
//               sizedbox,
//               sizedbox,
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppTextLarge(
//                         text: 'Douche',
//                         size: 16,
//                       ),
//                       sizedbox,
//                       CustomTextField(
//                           icon:
//                               Icon(Icons.shower_outlined, color: Colors.black),
//                           keyboardtype: TextInputType.number,
//                           controller: _denominationController,
//                           width: MediaQuery.of(context).size.width * 0.42,
//                           hintText: 'Nombre de douche'),
//                     ],
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppTextLarge(
//                         text: 'Toilette',
//                         size: 16,
//                       ),
//                       sizedbox,
//                       CustomTextField(
//                         keyboardtype: TextInputType.number,
//                         controller: _denominationController,
//                         width: MediaQuery.of(context).size.width * 0.42,
//                         hintText: 'Nombre de toilette',
//                         icon: Icon(
//                           FontAwesomeIcons.toilet,
//                           size: 20,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   AppTextLarge(
//                     text: 'Ajouter des Images:',
//                     size: 16,
//                   ),
//                   IconButton(
//                     onPressed: () {},
//                     icon: const Icon(Icons.add_a_photo_outlined),
//                   ),
//                 ],
//               ),
//               Container(
//                 height: 150,
//                 width: 150,
//                 decoration: BoxDecoration(
//                   border: Border.all(color: Theme.of(context).highlightColor),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Icon(
//                   Icons.image_outlined,
//                   size: 50,
//                 ),
//               ),
//               const SizedBox(height: 20),
//               NextButton(
//                 onTap: _addProduct,
//                 child: Text('Ajouter le produit'),
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//               if (_errorMessage != null) ...[
//                 SizedBox(height: 20),
//                 Text(
//                   _errorMessage!,
//                   style: TextStyle(color: Colors.red),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String hintText;
//   final String? Function(String?)? validator;
//   final double width;
//   final Icon icon;
//   final keyboardtype;
//
//   const CustomTextField({
//     Key? key,
//     required this.controller,
//     required this.hintText,
//     this.validator,
//     required this.width,
//     required this.keyboardtype,
//     required this.icon,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40,
//       width: width,
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardtype,
//         decoration: InputDecoration(
//           suffixIcon: icon,
//           hintText: hintText,
//           hintStyle: TextStyle(
//             fontSize: 14,
//             color: Colors.grey[400],
//             fontWeight: FontWeight.w400,
//           ),
//           contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Colors.grey[300]!,
//               width: 1.3,
//             ),
//             borderRadius: BorderRadius.circular(10),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(
//               color: Colors.blue, // Remplacez par votre couleur principale
//               width: 1.3,
//             ),
//             borderRadius: BorderRadius.circular(10),
//           ),
//         ),
//         validator: validator,
//       ),
//     );
//   }
// }
