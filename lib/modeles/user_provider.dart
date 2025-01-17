import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  static const String baseUrl = 'http://futela.com/api';

  bool isLoggedIn = false;
  Map<String, dynamic>? currentUserData;
  String? errorMessage;

  /// Constructeur pour charger automatiquement les données utilisateur
  UserProvider() {
    _loadUserData();
  }

  /// Charge les données utilisateur depuis SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('userData');

    if (userData != null) {
      currentUserData = json.decode(userData);
      isLoggedIn = true;
    } else {
      isLoggedIn = false;
    }
    notifyListeners();
  }

  /// Récupère le jeton utilisateur depuis SharedPreferences
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// Connexion de l'utilisateur
  Future<void> login(String username, String password) async {
    final String url = '$baseUrl/login';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userData', jsonEncode(data['data']));
        await prefs.setString('token', data['token']);
        await prefs.setBool('isLoggedIn', true);

        currentUserData = data['data'];
        isLoggedIn = true;
        errorMessage = null;
      } else {
        _handleErrorResponse(response);
      }
    } catch (e) {
      errorMessage = 'Erreur réseau. Veuillez vérifier votre connexion.';
    }

    notifyListeners();
  }

  Future<void> register({
    required String name,
    required String lastname,
    required String firstname,
    required String phoneNumber,
    required String gender,
    required String password,
    required bool commissioner,
    required bool landlord,
    required BuildContext context, // Contexte pour afficher le SnackBar
  }) async {
    // Vérification des champs obligatoires
    if (name.isEmpty ||
        lastname.isEmpty ||
        firstname.isEmpty ||
        phoneNumber.isEmpty ||
        gender.isEmpty ||
        password.isEmpty) {
      _showPopup(
        context,
        'Tous les champs doivent être remplis. Veuillez vérifier et réessayer.',
        Colors.red,
      );
      return;
    }

    final String url = '$baseUrl/app/users/registration';

    try {
      print('--- Début de la requête d\'inscription ---');
      print('URL : $url');
      print('Données envoyées : ${jsonEncode({
        'name': name,
        'lastname': lastname,
        'firstname': firstname,
        'phoneNumber': phoneNumber,
        'gender': gender,
        'password': password,
        'commissioner': commissioner,
        'landLord': landlord,
      })}');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'lastname': lastname,
          'firstname': firstname,
          'phoneNumber': phoneNumber,
          'gender': gender,
          'password': password,
          'commissioner': commissioner,
          'landLord': landlord,
        }),
      );

      print('Code de statut : ${response.statusCode}');
      print('Réponse brute : ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print('Données décodées : $data');

        // Vérification de la présence de la clé 'data' dans la réponse
        if (data.containsKey('data')) {
          final userData = data['data'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('userData', jsonEncode(userData));
          await prefs.setString('userId', userData['id'].toString());
          await prefs.setString('token', data['token']);
          await prefs.setBool('isLoggedIn', true);

          currentUserData = userData;
          isLoggedIn = true;
          errorMessage = null;

          print('Inscription réussie. Utilisateur connecté.');

          _showPopup(
            context,
            'Votre inscription a été effectuée avec succès.',
            Colors.green,
          );

          Navigator.pushReplacementNamed(context, '/authentication');
        } else {
          print('Erreur : La clé "data" est absente dans la réponse.');
          _showPopup(
            context,
            'Erreur interne. Impossible de récupérer les données utilisateur.',
            Colors.red,
          );
        }
      } else {
        print('Erreur lors de l\'inscription. Code de statut : ${response.statusCode}');
        print('Message d\'erreur : ${response.body}');

        // Vérifier si le message d'erreur spécifique est renvoyé par l'API
        if (response.body.contains("numéro de téléphone est déjà utilisé")) {
          _showPopup(
            context,
            'Ce numéro de téléphone est déjà utilisé. Veuillez en essayer un autre.',
            Colors.red,
          );
        } else {
          _handleErrorResponse(response);
          _showPopup(
            context,
            'Erreur inconnue. Veuillez vérifier les données et réessayer.',
            Colors.red,
          );
        }
      }
    } catch (e) {
      print('Exception : $e');
      errorMessage = 'Erreur réseau. Veuillez vérifier votre connexion.';

      _showPopup(
        context,
        'Une erreur est survenue. Veuillez vérifier votre connexion et réessayer.',
        Colors.red,
      );
    }

    notifyListeners();
    print('--- Fin de la requête d\'inscription ---');
  }

  void _showPopup(BuildContext context, String message, Color color) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100,
        left: 50,
        child: Material(
          color: Colors.transparent,
          child: Container(
            color: color,
            width: 300,
            height: 60,
            child: Center(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  void _handleErrorResponse(http.Response response) {
    if (response.statusCode == 400) {
      print('Erreur 400 - Mauvaise requête : ${response.body}');
    } else if (response.statusCode == 500) {
      print('Erreur 500 - Serveur interne : ${response.body}');
    } else {
      print('Erreur inconnue : ${response.body}');
    }
  }

  /// Déconnexion de l'utilisateur
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    currentUserData = null;
    isLoggedIn = false;
    notifyListeners();
  }

  /// Récupère les informations du profil de l'utilisateur
  Future<void> getUserProfile(BuildContext context) async {
    final token = await _getToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Jeton manquant. Veuillez vous reconnecter.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final String url = '$baseUrl/app/auth/profile';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Statut HTTP : ${response.statusCode}');
      print('Réponse : ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        currentUserData = data['data'];
        isLoggedIn = true;

        // Mettre à jour les données dans SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userData', jsonEncode(currentUserData));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profil récupéré avec succès.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur ${response.statusCode} : ${response.body}'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      print('Erreur : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur réseau. Veuillez réessayer.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Mise à jour du profil utilisateur
  Future<void> updateUserProfile({
    required BuildContext context,
    required String name,
    required String lastname,
    required String firstName,
    required String phoneNumber,
    required String gender,
    bool commissioner = false,
    bool landLord = false,
  }) async {
    final token = await _getToken();

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Jeton manquant. Veuillez vous reconnecter.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final int? userId = currentUserData?['id'];

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ID utilisateur non trouvé.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final String url = '$baseUrl/app/auth/profile';

    try {
      print('Token utilisé : $token');
      print('URL : $url');

      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'lastname': lastname, // Correction ici
          'firstname': firstName,
          'phoneNumber': phoneNumber,
          'gender': gender, // Correction ici
          'commissioner': commissioner,
          'landLord': landLord,
        }),
      );

      print('Statut HTTP : ${response.statusCode}');
      print('Réponse : ${response.body}');

      if (response.statusCode == 200) {
        final updatedData = jsonDecode(response.body);

        // Mettre à jour les données locales
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userData', jsonEncode(updatedData));
        currentUserData = updatedData;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mise à jour réussie.'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (response.statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur 401 : Authentification échouée.'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur ${response.statusCode} : ${response.body}'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      print('Erreur : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur réseau. Veuillez réessayer.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
