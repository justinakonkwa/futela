

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
import 'package:http_parser/http_parser.dart';

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
  List<String> _categories = [];
  bool _isLoadingCategories = true;


  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('http://www.futela.com/api/categories'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _categories = List<String>.from(data.map((category) => category['name']));
          _isLoadingCategories = false;
        });
      } else {
        throw Exception('Échec de la récupération des catégories');
      }
    } catch (e) {
      setState(() {
        _isLoadingCategories = false;
      });
      print('Erreur lors de la récupération des catégories : $e');
    }
  }


  final ImagePicker _picker = ImagePicker();


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
    _fetchCategories();

  }

  void _submitArticle() async {
    if (_formKey.currentState!.validate()) {
      final articleData = {

        "title": titleController.text,
        "description": descriptionController.text,
        "price": priceController.text.isNotEmpty
            ? double.tryParse(priceController.text) // Valeur en double
            : null,

        "details": _details,
      };
    print('JSON envoyé : ${jsonEncode(articleData)}');

      if (_coverImage == null) {
        print('Image de couverture manquante');
      }

      if (_photos.isEmpty) {
        print('Aucune photo supplémentaire');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("http://futela.com/api/app/properties/post"),
      );

      articleData.forEach((key, value) {
        if (value != null) {
          request.fields[key] =
              value.toString(); // Convertir la valeur en String
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
          print(
              'Erreur lors de la publication du produit: ${response
                  .statusCode}');
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
                icon: Icon(Icons.title),
                placeholder: 'Titre',
                validator: (value) =>
                value!.isEmpty ? 'Le titre est obligatoire' : null,
              ),
              SizedBox(height: 20),
              _buildCupertinoTextField(
                descriptionController,
                icon: Icon(Icons.description),
                placeholder: 'Description',
                validator: (value) =>
                value!.isEmpty ? 'La description est obligatoire' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(labelText: "Prix"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Veuillez entrer un prix.";
                  }
                  if (double.tryParse(value) == null) {
                    return "Veuillez entrer un nombre valide.";
                  }
                  return null;
                },
                onSaved: (value) {
                  priceController = (double.tryParse(value!) ?? 0.0) as TextEditingController;
                },
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
                child:DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  items: _categories
                      .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                      .toList(),
                  hint: Text("Veuillez sélectionner une catégorie"),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                      _details = {};
                    });
                  },
                  validator: (value) => value == null ? 'Veuillez sélectionner une catégorie' : null,
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
                  width: MediaQuery
                      .of(context)
                      .size
                      .width * 0.8,
                  fit: BoxFit.cover,
                ),
              )
                  : Container(
                height: 120,
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color:
                  Theme
                      .of(context)
                      .highlightColor
                      .withOpacity(0.3),
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
                        (photo) =>
                        ClipRRect(
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
                        Theme
                            .of(context)
                            .highlightColor
                            .withOpacity(0.3),
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
                color: Theme
                    .of(context)
                    .primaryColor,
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

  Widget _buildCupertinoTextField(TextEditingController controller, {
    required String placeholder,
    required Icon icon,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 50,
      child: CupertinoTextField(
        prefix: Padding(
          padding: const EdgeInsets.all(8.0),
          child: icon,
        ),
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
            _buildNumberField('Nombre de chambres', 'numberOfBedrooms', CupertinoIcons.bed_double),
            _buildNumberField('Nombre de salles de bain', 'bathrooms', CupertinoIcons.drop),
            _buildNumberField('Superficie (m²)', 'area', CupertinoIcons.square_grid_2x2),
            _buildNumberField('Étage', 'floor', CupertinoIcons.arrow_up),
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
                'equipments',
                CupertinoIcons.gear_alt),
            _buildMultiSelectField(
                'Restrictions',
                [
                  'Animaux',
                  'Type de cuisine',
                  'Vue',
                  'Type de lit',
                  'Chauffage',
                ],
                'restrictions',
                CupertinoIcons.lock),
          ],
        );

      case 'Maison':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNumberField('Nombre d\'étages', 'floors', Icons.layers),
            _buildSwitchField('Jardin', 'garden', Icons.park),
            _buildSwitchField('Piscine', 'pool', Icons.pool),
            _buildSwitchField('Garage', 'garage', Icons.garage),
            SizedBox(height: 16),
            _buildMultiSelectField(
              'Caractéristiques écologiques',
              ['Énergie solaire', 'Isolation thermique', 'Eau de pluie'],
              'ecologicalFeatures',
              Icons.eco,
            ),
          ],
        );

      case 'Terrain':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNumberField('Superficie (m²)', 'area', Icons.square_foot),
            _buildTextField('Type de terrain', 'landType', Icons.landscape),
            SizedBox(height: 16),
            _buildMultiSelectField(
              'Accès',
              ['Électricité', 'Eau', 'Route'],
              'access',
              Icons.electrical_services,
            ),
          ],
        );

      case 'Salle d\'événements':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNumberField('Capacité d\'accueil', 'capacity', Icons.people),
            _buildNumberField('Superficie (m²)', 'area', Icons.square_foot),
            SizedBox(height: 16),
            _buildMultiSelectField(
              'Équipements spécifiques',
              [
                'Système de sonorisation',
                'Cuisine équipée',
                'Éclairage',
                'Audiovisuels',
                'Parking'
              ],
              'specificEquipments',
              Icons.event,
            ),
          ],
        );

      case 'Voiture':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Marque', 'brand', Icons.directions_car),
            _buildTextField('Modèle', 'model', Icons.car_rental),
            _buildNumberField('Année', 'year', Icons.calendar_today),
            _buildTextField(
                'Type de carburant', 'fuelType', Icons.local_gas_station),
            _buildNumberField('Kilométrage', 'mileage', Icons.speed),
            SizedBox(height: 16),
            _buildMultiSelectField(
              'Équipements',
              [
                'GPS',
                'Climatisation',
                'Assistance routière',
                'Options de nettoyage'
              ],
              'equipments',
              Icons.build,
            ),
          ],
        );

      default:
        return Container();
    }
  }

  Widget _buildNumberField(String label, String key, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Row(
          children: [
            Icon(icon, size: 20, color: CupertinoColors.activeBlue),
            SizedBox(width: 8),
            Text(label, style: CupertinoTheme.of(context).textTheme.textStyle),
          ],
        ),
        SizedBox(height: 8),
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


  Widget _buildTextField(String label, String key, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Row(
          children: [
            Icon(icon, size: 20, color: CupertinoColors.activeBlue),
            SizedBox(width: 8),
            Text(label, style: CupertinoTheme.of(context).textTheme.textStyle),
          ],
        ),
        SizedBox(height: 8),
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


  Widget _buildSwitchField(String label, String key, IconData icon) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: CupertinoColors.activeBlue),
            SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 16)),
          ],
        ),
        Checkbox(
          value: _details[key] ?? false,
          onChanged: (value) => setState(() => _details[key] = value),
        ),
      ],
    );
  }


  Widget _buildMultiSelectField(String label, List<String> options, String key,
      IconData icon) {
    List<String> selectedOptions = _details[key]?.cast<String>() ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: CupertinoColors.activeBlue),
            SizedBox(width: 8),
            Text(label,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
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
