import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProfilePage extends StatefulWidget {
  final int userId; // ID de l'utilisateur passé en paramètre

  UserProfilePage({required this.userId});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final String url = 'http://futela.com/api/app/users/${widget.userId}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          userData = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Erreur: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur réseau. Veuillez vérifier votre connexion.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil utilisateur'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: userData!['cover'] != null
                    ? NetworkImage(userData!['cover'])
                    : AssetImage('assets/default_user.png') as ImageProvider,
              ),
            ),
            SizedBox(height: 20),
            Text('Nom: ${userData!['name']}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Prénom: ${userData!['firstname']}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Téléphone: ${userData!['phoneNumber']}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Sexe: ${userData!['gender']}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditUserProfilePage(userData: userData!),
                    ),
                  );
                },
                child: Text('Modifier le profil'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditUserProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  EditUserProfilePage({required this.userData});

  @override
  _EditUserProfilePageState createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController firstnameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userData['name']);
    firstnameController = TextEditingController(text: widget.userData['firstname']);
    phoneController = TextEditingController(text: widget.userData['phoneNumber']);
  }

  Future<void> updateUserProfile() async {
    final String url = 'http://futela.com/api/app/users/${widget.userData['id']}';

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': nameController.text,
          'firstname': firstnameController.text,
          'phoneNumber': phoneController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context, true); // Retourne à la page précédente avec succès
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur réseau. Veuillez réessayer.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier le profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nom'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: firstnameController,
                decoration: InputDecoration(labelText: 'Prénom'),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Téléphone'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateUserProfile();
                  }
                },
                child: Text('Enregistrer les modifications'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
